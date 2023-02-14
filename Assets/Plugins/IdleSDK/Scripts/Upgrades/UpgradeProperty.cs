
using System.Collections.Generic;
using NaughtyAttributes;

namespace IdleBasesSDK.Upgrades
{
    [System.Serializable]
    public class UpgradeProperty
    {
        public bool CustomValues;
        [HideIf(nameof(CustomValues))] public float StartValue;
        [HideIf(nameof(CustomValues))]  public float Step;
        [HideIf(nameof(CustomValues))] public bool _firstZero;
        [HideIf(nameof(CustomValues))] public Formula Formula;
        [ShowIf(nameof(CustomValues))] public List<float> Values;

        public float Calculate(int level)
        {
            if (CustomValues)
                return Values[level];
            
            if (_firstZero && level == 0)
                return 0;
            if (_firstZero)
                level--;
            
            float result = StartValue;
            switch (Formula)
            {
                case Formula.Plus:
                    result = StartValue + Step * level;
                    break;
                case Formula.Exponent:
                    result = UnityEngine.Mathf.Pow(Step, level) * StartValue;
                    break;
                case Formula.Minus:
                    result = StartValue - Step * level;
                    break;
            }

            return result;
        }


    }
}