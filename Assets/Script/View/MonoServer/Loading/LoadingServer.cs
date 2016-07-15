using UnityEngine;
using System.Collections;

public class LoadingServer : WindowBaseServer
{
    private LoadingView _view;
    private ResDownLoader _resDownLoad;
    private string _sign;
    private string _level;
    private string[] _path;
	public LoadingServer()
    {
        _sign = DownUtils.NeedSign;
        _assetPath = new[] { Windows.GetViewPathByName(Windows.LoadingView) };
    }

    public override void Init()
    {
        base.Init();
        _view = _root.AddComponent<LoadingView>();
        _view.Server = this;
    }

    public void EnterScene(string[] path,string level,string sign)
    {
        _resDownLoad = new ResDownLoader(path, sign);
        _resDownLoad.FpsNum = 3;
        _resDownLoad.AddSign();
        _path = path;
        _sign = sign;
        _level = level;
        Open(0, 0);
    }

    public override void Close()
    {
        if (_view == null) return;
        _view.Close(() => { base.Close(); });
    }

    public ResDownLoader DownLoad { get { return _resDownLoad; } }

    public string Level { get { return _level; } }

    public string Sign { get { return _sign; } }

    public string[] Path { get { return _path; } }
}
