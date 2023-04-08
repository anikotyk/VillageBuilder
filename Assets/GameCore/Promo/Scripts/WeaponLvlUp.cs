using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using NaughtyAttributes;
using IdleBasesSDK.Stack;
using IdleBasesSDK.Upgrades;
using IdleBasesSDK.Utilities;
using Zenject;

public class WeaponLvlUp : MonoBehaviour
{
    [SerializeField] private Transform _parent;
    [SerializeField] private UpgradeValue _upgradeValue;
    [SerializeField] private SphereCollider _weaponCollider;
    [SerializeField] private float _targetColliderSize;
    [SerializeField] private View _weaponView;
    [SerializeField] private View _effectView;
    [SerializeField] private float _lvlUpDelay;
    [SerializeField] private float _hideDelay;

    [Inject] private ResourcesFx _resourcesFx;
    [Inject] private Player _player;
    [Inject] private Timer _timer;

    private IStack Stack => _player.Stack.MainStack;
    
    [Button("Level Up")]
    private void LevelUp()
    {
        Stack.TrySpend(ItemType.Stone, 10, out IEnumerable<StackItem> items);
        foreach (var item in items)
            item.Claim();
        
        _resourcesFx.Visualize(items, transform.position, _parent, _parent.position);
        
        _timer.ExecuteWithDelay(() =>
        {
            _effectView.Show();
            _timer.ExecuteWithDelay(_weaponView.Hide, _hideDelay);
            _weaponCollider.radius = _targetColliderSize;
            
        }, _lvlUpDelay);
        
        
    }
}
