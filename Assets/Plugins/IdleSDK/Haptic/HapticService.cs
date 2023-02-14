using JetBrains.Annotations;
using MoreMountains.NiceVibrations;
using Zenject;

#pragma warning disable 0649
namespace Haptic
{
    public class HapticService : IHapticService
    {
        public bool enabled { get; set; } = true;
        public bool playing { get; private set; }

        [Inject, PublicAPI]
        public void Construct() 
        {
            // Works only for iOS 13+
            // DO not work on android
            MMNViOSCoreHaptics.OnHapticPatternStopped += () =>
            {
                playing = false;
            };
        } 

        public void Selection()
        {
            if (!enabled) return;
            playing = true;
            MMVibrationManager.Haptic(HapticTypes.Selection);
        }
        
        public void Success()
        {
            if (!enabled) return;
            playing = true;
            MMVibrationManager.Haptic(HapticTypes.Success);
        }
        
        public void Warning()
        {
            if (!enabled) return;
            playing = true;
            MMVibrationManager.Haptic(HapticTypes.Warning);
        }

        public void Failure()
        {
            if (!enabled) return;
            playing = true;
            MMVibrationManager.Haptic(HapticTypes.Failure);
        }

        public void LightImpact()
        {
            if (!enabled) return;
            playing = true;
            MMVibrationManager.Haptic(HapticTypes.LightImpact);
        }

        public void MediumImpact()
        {
            if (!enabled) return;
            playing = true;
            MMVibrationManager.Haptic(HapticTypes.MediumImpact);
        }

        public void HeavyImpact()
        {
            if (!enabled) return;
            playing = true;
            MMVibrationManager.Haptic(HapticTypes.HeavyImpact);
        }

        public void RigidImpact()
        {
            if (!enabled) return;
            playing = true;
            MMVibrationManager.Haptic(HapticTypes.RigidImpact);
        }

        public void SoftImpact()
        {
            if (!enabled) return;
            playing = true;
            MMVibrationManager.Haptic(HapticTypes.SoftImpact);
        }
    }
}