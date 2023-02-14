using UnityEngine;
using Zenject;

namespace IdleBasesSDK.Upgrades
{
    public class UpgradesInstaller : MonoInstaller
    {
        [SerializeField] private UpgradesController _upgradesController;
        public override void InstallBindings()
        {
            Container.Bind<UpgradesController>().FromInstance(_upgradesController).NonLazy();
        }
    }
}
