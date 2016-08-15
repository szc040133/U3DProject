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
        StartCoroutine(StartGame());
    }


    IEnumerator StartGame()
    {
        ServerManager.GetServerByName(Windows.LoginView).Close();
        yield return new WaitForSeconds(0.1f);
        SceneMananger.EnterScene(2);
    }

    protected override void Start()
    {
        base.Start();
    }
}
