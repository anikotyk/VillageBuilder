using UnityEngine;
using System.Collections.Generic;

namespace IdleBasesSDK.Upgrades
{
    public class UpgradesController : MonoBehaviour
    {
        [SerializeField] private List<Upgrade> _upgrades;
        private Dictionary<string, UpgradeModel> _models = new Dictionary<string, UpgradeModel>();

        public UpgradeModel GetModel(string id)
        {
            if (_models.ContainsKey(id))
                return _models[id];

            var model = new UpgradeModel(GetConfig(id));
            _models.Add(id, model);

            return model;
        }

        public UpgradeModel GetModel(Upgrade upgrade) => GetModel(upgrade.Id);

        private Upgrade GetConfig(string id) => _upgrades.Find(x => x.Id == id);

        public float GetValue(Upgrade upgrade) => GetModel(upgrade).CurrentValue;

        public float GetValue(string id) => GetModel(id).CurrentValue;
    }
}
