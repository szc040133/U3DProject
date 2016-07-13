using UnityEngine;
using System.Collections;

public class WindowBaseServer 
{
    protected string[] _assetPath;
    protected GameObject _root;
    private bool _isOpening;
    private int _sortingOrder;
    private int _depth;
    private bool _isActive;
    private int _layer = -1;
    private ResDownLoader _downLoader;
    protected string _sign = DownUtils.WindowSign;
  
    /// <summary>
    /// 打开窗体
    /// </summary>
    /// <param name="layer">层级</param>
    /// <param name="depth">深度</param>
    public virtual void Open(int layer, int depth, params object[] args)
    {
        if (_isOpening) return;
        _isOpening = true;
        _sortingOrder = layer;
        _depth = depth;
        SetParam(args);
       //加载资源。。
        _downLoader = new ResDownLoader(_assetPath, _sign, false);
        _downLoader.Load(delegate { Init(); });
    }

    /// <summary>
    /// 初始化数据
    /// </summary>
    public virtual void Init()
    {
        if (!_isOpening || _root != null) return;
        _isOpening = false;
        Object obj = DownLoadManager.GetInstance().GetAsset(_assetPath[0]);
        _root = (GameObject)Object.Instantiate(obj, Vector3.zero, Quaternion.identity);
        _root.name = obj.name;
        UIPanel[] panels = _root.GetComponentsInChildren<UIPanel>(true);
        if (panels.Length > 0)
        {
            for (int i = 0; i < panels.Length; i++)
            {
                if (_sortingOrder > 0) panels[i].sortingOrder += _sortingOrder;
                if (_depth > 0) panels[i].depth += _depth;
            }
        }
        _isActive = true;
    }

    /// <summary>
    /// 隐藏窗体
    /// </summary>
    public virtual void Hide()
    {

    }

    /// <summary>
    /// 显示窗体
    /// </summary>
    public virtual void Show()
    {

    }

    public virtual void SetParam(object[] param) { }


    /// <summary>
    /// 关闭窗体
    /// </summary>
    public virtual void Close()
    {
        _isOpening = false;
        if (_root == null) return;
        WindowBase winbase = _root.GetComponent<WindowBase>();
        if (winbase != null) winbase.Close(Destory);
        else Destory();
    }

    /// <summary>
    /// 销毁
    /// </summary>
    public virtual void Destory()
    {
        NGUITools.Destroy(_root);
        _root = null;
        _isActive = false;
    }

    /// <summary>
    /// 是否已经打开状态
    /// </summary>
    public bool IsActive { get { return _isActive; } }
}
