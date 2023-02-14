using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class BounceData
{
    public Transform Target { get; }
    private float _additionalScale = 0.0f;
    private float _maxScale;
    public bool Enabled  = true;
        
    public void Bounce(float iterationScale, float maxScale)
    {
        if(Enabled == false)
            return;
        _additionalScale += iterationScale;
        _additionalScale = Mathf.Clamp(_additionalScale, 0, maxScale);
        Target.localScale = Vector3.one * (1 + _additionalScale);
    }

    public void OnUpdate(float iterationScale, float decreaseSpeed)
    {
        if (_additionalScale > 0)
        {
            Debug.Log($"{Target.gameObject.name} localScale {Target.localScale}");
            Target.localScale = Vector3.Lerp(Target.localScale, Vector3.one, Time.deltaTime * decreaseSpeed);
            _additionalScale -= Time.deltaTime * decreaseSpeed * iterationScale;
            _additionalScale = Mathf.Clamp(_additionalScale, 0, _maxScale);
        }
    }

    public BounceData(Transform target)
    {
        Target = target;
    }
}