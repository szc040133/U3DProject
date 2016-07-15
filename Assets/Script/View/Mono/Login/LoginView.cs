using UnityEngine;
using System.Collections;

public class LoginView : WindowBase
{
    private Transform _myTransform;
    private GameObject _startGameBtn;
    protected override void Awake()
    {
        base.Awake();
        _myTransform = transform;
        _startGameBtn = _myTransform.Find("StartPanel/StartButton").gameObject;
        UIEventListener.Get(_startGameBtn).onClick += Onclick;
    }

    private void Onclick(GameObject go)
    {
       //加载第二个场景

    }

    protected override void Start()
    {
        base.Start();
    }
}
