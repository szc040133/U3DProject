using UnityEngine;
using System.Collections;

public class SceneBase
{
    protected WindowManager _winManager;

	protected int _id;               //场景ID
	protected float _level = 1f;     //关卡等级
	protected LevelType _levelType;  // 场景类型
    protected bool _inScene;         //是否在场景
    protected int _winState;         //胜利面板状态 0 未结算 1 胜利 2 失败

	public SceneBase(int id)
	{
		_id = id;
        _levelType = SceneMananger.LevelType;
        _inScene = true;
        //初始化一些manager
        _winManager = WindowManager.GetInstance();
	}



	public virtual void Start()
	{
        AddCompoment();
		OnRun ();
	}

    protected virtual void AddCompoment()
    {
        _winManager.EnterScene();
    }

	public virtual void OnRun()
	{
		
	}

    public virtual void Update()
    {

    }

  
	public virtual void Dsetory()
	{
        _inScene = false;
        _winManager.ExitScene();
	}


	public int ID { get {return _id;}}

	public float Level{ get { return _level;}}

	public LevelType LevelType{get { return _levelType;}}

    public int WinState { get { return _winState; } }
}
