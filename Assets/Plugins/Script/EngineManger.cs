using UnityEngine;
using System.Collections;
using System;

public class EngineManger
{
	private static EngineManger _insatnce;
	private EngineManger()
	{
		if (_insatnce != null)
			throw new Exception ("单例错误");
	     _insatnce = this;
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

}
