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
    private Dictionary<string, string[]> _dependencies = new Dictionary<string, string[]>();
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

    public string[] GetDependenices(string[] paths,bool contain = false)
    {
        List<string> reslut = new List<string>();
        if (contain) reslut.AddRange(paths);
        //这里可以处理一些依赖关系需要加载的东西，暂时不处理,以后再处理
        return reslut.ToArray();
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

    public UnityEngine.Object GetAsset(string path)
    {
        DownLoad dl = DownLoader(path);
        if(dl.State == DownLoadState.None)
        {
            ResDownLoader res = new ResDownLoader(path, dl.SingleSign);
            res.Load();
        }
        return dl.Asset;
    }

    public void UnLoadUnnecessary(string[] signs)
    {
       foreach(var dl in _downloader.Values)
       {
           dl.UnLoadUnnecessary(signs);
       }
    }

    public void Dispose()
    {
      foreach(var data in _downloader)
      {
          data.Value.Dispose();
      }
    }
}
