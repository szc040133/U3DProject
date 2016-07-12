using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ServerManager
{
    private static ServerManager _instance;
    private static Dictionary<string, WindowBaseServer> _winBaseDic;

    public static ServerManager GetInstance()
    {
        if (_instance == null) _instance = new ServerManager();
        return _instance;
    }

    public void Init()
    {
        if (_winBaseDic != null) return;
        _winBaseDic = new Dictionary<string, WindowBaseServer>
        {
            {Windows.BagView, new BagServer()},
            {Windows.LoginView,new LoginServer()},
        };
    }

    public static WindowBaseServer GetServerByName(string name)
    {
        if(_winBaseDic.ContainsKey(name))
        {
            return _winBaseDic[name];
        }
        Debug.LogError("Error:" + name + "is not exited");
        return null;
    }

    public void Dispose()
    {
        _winBaseDic.Clear();
        _winBaseDic = null;
    }
}
