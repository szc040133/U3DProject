using UnityEngine;
using System.Collections;

public class SingleEffect 
{
    /// <summary>
    /// 特效ID
    /// </summary>
    private int _id;
    /// <summary>
    /// 特效路径
    /// </summary>
    public string _path;
    /// <summary>
    /// id名称
    /// </summary>
    private string _nameID;
    /// <summary>
    /// 空点，仅用来做位移
    /// </summary>
    public Transform _tf;
    /// <summary>
    /// 特效
    /// </summary>
    public Transform _tfEffect;

    public void Init(_unit_of_EffectConfig data = null, float born = 0)
    {
        _nameID = "effect_"; //空点
        _tf = new GameObject(_nameID).transform;
        UnityEngine.Object prefab = null;
        if (data!=null)
        {
            _id = data.id;
            _nameID += _id;
            _tf.name = _nameID;
            _path = data.path;
        }
        prefab = DownLoadManager.GetInstance().GetAsset(_path);
        if(prefab!=null)
        {
            var go = GameObject.Instantiate(prefab, _tf.position, _tf.rotation);
            if (go != null)
            {
                _tfEffect = (go as GameObject).transform;
                InitShow(_tfEffect);
            }
        }
        
    }

    private void InitShow(Transform tf)
    {
        // 挂特效在空点上
        _tfEffect = tf;
        _tfEffect.parent = _tf;
        _tfEffect.localPosition = Vector3.zero;
        _tfEffect.localRotation = Quaternion.identity;
    }
}
