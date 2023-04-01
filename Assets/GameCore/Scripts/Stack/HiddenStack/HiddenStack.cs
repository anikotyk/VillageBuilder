using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using NaughtyAttributes;
using IdleBasesSDK.Extentions;
using IdleBasesSDK.Stack;
using UnityEngine.Events;
using Zenject;

public class HiddenStack : StackBase
{
    [Inject] private ResourceController _resourceController;

    protected override bool TryGetInstance(ItemType type, out StackItem stackItem)
    {
        stackItem = _resourceController.GetInstance(type);
        return true;
    }

    protected override IEnumerable<StackItem> GetInstances(ItemType type, int count)
    {
        return _resourceController.GetInstances(type, count);
    }
}
