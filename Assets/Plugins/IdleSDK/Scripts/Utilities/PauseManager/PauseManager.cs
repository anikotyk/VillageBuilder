using System;
using UnityEngine;
using System.Collections.Generic;
using UnityEngine.AI;


namespace IdleBasesSDK.Utilities
{
    public class PauseManager : MonoBehaviour
    {
        [SerializeField] private bool _pauseOnChangeWindow = true;
        private List<object> _blockers = new List<object>();

        private void OnEnable()
        {
            if (_blockers.Count == 0)
                Time.timeScale = 1;
        }

        private void OnApplicationPause(bool pauseStatus)
        {
            if (pauseStatus)
            {
                Pause(this);
            }
            else
            {
                Resume(this);
            }
        }

        public void Pause(object objectId)
        {
            _blockers.Add(objectId);
            Time.timeScale = 0;
        }

        public void Resume(object objectId)
        {
            if (_blockers.Contains(objectId))
                _blockers.RemoveAll(x=> x == objectId);
        
            if(_blockers.Count > 0) 
                return;

            Time.timeScale = 1;
        }
    }
}

