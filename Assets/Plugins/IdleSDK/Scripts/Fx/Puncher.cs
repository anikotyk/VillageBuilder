using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;

public class Puncher : MonoBehaviour
{
    [SerializeField] private float _zoomMultiplier = 0.2f; 
    [SerializeField] private int _vibrato = 2;
    [SerializeField] private float _elasticity = 1.0f;
    [SerializeField] private float _zoomTime = 0.5f;

    private Tweener _punchTweener;
    
    public Tweener Punch(Transform model)
    {
        if(_punchTweener is { active: true })
            return _punchTweener;
        _punchTweener = model.DOPunchScale(Vector3.one * _zoomMultiplier, _zoomTime, _vibrato, _elasticity);
        return _punchTweener;
    }
}
