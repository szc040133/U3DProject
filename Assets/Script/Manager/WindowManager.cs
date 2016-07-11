using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class WindowManager 
{
    private static WindowManager _instance;

    private readonly List<ViewData> _openList;                   //已经打开的窗口列表
    private readonly List<ViewData> _addList;                      //需要增加打开的窗口列表
    private readonly List<ViewData> _willOpenList;               //进入场景时候检测列表是否有元素，有就打开
    private readonly List<ViewData> _willAddList;                //进入场景时候 检测列表是否有元素，有就加
    private bool _isLoading;                                     //退出场景的到加载新场景之间的空隙
    private int _layerCount = 0;

    private WindowManager()
    {
        _openList = new List<ViewData>();
        _addList = new List<ViewData>();
        _willOpenList = new List<ViewData>();
        _willAddList = new List<ViewData>();
    }

    public static WindowManager GetInstance()
    {
        if (_instance == null) _instance = new WindowManager();
        return _instance;
    }

    public void Open(string name, WindowType winType, params object[] args)
    {
        if (CheckOpen(name)) return;
        switch(winType)
        {
            case WindowType.Replace: //替换，新的界面替换已经打开的界面，关闭新界面的时候会重新打开就的界面
                if (_openList.Count > 0) _openList[_openList.Count - 1].Close();
                else _layerCount = 1;
                break;
            case WindowType.Stack:   //堆叠，新打开的界面将叠在旧的揭面纱行。用于子界面
                _layerCount += 5;
                break;
            case WindowType.Remove:  //移除，新打开的界面将已经打开的界面全部清除掉，但是关闭时并不会重新打开旧的界面，用于一级界面
                while (_openList.Count > 0) { _openList[0].Close(); _openList.RemoveAt(0); }
                _layerCount = 1;
                break;
        }
        ViewData data = new ViewData(name, winType, args);
        data.Open(_layerCount);
        _openList.Add(data);
    }

    private bool CheckOpen(string name)
    {
        bool bo = false;
        if (CheckWindowOpened(name)) bo = true;
        return bo;
    }

    public void Colse(string name)
    {
        if (_openList.Count <= 0) return;
        for (int i = 0; i < _openList.Count-1;i--)
        {
            ViewData data = _openList[i];
            if(data.Name == name)
            {
                _openList.RemoveAt(i);
                switch(data.Type)
                {
                    case WindowType.Replace:  //替换，新打开的界面替换上一次打开的界面，关闭新界面后会重新打开旧的界面
                        if (_openList.Count > 0) _openList[_openList.Count - 1].Open(_layerCount);
                        else _layerCount = 1;
                        break;
                    case WindowType.Stack:   //堆叠，新打开的界面将会堆叠到旧界面上面，多用于子界面
                        if (_layerCount > 1) _layerCount -= 5;
                        break;
                    case WindowType.Remove:  // 移除，新打开的界面将已经打开的界面清除掉，但在关闭的时候不会重新打开就的界面，用于一级界面
                        _layerCount = 1;
                        break;
                }
                data.Close();
                break;
            }
        }

    }


    public void EnterScene()
    {
        _isLoading = false;
        if (_willAddList.Count > 0)
        {
            for (int i = 0; i < _willAddList.Count; i++)
            {
                ViewData data = _willAddList[i];
				Add(data.Name);
            }
            _willAddList.Clear();
        }
    }

    public void ExitScene()
    {
        _isLoading = true;
        foreach(ViewData data in _openList)
        {
            data.Close();
        }
        foreach (ViewData windata in _addList)
        {
            windata.Close();
        }
        _addList.Clear();
    }

	public void Add(string name,params object[] args)
    {
		ViewData winData = GetWinData (name, WindowType.Remove, args);
		if (_isLoading)
		{
			AddWhenEnterScene (winData);
			return;
		}
        _addList.Add(winData);
        winData.Open(0);
    }

	public ViewData GetWinData(string name,WindowType type,params object[] args)
	{
		ViewData data = new ViewData (name, type, args);
		return data;
	}

    public void Remove(string name)
    {
        ViewData viewData = _addList.Find(p => p.Name == name);
        if (viewData==null) return;
        _addList.Remove(viewData);
        viewData.Close();
    }

    /// <summary>
    /// 进入场景时打开的界面
    /// </summary>
    public void OpenWhenEnterScene(string name, WindowType winType, params object[] args)
    {
        ViewData data = new ViewData(name, winType, args);
        _willOpenList.Add(data);
    }

    /// <summary>
    /// 进入场景时添加的界面
    /// </summary>
    public void AddWhenEnterScene(ViewData viewData)
    {
        _willAddList.Add(viewData);
    }

    /// <summary>
    /// 检查某个界面是否已经打开
    /// </summary>
    public bool CheckWindowOpened(string name)
    {
        return _openList.Any(winData => winData.Name == name) || _addList.Any(winData => winData.Name == name);
    }

    /// <summary>
    /// 进入场景时检查某个界面是否已经打开
    /// </summary>
    public bool CheckWindowWillOpen(string name)
    {
        return _willOpenList.Any(winData => winData.Name == name);
    }

    public void Dispose()
    {
        _layerCount = 0;
        _openList.Clear();
        _willAddList.Clear();
        _addList.Clear();
        _willOpenList.Clear();
    }
}

public class ViewData
{
    private readonly string _name;
    private readonly WindowType _type;
    private readonly WindowBaseServer _winServer;
    private object[] _args;

    public ViewData(string name, WindowType type, object[] args)
    {
        _name = name;
        _type = type;
        _winServer = ServerManager.GetServerByName(_name);
    }

    public string Name { get { return _name; } }

    public WindowType Type { get { return _type; } }

    public object[] Args { get { return _args; } }

    public void Open(int layer) { _winServer.Open(layer, layer * 2, _args); }

    public void Close()
    {
        _args = null;
        _winServer.Close();
    }
}
