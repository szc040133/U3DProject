using UnityEngine;
using System.Collections;
using System;

/// <summary>
/// 界面基础类
/// </summary>
public class WindowBase : MonoBehaviour
{
    protected Transform _myTransform;
    protected UIWidget _mask;
    protected UIWidget _backGround;
    protected Action _callBack;

    protected virtual void Awake()
    {
        _myTransform = transform;
        Transform transMask = _myTransform.Find("Mask");
        if (transMask != null) _mask = transMask.GetComponent<UISprite>();
        Transform transBg = _myTransform.Find("Background");
    }

	protected virtual void Start() 
    {
	
	}

    protected virtual void Update()
    {
	
	}

    public void Close(Action callBack)
    {
       _callBack = callBack;
    }

    protected virtual void Destory()
    {
        if (_callBack != null)
        {
            _callBack.Invoke();
            _callBack = null;
        }
    }


}
