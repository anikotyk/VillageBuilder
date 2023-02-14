using UnityEngine;
using IdleBasesSDK;
using Zenject;

namespace IdleBasesSDK.Utilities
{
    public class TimerInstaller : MonoInstaller
    {
        [SerializeField] private Timer _timer;
        public override void InstallBindings()
        {
            Container.Bind<Timer>().FromInstance(_timer);
        }
    } 
}

