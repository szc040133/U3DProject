using UnityEngine;
using System.Collections;

public class LoginScene : SceneBase
{
    public LoginScene(int id):base(id)
	{
        WinPathUtils.Init();
		ServerManager.GetInstance ().Init();
		DownLoadManager.GetInstance ().Dispose();
		WindowManager.GetInstance ().Add(Windows.LoginView);
	}
}
