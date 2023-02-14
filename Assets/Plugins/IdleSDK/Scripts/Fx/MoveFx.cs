using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.Events;

public class MoveFx : MonoBehaviour
{
    [SerializeField] private float _duration;
    [SerializeField] private AnimationCurve _slideCurve;
    [SerializeField] private AnimationCurve _yCurve;
    [SerializeField] private AnimationCurve _yDecreaseCurve;
    [SerializeField] private float _xOffset;
    [SerializeField] private float _yOffset;
    [SerializeField] private bool _rotate;
    public float Duration => _duration;
    public float XOffset => _xOffset;
    public float YOffset => _yOffset;
    
    public AnimationCurve SlideCurve => _slideCurve;
    public AnimationCurve YCurve => _yCurve;
    public AnimationCurve YDecreaseCurve => _yDecreaseCurve;

    public bool Rotate => _rotate;
    
    
    public MoveTween Move(Transform target, Transform destinationPoint, Vector3 destinationDelta= new Vector3(), bool changeParent = false, float progress = 0.0f, bool localMove = false)
    {
        return new MoveTween(target, destinationPoint, this)
            .SetDestinationDelta(destinationDelta)
            .SetChangeParent(changeParent)
            .SetProgress(progress)
            .SetLocalMove(localMove);
    }
    
}
