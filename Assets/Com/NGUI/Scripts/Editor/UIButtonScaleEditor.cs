using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(UIButtonScale))]
class UIButtonScaleEditor : Editor
{
    public override void OnInspectorGUI()
    {
        EditorGUIUtility.labelWidth = 100f;
        EditorGUILayout.Space();

        UIButtonScale mScale = target as UIButtonScale;
        Transform tweenTarget = EditorGUILayout.ObjectField("Tween Target", mScale.tweenTarget, typeof(Transform), true) as Transform;
        if (mScale.tweenTarget != tweenTarget) mScale.tweenTarget = tweenTarget;

        DrawPressed();
        DrawDiverge();
    }

    private void DrawPressed()
    {
        UIButtonScale mScale = target as UIButtonScale;
        bool showPressed = EditorGUILayout.Toggle("Show Pressed", mScale.showPressed);
        if (mScale.showPressed != showPressed) mScale.showPressed = showPressed;

        if (mScale.showPressed)
        {
            if (NGUIEditorTools.DrawHeader("Pressed"))
            {
                NGUIEditorTools.BeginContents();
                GUILayout.BeginVertical();

                GUILayout.Space(4f);
                Vector3 pressed = EditorGUILayout.Vector3Field("Scale", mScale.pressed);
                if (mScale.pressed != pressed) mScale.pressed = pressed;
                GUILayout.Space(4f);
                float pressedDuration = EditorGUILayout.FloatField("Duration", mScale.pressedDuration);
                if (mScale.pressedDuration != pressedDuration) mScale.pressedDuration = pressedDuration;
                GUILayout.Space(4f);

                GUILayout.EndVertical();
                NGUIEditorTools.EndContents();
            }
        }
    }

    private void DrawDiverge()
    {
        UIButtonScale mScale = target as UIButtonScale;
        bool showDiverge = EditorGUILayout.Toggle("Show Diverge", mScale.showDiverge);
        if (mScale.showDiverge != showDiverge) mScale.showDiverge = showDiverge;

        if (mScale.showDiverge)
        {
            if (NGUIEditorTools.DrawHeader("Diverge"))
            {
                NGUIEditorTools.BeginContents();
                GUILayout.BeginVertical();

                GUILayout.Space(4f);
                Vector3 diverge = EditorGUILayout.Vector3Field("Scale", mScale.diverge);
                if (mScale.diverge != diverge) mScale.diverge = diverge;
                GUILayout.Space(4f);
                float divergeDuration = EditorGUILayout.FloatField("Duration", mScale.divergeDuration);
                if (mScale.divergeDuration != divergeDuration) mScale.divergeDuration = divergeDuration;
                GUILayout.Space(4f);

                GUILayout.EndVertical();
                NGUIEditorTools.EndContents();
            }
        }
    }
}