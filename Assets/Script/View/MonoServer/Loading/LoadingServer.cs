using UnityEngine;
using System.Collections;

public class LoadingServer : WindowBaseServer
{
    private LoadingView _view;
	public LoadingServer()
    {
        _sign = DownUtils.NeedSign;
        _assetPath = new[] { Windows.GetViewPathByName(Windows.LoadingView) };
    }

    public override void Init()
    {
        base.Init();
        _view = _root.AddComponent<LoadingView>();
    }
}
