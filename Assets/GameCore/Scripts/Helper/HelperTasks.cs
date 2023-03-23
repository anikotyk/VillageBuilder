using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using IdleBasesSDK.Stack;
using Zenject;

public class HelperTasks : MonoBehaviour
{
    [SerializeField] private List<ItemType> _typesesToCollectByHelper;
    private List<ResourcePlace> _resourcePlaces = new List<ResourcePlace>();
    private List<ITask> _allTasks = new List<ITask>();
    private List<ITask> _availableTasks = new List<ITask>();
    private List<ITask> _unavailableTasks = new List<ITask>();

    private bool _initialized = false;

    [Inject] private Bubble _bubble;

    public List<ItemType> TypesToCollect => _typesesToCollectByHelper;
    private void OnEnable()
    {
        _bubble.Scaled += OnBubbleScaled;
    }
    
    private void OnDisable()
    {
        _bubble.Scaled -= OnBubbleScaled;
    }

    private void OnBubbleScaled(float scale)
    {
        Actualize();
    }

    private void Initialize()
    {
        if(_initialized)
            return;
        _initialized = true;
        _resourcePlaces = FindObjectsOfType<ResourcePlace>().ToList();
        _allTasks.AddRange(_resourcePlaces);
        _unavailableTasks.AddRange(_resourcePlaces);
        Actualize();
    }

    private void Actualize()
    {
        Initialize();
        List<ITask> unavailableTasks = new List<ITask>(_unavailableTasks);
        foreach (var unavailableTask in unavailableTasks)
        {
            if (unavailableTask.AvailableToHelp)
            {
                _availableTasks.Add(unavailableTask);
                _unavailableTasks.Remove(unavailableTask);
            }
        }
    }

    public Dictionary<ItemType, List<ITask>> GetNearestTasks(Predicate<ITask> predicate, Vector3 position)
    {
        Initialize();
        Dictionary<ItemType, List<ITask>> tasks = new();
        foreach (var type in _typesesToCollectByHelper)
        {
            tasks.Add(type, new List<ITask>(_resourcePlaces.FindAll(x => x.Type == type)
                .OrderBy(x => Vector3.Distance(x.TaskPoint.position, position))));
        }

        return tasks;
    }

    public ITask GetTask(Dictionary<ItemType, List<ITask>> tasksPool, Helper helper, ItemType type = ItemType.Wood, List<ITask> except = null)
    {
        Initialize();
        if (except == null)
            except = new List<ITask>();

        if (tasksPool == null)
            return null;

        if (tasksPool.ContainsKey(type) == false)
            return null;
        return tasksPool[type].Find(x => x.Active && x.AvailableToHelp && 
                                         VectorExtentions.SqrDistance(helper.transform, x.TaskPoint) > helper.AIMovement.StopDistance.Sqr()
                                         && except.Contains(x) == false);
    }
    
}
