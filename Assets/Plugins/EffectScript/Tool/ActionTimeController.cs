using UnityEngine;

public class ActionTimeController : MonoBehaviour
{
    private Animation _animation;

    public float StartTime;
    public string Name;
    void Awake()
    {
        _animation = transform.GetComponent<Animation>();
        _animation.cullingType = AnimationCullingType.BasedOnRenderers;
        AnimationState state = _animation[Name];
        state.wrapMode = WrapMode.Loop;
        state.time = StartTime % state.length;

        _animation.Play(Name);
        GameObject.DestroyImmediate(this);
    }
}
