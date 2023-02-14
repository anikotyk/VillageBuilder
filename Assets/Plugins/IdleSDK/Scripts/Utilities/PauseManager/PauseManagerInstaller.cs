using UnityEngine;
using Zenject;

namespace IdleBasesSDK.Utilities
{
    public class PauseManagerInstaller : MonoInstaller
    {
        [SerializeField] private PauseManager _pauseManager;
    
        public override void InstallBindings()
        {
            Container.Bind<PauseManager>().FromInstance(_pauseManager);
        }
    }
}

