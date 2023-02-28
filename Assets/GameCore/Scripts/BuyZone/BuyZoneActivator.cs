using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using DG.Tweening;
using IdleBasesSDK.Utilities;
using Zenject;

public class BuyZoneActivator : MonoBehaviour
{
    [SerializeField] private BuyZone _buyZone;
    [SerializeField] private List<BuyZoneActivator> _activateBuyZones;
    [SerializeField] private List<GameObject> _activateObjects;
    [SerializeField] private List<GameObject> _disableObject;
    [SerializeField] private float _startChangeActiveDelay;
    [SerializeField] private float _buyZoneZoomOutDuration;
    [SerializeField] private float _buyZonesActivateDelay;
    [SerializeField] private float _activateDelay;

    [Inject] private Timer _timer;
    
    public BuyZone Zone => _buyZone;
    
    private void OnEnable()
    {
        DisableAll();
        _buyZone.Bought += OnBought;
    }

    private void OnDisable()
    {
        _buyZone.Bought -= OnBought;
    }

    private void OnBought()
    {
        StartCoroutine(EnableRoutine());
    }

    public void DisableAll()
    {
        bool isBought = _buyZone.IsBoughtCheck();
        if (isBought == false)
        {
            foreach (var activateObject in _activateObjects)   
            {
                activateObject.SetActive(false);
            }
        }

        foreach (var buyZoneActivator in _activateBuyZones) 
        {
            if(buyZoneActivator.Zone.IsBoughtCheck() == false)
                buyZoneActivator.DisableAll();
            if(isBought == false)
                buyZoneActivator.Zone.gameObject.SetActive(false);
        }
    }

    private IEnumerator EnableRoutine()
    {
        var zoomOutTweener = _buyZone.transform.DOScale(Vector3.zero, _buyZoneZoomOutDuration);

        

        _timer.ExecuteWithDelay(() =>
        {
            _activateBuyZones.ForEach(x=> x.gameObject.SetActive(true));
        }, _buyZonesActivateDelay);

        yield return new WaitForSeconds(_startChangeActiveDelay);
        
        foreach (var disableObject in _disableObject)
        {
            disableObject.transform.DOScale(new Vector3(1, 0, 1), _buyZoneZoomOutDuration)
                .OnComplete(() => disableObject.SetActive(false));
        }
        
        foreach (var objectToActivate in _activateObjects)
        {
            objectToActivate.SetActive(true);
            yield return new WaitForSeconds(_activateDelay);
        }

        if (zoomOutTweener.active)
        {
            zoomOutTweener.OnComplete(() => _buyZone.gameObject.SetActive(false));
        }
        else
            _buyZone.gameObject.SetActive(false);
    }
    
}
