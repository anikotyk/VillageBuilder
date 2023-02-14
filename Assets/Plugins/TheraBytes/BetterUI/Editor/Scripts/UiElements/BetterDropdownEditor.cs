using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEditor.UI;
using UnityEditorInternal;
using UnityEngine;
using UnityEngine.UI;

namespace TheraBytes.BetterUi.Editor
{
    /*
    [CustomEditor(typeof(BetterResourcesDropdown)), CanEditMultipleObjects]
    public class BetterDropDownEditor : DropdownEditor
    {
        BetterElementHelper<ResourcesDropdown, BetterResourcesDropdown> helper =
            new BetterElementHelper<ResourcesDropdown, BetterResourcesDropdown>();

        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();

            BetterResourcesDropdown obj = target as BetterResourcesDropdown;
            helper.DrawGui(serializedObject, obj);

            serializedObject.ApplyModifiedProperties();
        }

        [MenuItem("CONTEXT/Dropdown/♠ Make Better")]
        public static void MakeBetter(MenuCommand command)
        {
            ResourcesDropdown sel = command.context as ResourcesDropdown;
            Betterizer.MakeBetter<ResourcesDropdown, BetterResourcesDropdown>(sel);
        }
    }
    */
}
