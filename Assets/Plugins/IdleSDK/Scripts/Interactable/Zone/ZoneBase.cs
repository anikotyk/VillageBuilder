using UnityEngine;
using UnityEngine.Events;

namespace IdleBasesSDK.Interactable
{
    public class ZoneBase : MonoBehaviour
    {
        public UnityAction<InteractableCharacter> OnEnter;
        public UnityAction<InteractableCharacter> OnExit;
        public UnityAction<InteractableCharacter> OnInteract;
    }
}
