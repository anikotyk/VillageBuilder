using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Zenject;

public class ResourceInstaller : MonoInstaller
{
    [SerializeField] private ResourceController _resourceController;

    public override void InstallBindings()
    {
        Container.Bind<ResourceController>().FromInstance(_resourceController);
    }
}
