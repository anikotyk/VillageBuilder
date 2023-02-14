using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace IdleBasesSDK.Upgrades
{
    [CreateAssetMenu]
    public class UpgradeShopItem : ScriptableObject
    {
        public Sprite Icon;
        public UpgradeProperty Price;
        public Upgrade Upgrade;
    }
}

