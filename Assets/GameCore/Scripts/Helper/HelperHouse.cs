using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Stack;

public class HelperHouse : MonoBehaviour
{
    [Header("Tasks")] 
    [SerializeField] private TaskProvider _returnBaseTask;
    [SerializeField] private TaskProvider _waitTaskProvider;

    [Header("Storage")]
    [SerializeField] private StackProvider _storageStack;
    [SerializeField] private int _maxStorageCount;

    [Header("Helpers")]
    [SerializeField] private List<Helper> _helpers;

    public ITask ReturnBaseTask => _returnBaseTask.Interface;
    public ITask WaitTask => _waitTaskProvider.Interface;

    public IStack StorageStack => _storageStack.Interface;
    public int StorageCapacity => _maxStorageCount;

    public List<ITask> GetTasksInExecution()
    {
        List<ITask> tasks = new List<ITask>();
        foreach (var helper in _helpers)
        {
            if(helper.CurrentTask != WaitTask && helper.CurrentTask != ReturnBaseTask)
                tasks.Add(helper.CurrentTask);
        }

        return tasks;
    }

}
