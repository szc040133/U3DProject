using UnityEngine;
using System.Collections;

public class SceneBase
{
	protected int _id;
	protected float _level;
	protected LevelType _levelType;

	public SceneBase(int id)
	{
		_id = id;
	}



	public virtual void Start()
	{
		OnRun ();
	}

	public virtual void OnRun()
	{
		
	}

	public virtual void Dsetory()
	{
		
	}


	public int ID { get {return _id;}}

	public float Level{ get { return _level;}}

	public LevelType LevelType{get { return _levelType;}} 


}
