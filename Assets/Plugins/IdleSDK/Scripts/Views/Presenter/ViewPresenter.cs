using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Views;

public class ViewPresenter : MonoBehaviour
{
    [SerializeField] private View _view;

    protected void HandlePresenterAction(PresenterAction presenterAction)
    {
        switch (presenterAction)
        {
            case PresenterAction.Hide:
                _view.Hide();
                break;
            case PresenterAction.Show:
                _view.Show();
                break;
        }
    }
}
