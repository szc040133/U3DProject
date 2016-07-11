using UnityEngine;
using System.Collections;

public class MonoManaer : MonoBehaviour
{
	private static MonoManaer _instance;
	public MonoManaer()
	{
		_instance = this;
	}

	public static MonoManaer GetInstance()
	{
		if (_instance != null)
			return _instance;
		GameObject go = new GameObject ("MonoManaer");
		DontDestroyOnLoad(go);
		return go.AddComponent<MonoManaer> ();
	}


}
