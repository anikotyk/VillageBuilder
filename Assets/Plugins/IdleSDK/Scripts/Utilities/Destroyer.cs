using UnityEngine;

namespace IdleBasesSDK.Utilities
{
    public class Destroyer : MonoBehaviour
    {
        [SerializeField] private float _delay;
        private void OnEnable()
        {
            Destroy(gameObject, _delay);
        }
    }
}