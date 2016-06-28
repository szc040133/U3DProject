using UnityEngine;
using System.Collections;
using System;
using System.IO;

public class EngineManger
{
	private static EngineManger _insatnce;
    public string OutsideUrl;
    public string InsideUrl;
    public OperatingSystem OS;

	private EngineManger()
	{
		if (_insatnce != null)
			throw new Exception ("单例错误");
	     _insatnce = this;
         Init();
	}
		
	public static EngineManger GetInstance()
	{
		if (_insatnce != null)
			return _insatnce;
		return new EngineManger ();
	}


	public Component AddCompentToGo(GameObject go ,string name)
	{
		return go.AddComponent (name);
	}

    private void Init()
    {
        Screen.sleepTimeout = SleepTimeout.NeverSleep;
        if (Application.platform == RuntimePlatform.WindowsEditor || Application.platform == RuntimePlatform.WindowsPlayer
            || Application.platform == RuntimePlatform.OSXEditor || Application.platform == RuntimePlatform.OSXPlayer)
        {
            InsideUrl = OutsideUrl = "file:///" + Application.dataPath + Path.AltDirectorySeparatorChar + "StreamingAssets" + Path.AltDirectorySeparatorChar;
            OS = OperatingSystem.WINDOWS;
        }
        else if (Application.platform == RuntimePlatform.Android)
        {
            InsideUrl = Application.streamingAssetsPath + Path.AltDirectorySeparatorChar;
            OutsideUrl = "file:///" + Application.persistentDataPath + Path.AltDirectorySeparatorChar;
            OS = OperatingSystem.ANDROID;
        }
        else if (Application.platform == RuntimePlatform.IPhonePlayer)
        {
            InsideUrl = "file:///" + Application.streamingAssetsPath + Path.AltDirectorySeparatorChar;
            OutsideUrl = "file:///" + Application.persistentDataPath + Path.AltDirectorySeparatorChar;
            OS = OperatingSystem.IOS;
        }
    }
}

public enum OperatingSystem
{
    WINDOWS = 0,
    ANDROID = 1,
    IOS = 2
}
