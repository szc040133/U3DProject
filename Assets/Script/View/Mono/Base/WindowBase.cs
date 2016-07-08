using UnityEngine;
using System.Collections;
using System;

/// <summary>
/// 界面基础类
/// </summary>
public class WindowBase : MonoBehaviour
{
    protected Transform _myTransForm;
    protected UIWidget _mask;
    protected UIWidget _backGround;
    protected Action _callBack;

    protected virtual void Awake()
    {

    }

	protected virtual void Start() 
    {
	
	}

    protected virtual void Update()
    {
	
	}

    protected virtual void Close(Action callBack)
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
