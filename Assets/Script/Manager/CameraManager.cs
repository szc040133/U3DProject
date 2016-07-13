using UnityEngine;
using System.Collections;
using System;

public class CameraManager 
{
    private static CameraManager _instance;
    private readonly GameObject _cameraRoot;
    private Camera _uiCamera;
    public CameraManager()
    {
        if (_instance != null) throw new Exception("单利错误");
        _instance = this;
        _cameraRoot = new GameObject("CameraRoot");
        UnityEngine.Object.DontDestroyOnLoad(_cameraRoot);
        CreateUICamera();
    }
	
    public static CameraManager GetInstance()
    {
        if (_instance == null) _instance = new CameraManager();
        return _instance;
    }

    public Camera UICmaera { get { return _uiCamera ?? CreateUICamera(); } }
    public Camera CreateUICamera() { return _uiCamera ?? (_uiCamera = CeateCamera("UICamera", 1 << Layers.UI, 0, 1f)); }

    private Camera CeateCamera(string name,LayerMask mask,int depth,float size)
    {
        GameObject go = new GameObject(name);
        go.transform.SetParent(_cameraRoot.transform);
        Camera camera = go.AddComponent<Camera>();

        camera.clearFlags = CameraClearFlags.Depth;
        camera.cullingMask = mask;
        camera.orthographic = true;
        camera.orthographicSize = size;
        camera.nearClipPlane = -2;
        camera.farClipPlane = 2;
        camera.depth = depth;
        UnityEngine.GameObject.DontDestroyOnLoad(go);

        UICamera uiEent = go.AddComponent<UICamera>();
        uiEent.useController = false;
        uiEent.eventReceiverMask = mask;
        return camera;
    }

}
