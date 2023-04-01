using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Interactable;
using Zenject;

public class HelperTasksInstaller : MonoInstaller
{
    [SerializeField] private HelperTasks _helperTasks;

    public override void InstallBindings()
    {
        Container.Bind<HelperTasks>().FromInstance(_helperTasks);
    }
}
