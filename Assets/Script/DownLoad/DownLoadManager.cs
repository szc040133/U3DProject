using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;

public class DownLoadManager 
{
    private static DownLoadManager _instance;
    public static string InsideFilePath;
    public static string OutsideFilePath;
    public static string AsyncInsideFilePath;
    public static string AsyncOutsideFilePath;
    private Dictionary<string, DownLoad> _downloader = new Dictionary<string, DownLoad>();
    public DownLoadManager()
    {
        if (_instance != null) throw new Exception("单例实例错误");
        _instance = this;
        Init();
    }

    private void Init()
    {
        switch(EngineManger.GetInstance().OS)
        {
            case OperatingSystem.WINDOWS:
                OutsideFilePath = InsideFilePath = Application.streamingAssetsPath + "/";
                AsyncInsideFilePath = AsyncOutsideFilePath = "file:///" + Application.dataPath + "/StreamingAssets/";
                break;
            case OperatingSystem.ANDROID:
                AsyncInsideFilePath = InsideFilePath = Application.streamingAssetsPath + "/";
                OutsideFilePath = Application.persistentDataPath + "/";
                AsyncOutsideFilePath = "file:///" + Application.persistentDataPath + "/";
                break;
            case OperatingSystem.IOS:
                InsideFilePath = Application.streamingAssetsPath + "/";
                OutsideFilePath = Application.persistentDataPath + "/";
                AsyncInsideFilePath = "file:///" + Application.streamingAssetsPath + "/";
                AsyncOutsideFilePath = "file:///" + Application.persistentDataPath + "/";
                break;
        }
    }

    public static DownLoadManager GetInstance()
    {
        if (_instance != null) return _instance;
        return new DownLoadManager();
    }

    public DownLoad DownLoader(string path)
    {
        if (path.IndexOf('.') == -1)
        {
            Debug.LogError("PathError: " + path);
            path += ".prefab";
        }
        if (!_downloader.ContainsKey(path))
            _downloader.Add(path, new DownLoad(path));
        return _downloader[path];
    }

    public void Dispose()
    {
      foreach(var data in _downloader)
      {
          data.Value.Dispose();
      }
    }
}
