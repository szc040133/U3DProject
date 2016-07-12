using UnityEngine;
using System.Collections;
using System;

public class CameraManager 
{
    private static CameraManager _instance;
    private readonly GameObject _cameraRoot;
    public CameraManager()
    {
        if (_instance != null) throw new Exception("单利错误");
        _instance = this;
        _cameraRoot = new GameObject("CameraRoot");
        UnityEngine.Object.DontDestroyOnLoad(_cameraRoot);
    }
	
    public static CameraManager GetInstance()
    {
        if (_instance == null) _instance = new CameraManager();
        return _instance;
    }


}
