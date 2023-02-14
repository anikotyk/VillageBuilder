namespace Haptic
{
    public interface IHapticService
    {
                public bool enabled { get; set; }
                public void Construct();
                public void Selection();
                public void Success();
                public void Warning();
                public void Failure();
                public void LightImpact();
                public void MediumImpact();
                public void HeavyImpact();
                public void RigidImpact();
                public void SoftImpact();
    }
}