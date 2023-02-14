using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Cinemachine;
using DG.Tweening;

public class CameraShake : MonoBehaviour
{
    [SerializeField] private CinemachineVirtualCamera _camera;
    [SerializeField] private float _gain;
    [SerializeField] private float _duration;

    private CinemachineBasicMultiChannelPerlin _perlin;

    private CinemachineBasicMultiChannelPerlin Perlin
    {
        get
        {
            if (_perlin == null)
                _perlin = _camera.GetCinemachineComponent<CinemachineBasicMultiChannelPerlin>();
            return _perlin;
        }
    }
    
    private Tweener _shakeTweener;
    private float _currentGain;
    
    
    public void Shake()
    {
        _shakeTweener?.Kill();
        _shakeTweener = Shake(_gain).OnComplete(() =>
        {
            _shakeTweener = Shake(0);
        });
    }

    private Tweener Shake(float endValue)
    {
        return DOTween.To(() => _currentGain, value =>
        {
            _currentGain = value;
            Perlin.m_AmplitudeGain = _currentGain;
        }, endValue, _duration/2);
    }

}
