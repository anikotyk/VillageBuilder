using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class TutorialSaver : MonoBehaviour
{
    [SerializeField] private TutorialStep _lastStep;
    [SerializeField] private string _tutorialEndId;
    private void OnEnable()
    {
        _lastStep.Exited += OnExit;
    }

    private void OnExit(TutorialStep step)
    {
        ES3.Save(_tutorialEndId, true);
    }
}
