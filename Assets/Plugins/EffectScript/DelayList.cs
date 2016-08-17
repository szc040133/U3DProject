using UnityEngine;

/// <summary>
/// 20151128谭志恒 特效的批量延时
/// </summary>
public class DelayList : MonoBehaviour
{
    //属性
    /// <summary>
    /// 20151128谭志恒 子
    /// </summary>
    public Transform[] Child = new Transform[0];
    /// <summary>
    /// 20151128谭志恒 出生时间
    /// </summary>
    public float[] ChildT = new float[0];
    /// <summary>
    /// 20151128谭志恒 挂时间
    /// </summary>
    public float[] DieT = new float[0];
    /// <summary>
    /// 20151128谭志恒 生命
    /// </summary>
    float _life;

    //活动
    /// <summary>
    /// 20151128谭志恒 初始化
    /// </summary>
    public void Init()
    {
        _life=0;
        for (int i = 0; i < Child.Length; i++)
        {
            var t = ChildT[i];
            if (t <= 0)
                continue;
            var child = Child[i];
            if (child == null || !child.gameObject.activeSelf)
                continue;
            child.gameObject.SetActive(false);
        }
    }
    /// <summary>
    /// 20151128谭志恒 模拟延时
    /// </summary>
    public void UpdateIn(float dt)
    {
        _life +=dt;
        for (int i = 0; i < Child.Length; i++)
        {
            var child = Child[i];
            if (child == null)
                continue;
            var t = ChildT[i];
            if (t <= 0 || _life < t)
                continue;

            // 20151128谭志恒 是否消失
			var tD=DieT[i];
            bool b =tD==0||t+ tD> _life;
            if (child.gameObject.activeSelf == b)
                continue;
            child.gameObject.SetActive(b);
        }
    }

    //编辑器活动
#if UNITY_EDITOR//编辑器
	void Start ()
    {
        if(!Application.isPlaying)
            Init();
	}
	void Update()
    {
        if (!Application.isPlaying)
            UpdateIn(Time.deltaTime);
    }
#endif
}