using UnityEngine;

namespace IdleBasesSDK
{
    public class SimpleJoystickDynamicHandler : InputHandler
    {
        [SerializeField] private DynamicJoystick _dynamicJoystick;

        public override Vector3 GetInput()
        {
            return new Vector3(_dynamicJoystick.Horizontal, 0, _dynamicJoystick.Vertical);
        }
    }
}

