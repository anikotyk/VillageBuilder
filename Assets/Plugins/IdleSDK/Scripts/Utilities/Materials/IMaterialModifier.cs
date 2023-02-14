using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace IdleBasesSDK.Materials
{
    public interface IMaterialModifier
    { 
        public string ParameterName { get; }
        public MaterialPropertyBlock ActualizePropertyBlock(MaterialPropertyBlock propertyBlock);
    }
}
