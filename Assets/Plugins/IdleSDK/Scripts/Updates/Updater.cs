using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine.Events;

public class Updater : MonoBehaviour
{
    private List<CustomUpdate> _updates = new List<CustomUpdate>();
    
    private void Update()
    {
        foreach (var update in _updates)
        {
            update.OnUpdate();
        }
    }

    public void Add(MonoBehaviour sender, Action action, float updateTime, bool async = true)
    {
        var existed = _updates.Find(x => x.Sender == sender);
        if (existed != null)
        {
            if(existed.Action == action)
                return;
            existed.Action = action;
            existed.Delay = updateTime;
            return;
        }
        _updates.Add(new CustomUpdate(sender, action, updateTime, async));
    }

    public void Remove(MonoBehaviour sender)
    {
        var updateToRemove = _updates.Find(x => x.Sender == sender);
        if (updateToRemove != null)
            _updates.Remove(updateToRemove);
    }
}
