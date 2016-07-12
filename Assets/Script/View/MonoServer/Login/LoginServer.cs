using UnityEngine;
using System.Collections;

public class LoginServer : WindowBaseServer 
{
    public LoginServer()
    {
        _assetPath = new[] { Windows.GetViewPathByName(Windows.LoginView) };
    }

    public override void Init()
    {
        base.Init();
        _root.AddComponent<LoginView>();
    }
}
