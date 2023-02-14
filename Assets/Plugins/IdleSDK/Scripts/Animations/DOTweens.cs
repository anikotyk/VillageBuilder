using DG.Tweening;
using UnityEngine;

namespace IdleBasesSDK
{
    public static class DOTweens
    {
        
        public static Sequence DOPulse(this Transform transform, float fromScale, float toScale, float duration)
        {
            transform.localScale = Vector3.one * fromScale;
        
            var seq = DOTween.Sequence();
            seq.SetId(transform);
            seq.Append(transform.DOScale(toScale, duration * 0.5f).SetId(transform));
            seq.Append(transform.DOScale(fromScale, duration * 0.5f).SetId(transform));

            return seq;
        }
        
    }
}