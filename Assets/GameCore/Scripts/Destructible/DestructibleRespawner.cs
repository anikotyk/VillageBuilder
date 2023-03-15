using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Interactable;
using IdleBasesSDK.Utilities;
using Zenject;

public class DestructibleRespawner : MonoBehaviour
{
    [SerializeField] private Destructible _destructible;
    [SerializeField] private EquippedCharacterZone _characterZone;
    [SerializeField] private float _respawnTime;
    [SerializeField] private float _additionalTimePerAttack;

    [Inject] private Timer _timer;
    private TimerDelay _respawnTimer = null;
    
    private void OnEnable()
    {
        _destructible.HealthChanged += OnHealthChanged;
    }

    private void OnHealthChanged()
    {
        if(_destructible.Health == _destructible.MaxHealth)
            return;
        
        if(_respawnTimer == null || _respawnTimer.Status == TimerStatus.Ended)
            _respawnTimer = _timer.ExecuteWithDelay(Respawn, _respawnTime);
        else
            _respawnTimer.AddTime(_additionalTimePerAttack);
    }

    private void Respawn()
    {
        if(gameObject.activeInHierarchy)
            StartCoroutine(WaitCharacterExit());
    }

    private IEnumerator WaitCharacterExit()
    {
        while(_characterZone.IsCharacterInside)
            yield return null;
        _destructible.Respawn();
    }
    
}
