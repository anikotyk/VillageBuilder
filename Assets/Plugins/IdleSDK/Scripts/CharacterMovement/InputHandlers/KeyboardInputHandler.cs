using UnityEngine;

namespace IdleBasesSDK
{
    public class KeyboardInputHandler : InputHandler
    {
        [SerializeField] private bool _inverse;
        
        public override Vector3 GetInput()
        {
            if(_inverse == false)
                return new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical"));
            
            return new Vector3(Input.GetAxis("Vertical"), 0, Input.GetAxis("Horizontal"));
        }
    }
}
