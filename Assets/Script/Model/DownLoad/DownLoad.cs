using UnityEngine;
using System.Collections;
using System.IO;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;

public delegate void DownLoadComplete(DownLoad download);
public class DownLoad 
{
	private string _path;
	private MonoManaer _monoManger;
	private bool _isBundle = true;
	private string _name;
	private DownLoadState _state = DownLoadState.None;
	private List<DownLoadComplete> _complete = new List<DownLoadComplete> ();
	private string _downPath;
	private Object _asset;
	private bool _inSide;
	private bool _unloadStream;
	private AssetBundle _assetBundle;
	private string _result;
    private string _downAsyncPath;
    private bool _unload = true;
    private bool _bundleUnload;

	public DownLoad(string path)
	{
		_path = path;
		_name = System.IO.Path.GetFileName (path);
		_name = _name.Remove(_name.IndexOf('.'));
		_monoManger = MonoManaer.GetInstance ();
        if (path.StartsWith("CS")) _isBundle = false;
	}

	public void Load(DownLoadComplete complete,bool async)
	{
        _unload = false; 
		switch(_state)
		{
		    case DownLoadState.None:
			    _complete.Add (complete);
			    _state = DownLoadState.Runing;
                if (!async) DownLoader();
                else _monoManger.StartCoroutine(AsyncDownLoader());
				    break;
		    case DownLoadState.Runing:
			    _complete.Add (complete);
				    break;
		    case DownLoadState.Complete:
			    complete (this);
				    break;
		}
	}

	private void DownLoader()
	{
		if(_isBundle)
		{
			try{
				byte[] b = _inSide ? AssetDataUtils.LoadForStreamingAsset(_result) : File.ReadAllBytes(_downPath);
				_assetBundle = AssetBundle.CreateFromMemoryImmediate(b);
				_asset = _assetBundle.mainAsset;
			}
			catch{}
		}else _asset = Resources.Load(_path.Remove(_path.IndexOf('.')));
		Complete();
	}

    public IEnumerator AsyncDownLoader()
    {
        if (_isBundle)
        {
            WWW www = new WWW(_downAsyncPath);
            yield return www;
            if (www.error == null)
            {
                _assetBundle = www.assetBundle;
                AssetBundleRequest request = _assetBundle.LoadAsync(_name, typeof(Object));
                yield return request;
                _asset = request.asset;
            }
            www.Dispose();
        }
        else
        {
            ResourceRequest request = Resources.LoadAsync(_path.Remove(_path.IndexOf('.')), typeof(Object));
            yield return request;
            _asset = request.asset;
        }
        Complete();
    }

	private void Complete()
	{
        if (_unload)
        {
            UnLoadAssetBundle();
            return;
        }
        if (_asset == null && !_path.EndsWith(".unity")) Debug.LogError("DownLoaderError:" + _path);
        else Debug.Log("DownLoader: " + _path);

        _state = DownLoadState.Complete;
		for(int i=0;i<_complete.Count;i++)
        {
            _complete[i](this);
        }
        _complete.Clear();
	}

    //bundle内的序列化数据将被释放
    public void UnloadFalse()
    {
        if (_bundleUnload) return;
        if (_assetBundle != null) _assetBundle.Unload(false);
        _bundleUnload = true;
    }

    //真正卸载资源 
    private void UnLoadAssetBundle()
    {
        _bundleUnload = false;
        _state = DownLoadState.None;
        if (_assetBundle != null) _assetBundle.Unload(true);
        _assetBundle = null;
        _asset = null;
    }

    //卸载
    private void UnLoad()
    {
        _unload = true;
        _complete.Clear();
        if (_state == DownLoadState.Complete) UnLoadAssetBundle();
    }

    private void RunDownPath(string path)
    {
        MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider();
        byte[] hash = md5.ComputeHash(Encoding.UTF8.GetBytes(path));
        for (int i = 0; i < hash.Length; i++)
        {
            _result += hash[i].ToString("x2");
        }
        //_downPath = ABDLManager.OutsideFilePath + _result;
        //_downAsyncPath = ABDLManager.AsyncOutsideFilePath + _result;
        //if (!File.Exists(_downPath))
        //{
        //    _inSide = true;
        //    _downPath = ABDLManager.InsideFilePath + _result;
        //    _downAsyncPath = ABDLManager.AsyncInsideFilePath + _result;
        //}
    }

	public void Dispose()
	{
        UnLoad();
	}

    public Object Asset { get { return _asset; } }

    public string Path { get { return _path; } }

}

public enum DownLoadState
{
	Runing,
	Complete,
	None
}