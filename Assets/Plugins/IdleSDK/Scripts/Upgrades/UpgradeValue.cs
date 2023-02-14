using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using NaughtyAttributes;
using IdleBasesSDK.Upgrades;
using Zenject;

namespace IdleBasesSDK.Upgrades
{
    public class UpgradeValue : MonoBehaviour
    {
        [SerializeField, HideIf(nameof(_constantValue))] private Upgrade _upgrade;
        [SerializeField] private bool _constantValue;

        [SerializeField, ShowIf(nameof(_constantValue))]
        private float _value;

        [Inject] private UpgradesController _upgradesController;

        public float Value => _constantValue ? _value : _upgradesController.GetValue(_upgrade);
        public int ValueInt => _constantValue ? (int)_value : (int)_upgradesController.GetValue(_upgrade);

        public UpgradeModel Model => _upgradesController.GetModel(_upgrade);

        public float GetValue(UpgradesController controller)
        {
            if (_constantValue)
                return _value;
            return controller.GetValue(_upgrade);
        }
    }
}
