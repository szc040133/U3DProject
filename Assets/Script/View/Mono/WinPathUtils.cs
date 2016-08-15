using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class WinPathUtils 
{
    private static Dictionary<string, string> _viewPath;
    public static void Init()
    {
        _viewPath = new Dictionary<string, string>
        {
            {Windows.LoginView,Path.LoginView},
            {Windows.BagView,Path.BagView},
            {Windows.LoadingView,Path.LoadingView},
        };
    }

    public static string GetWinPathByName(string name)
    {
        string path = null;
        if (_viewPath.ContainsKey(name))
        {
            _viewPath.TryGetValue(name, out path);
        } 
        return path;
    }
}

public class Path
{
    public const string LoginView = "View/Login/LoginView.prefab";
    public const string BagView = "View/Bag/BagView.prefab";
    public const string LoadingView = "View/Loading/LoadingView.prefab";
}