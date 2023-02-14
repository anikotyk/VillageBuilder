using NaughtyAttributes;
using UnityEngine;

namespace IdleBasesSDK.Upgrades
{
    [CreateAssetMenu]
    public class Upgrade : ScriptableObject
    {
        public Sprite Icon;
        public string Name;
        public string Id;
        public UpgradeProperty Property;
        public int MaxLevel;

        public float GetValue(int level) => Property.Calculate(Mathf.Clamp(level, 0, MaxLevel));

        [Button("ClearSave")]
        private void ClearSave()
        {
            ES3.DeleteKey(Id);
        }

    }
}

