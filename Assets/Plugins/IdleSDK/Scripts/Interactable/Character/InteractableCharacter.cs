using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using IdleBasesSDK.Stack;
using IdleBasesSDK.Utilities;
using Zenject;

namespace IdleBasesSDK.Interactable
{
    public class InteractableCharacter : MonoBehaviour
    {
        [SerializeField] private string _id;
        [SerializeField] private List<Component> _linkedComponents;

        [Inject] private Timer _timer;
        private List<object> _interactDisablers = new List<object>();

        public string Id => _id;
        public bool CanInteract { get; private set; }

        private void Awake()
        {
            CanInteract = true;
        }

        public bool TryToGetComponent<TComponent>(out TComponent component)
        {
            var foundComponent = _linkedComponents.Find(component => typeof(TComponent) == component.GetType());
            component = foundComponent.GetComponent<TComponent>();
            return foundComponent != null;
        }

        public bool TryToGetAllComponents<TComponent>(out IEnumerable<TComponent> components)
        {
            List<TComponent> componentsList = new List<TComponent>();
            foreach (var component in _linkedComponents)
            {
                if (component.TryGetComponent(out TComponent comp))
                {
                    componentsList.Add(comp);
                }
            }

            components = componentsList;
            return componentsList.Any();
        }

        public void DisableInteractForSeconds(object sender, float duration)
        {
            DisableInteract(sender);
            _timer.ExecuteWithDelay(() => EnableInteract(sender), duration);
        }

        public void DisableInteract(object disabler)
        {
            _interactDisablers.Add(disabler);
            CanInteract = false;
        }

        public void EnableInteract(object disabler)
        {
            _interactDisablers.Remove(disabler);
            if (_interactDisablers.Count == 0)
                CanInteract = true;
        }

    }
}
