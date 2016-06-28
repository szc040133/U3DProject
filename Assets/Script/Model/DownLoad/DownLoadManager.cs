using UnityEngine;
using System.Collections;
using System;

public class DownLoadManager 
{
    private static DownLoadManager _instance;
    public DownLoadManager()
    {
        if (_instance != null) throw new Exception("单例实例错误");
        _instance = this;
    }

    private void Init()
    {
        //if (EngineManager.GetInstance().OS == OperatingSystem.WINDOWS)
        //{
        //    OutsideFilePath = InsideFilePath = Application.streamingAssetsPath + "/";
        //    AsyncInsideFilePath = AsyncOutsideFilePath = "file:///" + Application.dataPath + "/StreamingAssets/";
        //}
        //else if (EngineManager.GetInstance().OS == OperatingSystem.ANDROID)
        //{
        //    AsyncInsideFilePath = InsideFilePath = Application.streamingAssetsPath + "/";
        //    OutsideFilePath = Application.persistentDataPath + "/";
        //    AsyncOutsideFilePath = "file:///" + Application.persistentDataPath + "/";
        //}
        //else if (EngineManager.GetInstance().OS == OperatingSystem.IOS)
        //{
        //    InsideFilePath = Application.streamingAssetsPath + "/";
        //    OutsideFilePath = Application.persistentDataPath + "/";
        //    AsyncInsideFilePath = "file:///" + Application.streamingAssetsPath + "/";
        //    AsyncOutsideFilePath = "file:///" + Application.persistentDataPath + "/";
        //}
    }

    public static DownLoadManager GetInstance()
    {
        if (_instance != null) return _instance;
        return new DownLoadManager();
    }
	
}
