namespace UntitledGames.Transforms
{
    using UnityEditor;
    using UnityEngine;

    [InitializeOnLoad]
    public static class TransformProEditorLoader
    {
        static TransformProEditorLoader()
        {
            EditorApplication.playModeStateChanged += TransformProEditorLoader.Load;
            TransformProEditorLoader.Load(PlayModeStateChange.EnteredEditMode); 
        }

        private static void Load(PlayModeStateChange playModeStateChange)
        {
            /*
            if (Application.isPlaying || EditorApplication.isPlayingOrWillChangePlaymode)
            {
                TransformProEditorGadgets.Unload();
                return;
            }
            */

            TransformProStyles.Initialise();
            TransformProPreferences.Load();

            if (TransformProEditorGadgets.Instance == null)
            {
                TransformProEditorGadgets.Create();
            }

            if (TransformProEditorGadgets.Instance == null)
            {
                Debug.LogWarning("[<color=red>TransformPro</color>] Could not create gadget manager.");
                return;
            }

            //EditorApplication.delayCall += TransformProEditorGadgets.Instance.Setup;
            TransformProEditorGadgets.Instance.Setup();
        }
    }
}
