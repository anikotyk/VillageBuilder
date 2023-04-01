using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using IdleBasesSDK.Interactable;
using IdleBasesSDK.Stack;
using IdleBasesSDK.Upgrades;
using TMPro;
using UnityEngine.Events;
using UnityEngine.UI;
using Zenject;

public class UpgradeView : MonoBehaviour
{
    [SerializeField] private Upgrade _upgrade;
    [SerializeField] private List<CostData> _levelCosts;
    [SerializeField] private TMP_Text _priceText;
    [SerializeField] private Image _iconImage;
    [SerializeField] private Button _upgradeButton;

    [Inject] private UpgradesController _upgradesController;
    [Inject] private ResourceController _resourceController;
    [Inject] private Player _player;
    
    private UpgradeModel _upgradeModel;
    public CostData CurrentPrice => _levelCosts[_upgradeModel.CurrentLevel];

    public UnityAction<IEnumerable<StackItem>> Upgraded { get; set; }

    private void Awake()
    {
        _upgradeModel = _upgradesController.GetModel(_upgrade);
    }

    private void OnEnable()
    {
        Actualize();
        _upgradeButton.onClick.AddListener(OnUpgradeButtonClick);
    }

    private void OnDisable()
    {
        _upgradeButton.onClick.RemoveListener(OnUpgradeButtonClick);
    }

    public void Actualize()
    {
        _upgradeButton.interactable = _upgradeModel.CanLevelUp() && HaveEnoughResource();
        _priceText.text = CurrentPrice.Amount.ToString();
        _iconImage.sprite = _resourceController.GetPrefab(CurrentPrice.Resource).Icon;
    }

    [NaughtyAttributes.Button("Click")]
    private void OnUpgradeButtonClick()
    {
        Debug.Log("Clicked");
        if(HaveEnoughResource() == false || _upgradeModel.CanLevelUp() == false)
            return;
        Debug.Log("Enough Resources");
        if(_player.Stack.MainStack.TrySpend(CurrentPrice.Resource, CurrentPrice.Amount, out IEnumerable<StackItem> stackItems) == false)
            return;
        
        Debug.Log("Spended");
        _upgradeModel.LevelUp();
        foreach (var stackItem in stackItems)
        {
            stackItem.Pool.Return(stackItem);
        }
        Upgraded?.Invoke(stackItems);
    }

    private bool HaveEnoughResource()
    {
        return _player.Stack.MainStack.Items[CurrentPrice.Resource].Value >= CurrentPrice.Amount;
    }
    
    
}
