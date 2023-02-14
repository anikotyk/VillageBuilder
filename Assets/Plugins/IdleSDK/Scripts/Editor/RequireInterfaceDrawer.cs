using System;
using UnityEngine;
using UnityEditor;
using Object = UnityEngine.Object;

[CustomPropertyDrawer(typeof(RequireInterfaceAttribute))]
public class RequireInterfaceDrawer : PropertyDrawer
{
    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        bool _isRequiredType = false;
        
        RequireInterfaceAttribute attribute = this.attribute as RequireInterfaceAttribute;
        Type type = attribute.RequiredType;
        
        Event evt = Event.current;
            
        if (evt.type == EventType.DragPerform || evt.type == EventType.DragUpdated)
        {
            if (DragAndDrop.objectReferences.Length > 0)
            {
                Object objectReference = DragAndDrop.objectReferences[0];
                GameObject gameObject = objectReference as GameObject;
                if (gameObject != null)
                {
                    var al = gameObject.GetComponent(type);
                    _isRequiredType = al != null;
                }
            }
        }

        label.text += $": {type.Name}";
        
        EditorGUI.BeginProperty(position, label, property);
        property.objectReferenceValue = EditorGUI.ObjectField(position, label, property.objectReferenceValue,
            _isRequiredType?typeof(GameObject):type, true);
        EditorGUI.EndProperty();
    }
}
