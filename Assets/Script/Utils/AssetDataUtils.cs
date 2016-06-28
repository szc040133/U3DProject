using UnityEngine;
using System.Collections;
using System.IO;

public class AssetDataUtils
{
#if UNITY_ANDROID && !UNITY_EDITOR
    private static ZipFile mZipfile = null;
    private static Dictionary<string, ZipEntry> mZipEntrys = new Dictionary<string, ZipEntry>();
#endif
    /// <summary>
	/// 读取StreamingAsset资源
	/// </summary>
	/// <param name="file">相对路径</param>
	/// <returns></returns>
	public static byte[] LoadForStreamingAsset(string file)
	{
#if UNITY_EDITOR || UNITY_IPHONE || UNITY_STANDALONE_WIN
        string fullfile = Application.streamingAssetsPath + "/" + file;
        return File.ReadAllBytes(fullfile);
#elif UNITY_ANDROID 
        if(mZipfile == null)
        {
            try
            {
                mZipfile = new ZipFile(Application.dataPath);
                mZipfile.Password = "";
                IEnumerator itor = mZipfile.GetEnumerator();
                while (itor.MoveNext())
                {
                    ZipEntry entry = itor.Current as ZipEntry;
                    if (entry.IsFile) mZipEntrys.Add(entry.Name, entry);
                }
            }
            catch (System.Exception e)
            {
                Debug.LogError("AssetZip.init error!" + e.Message + ",StackTrace:" + e.StackTrace);
                return null;
            }
        }
        ZipEntry entryIndex;
        if (!mZipEntrys.TryGetValue("assets/" + file, out entryIndex))
        {
            Debug.LogError("file not found: " + Application.dataPath + "/assets/" + file);
            return null;
        }
        byte[] data = new byte[entryIndex.Size];
        mZipfile.GetInputStream(entryIndex).Read(data, 0, data.Length);
        return data;
#else 
        return null;
#endif
	}

	/// <summary>
	/// 读取本地文件
	/// </summary>
	/// <param name="file"></param>
	/// <returns></returns>
	public static byte[] LoadForPersistentData(string file)
	{
#if UNITY_EDITOR || UNITY_STANDALONE_WIN
		return File.ReadAllBytes(Application.streamingAssetsPath + "/" + file);
#else
		return File.ReadAllBytes(Application.persistentDataPath + "/" + file);
#endif
	}

    /// <summary>
    /// 释放
    /// </summary>
    public static void Release()
    {
#if UNITY_ANDROID && !UNITY_EDITOR
        if (mZipfile != null)
        {
            mZipfile.Close();
            mZipfile = null;
        }
        mZipEntrys.Clear();
#endif
    }
}
