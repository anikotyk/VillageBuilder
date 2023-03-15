using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Zenject;

public class PlayerDeathView : View
{
    [SerializeField] private View _view;
    [SerializeField] private PlayerDeath _playerDeath;
    [SerializeField] private MonoPool<ResourceView> _resourceViewPrefabsPool;

    [Inject] private DiContainer _container;
    private List<ResourceView> _takenViews = new List<ResourceView>();
    public override bool IsHidden => _view.IsHidden;
    
    private void Awake()
    {
        _resourceViewPrefabsPool.Initialize(_container);
    }

    public override void Show()
    {
        foreach (var lossPair in _playerDeath.GetDeathLoss())
        {
            var view =_resourceViewPrefabsPool.Get().Init(lossPair.Key, lossPair.Value);
            _takenViews.Add(view);
        }
        _view.Show();
    }

    public override void Hide()
    {
        foreach (var takenView in _takenViews)
        {
            takenView.Pool.Return(takenView);
        }
        _view.Hide();
    }
}
