using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using Zenject;

public class UpdaterInstaller : MonoInstaller
{
    [SerializeField] private Updater _updater;
    public override void InstallBindings()
    {
        Container.Bind<Updater>().FromInstance(_updater);
    }
}
