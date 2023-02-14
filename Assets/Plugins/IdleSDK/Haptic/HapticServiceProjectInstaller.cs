using System;
using JetBrains.Annotations;
using UnityEngine;
using Zenject;

#pragma warning disable 0649
namespace Haptic
{
    [CreateAssetMenu(fileName = "HapticServiceProjectInstaller", menuName = "Nepix/Haptic Project Installer")]
    public class HapticServiceProjectInstaller : ScriptableObjectInstaller
    {
        public override void InstallBindings()
        {
            Container.Bind<IHapticService>().To<HapticService>().AsSingle().NonLazy();
        }

        #if UNITY_ANDROID
        /// <summary>
        /// A dummy method to force Unity to add vibrate permission.
        /// </summary>
        [UsedImplicitly]
        private void DummyVibrate()
        {
            Handheld.Vibrate();
            throw new Exception("Never call this method!");
        }
        #endif
    }
}