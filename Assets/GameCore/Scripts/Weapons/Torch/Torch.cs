using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using NaughtyAttributes;

public class Torch : BubbleMoveListener
{
    [SerializeField] private View _torchView;
    [SerializeField] private Animator _animator;

    [SerializeField, ShowIf(nameof(HasAnimator)), AnimatorParam(nameof(_animator))]
    private string _startHandleTorchParam;
    
    [SerializeField, ShowIf(nameof(HasAnimator)), AnimatorParam(nameof(_animator))]
    private string _stopHandleTorchParam;
    private bool HasAnimator => _animator != null;

    protected override void OnInsideBubble()
    {
        _torchView.Hide();
        _animator.SetTrigger(_stopHandleTorchParam);
    }

    protected override void OnOutsideBubble()
    {
        _torchView.Show();
        _animator.SetTrigger(_startHandleTorchParam);
    }
}
