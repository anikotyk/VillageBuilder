using UnityEngine;

namespace IdleBasesSDK.Materials
{
    public class ColorModifier : IMaterialModifier
    {
        public string ParameterName => _parameterName;
        private string _parameterName;
        private Color _color;

        public ColorModifier(string parameterName, Color color)
        {
            _parameterName = parameterName;
            _color = color;
        }
            
        public MaterialPropertyBlock ActualizePropertyBlock(MaterialPropertyBlock propertyBlock)
        {
            propertyBlock.SetColor(_parameterName, _color);
            return propertyBlock;
        }

    }
}