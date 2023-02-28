using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using IdleBasesSDK.Extentions;
using IdleBasesSDK.Stack;
using Zenject;

public class ResourcePresenter : MonoBehaviour
{
    [SerializeField] private ResourceView _resourceViewPrefab;
    [SerializeField] private int _maxVisibleViewsCount;
    [SerializeField] private Transform _viewsParent;
    [SerializeField] private StackProvider _stackProvider;
    [SerializeField] private bool _changeOrder = true;

    [Inject] private ResourceController _resourceController;
    [Inject] private DiContainer _container;
    [Inject] private Player _player;

    private List<ResourceView> _visibleResourceViews;
    private Dictionary<ItemType, IntReference> Items => _player.Stack.MainStack.Items;

    public List<ResourceView> ResourceViews  {get; private set;} = new ();
    private List<ResourceView> VisibleResourceViews
    {
        get
        {
            if (_visibleResourceViews == null)
                _visibleResourceViews = new List<ResourceView>();
            return _visibleResourceViews;
        }
    }
    
    private void OnEnable()
    {
        if(_changeOrder) _player.Stack.MainStack.TypeCountChanged += OnTypeCountChanged;
    }

    private void OnDisable()
    {
        if(_changeOrder) _player.Stack.MainStack.TypeCountChanged -= OnTypeCountChanged;
    }

    private void OnTypeCountChanged(ItemType type, int count)
    {
        var resourceView = ResourceViews.Find(x=>x.ItemType == type);
        
        if (VisibleResourceViews.Count > 0 && VisibleResourceViews[0] == resourceView)
            return;
        
        VisibleResourceViews.Remove(resourceView);
        VisibleResourceViews.Insert(0, resourceView);

        /*
        Hidden stack logic
        Remove(resourceView);
        if (count < 0 && Items[type].Value <= 0)
        {
            MoveOneUp();
            for (int i = 0; i < _maxVisibleViewsCount; i++)
                if (VisibleResourceViews[i] == null)
                    VisibleResourceViews[i] = GetNonUsedView();
        }
        else
        {
            MoveOneDown();
            VisibleResourceViews[0] = resourceView;
        }
        */
        ActualizeViews();
    }
    
    private void Remove(ResourceView resourceView)
    {
        for (int i = 0; i < _maxVisibleViewsCount; i++)
        {
            if (VisibleResourceViews[i] == resourceView)
            {
                VisibleResourceViews[i] = null;
                return;
            }
        }
    }

    private void MoveOneDown()
    {
        int nullCount = 0;
        for (int i = _maxVisibleViewsCount-1; i > 0; i--)
        {
            if (VisibleResourceViews[i] == null)
            {
                nullCount++;
                VisibleResourceViews[i] = VisibleResourceViews[i - 1];
                VisibleResourceViews[i - 1] = null;
            }
        }

        if (nullCount == 0)
        {
            if(VisibleResourceViews.Count > _maxVisibleViewsCount - 1)
                VisibleResourceViews[_maxVisibleViewsCount - 1] = null;
            MoveOneDown();
        }
    }

    private void MoveOneUp()
    {
        for (int i = 0; i < _maxVisibleViewsCount - 1; i++)
        {
            if (VisibleResourceViews[i] == null)
            {
                VisibleResourceViews[i] = VisibleResourceViews[i + 1];
                VisibleResourceViews[i + 1] = null;
            }
        }
    }

    private void ActualizeViews()
    {
        foreach (var resourceView in ResourceViews)
        {
            resourceView.gameObject.SetActive(false);
        }
        
        for (int i = 0; i < _maxVisibleViewsCount; i++)
        {
            if (VisibleResourceViews[i] != null && VisibleResourceViews[i].CurrentAmount > 0)
            {
                VisibleResourceViews[i].Rect.SetSiblingIndex(i);
                VisibleResourceViews[i].gameObject.SetActive(true);
            }
        }
    }

    private ResourceView GetNonUsedView()
    {
        ResourceView view = null;
        foreach (var resourceView in ResourceViews)     
        {
            if(Items[resourceView.ItemType].Value <= 0 || VisibleResourceViews.Has(x=> x != null && x.ItemType == resourceView.ItemType))
                continue;
            
            view = resourceView;
            break;
        }

        return view;
    }
    
    private void Start()
    {
        Init();
    }
    
    private void Init()
    {
        foreach (var resource in _resourceController.Resources)
        {
            var resourceView = _container.InstantiatePrefab(_resourceViewPrefab, _viewsParent).GetComponent<ResourceView>();
            resourceView.Init(_stackProvider.Interface, resource.ItemType);
            ResourceViews.Add(resourceView);
            VisibleResourceViews.Add(resourceView);
        }
        
        ActualizeViews();
    }
    
    
}
