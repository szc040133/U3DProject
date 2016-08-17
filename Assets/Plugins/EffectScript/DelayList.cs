using UnityEngine;

/// <summary>
/// 20151128̷־�� ��Ч��������ʱ
/// </summary>
public class DelayList : MonoBehaviour
{
    //����
    /// <summary>
    /// 20151128̷־�� ��
    /// </summary>
    public Transform[] Child = new Transform[0];
    /// <summary>
    /// 20151128̷־�� ����ʱ��
    /// </summary>
    public float[] ChildT = new float[0];
    /// <summary>
    /// 20151128̷־�� ��ʱ��
    /// </summary>
    public float[] DieT = new float[0];
    /// <summary>
    /// 20151128̷־�� ����
    /// </summary>
    float _life;

    //�
    /// <summary>
    /// 20151128̷־�� ��ʼ��
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
    /// 20151128̷־�� ģ����ʱ
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

            // 20151128̷־�� �Ƿ���ʧ
			var tD=DieT[i];
            bool b =tD==0||t+ tD> _life;
            if (child.gameObject.activeSelf == b)
                continue;
            child.gameObject.SetActive(b);
        }
    }

    //�༭���
#if UNITY_EDITOR//�༭��
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