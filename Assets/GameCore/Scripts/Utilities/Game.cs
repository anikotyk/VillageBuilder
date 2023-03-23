using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using NaughtyAttributes;
using IdleBasesSDK.Stack;
using UnityEngine.SceneManagement;
using Zenject;

public class Game : MonoBehaviour
{
    [SerializeField] private ItemType _itemType;
    [SerializeField] private StackSaver _playerStackSaver;
    
    [Button("Reset Saves")]
    public void ResetSaves()
    {
        ES3.DeleteFile();
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }

    [Button("Add100Resource")]
    private void Add100Resource()
    {
        var dictionary = _playerStackSaver.GetSave();
        dictionary[_itemType] += 100;
        _playerStackSaver.Save(dictionary);

    }

    private void Start()
    {
        Debug.Log(Application.persistentDataPath);
        Application.targetFrameRate = 90;
    }
}
