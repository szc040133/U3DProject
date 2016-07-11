using UnityEngine;
using System.Collections;

public class SceneMananger : MonoBehaviour
{
	private static SceneBase _secene;
	private static LevelType _levelType;
	private static int _levelId;

	void Awake()
	{
		switch(_levelType)
		{
		case LevelType.Login:
			
			break;
		case LevelType.City:
			break;
		case LevelType.Fight:
			break;
			
		}
	}

	void Start()
	{
		
	}

	public static void EnterScene(int id,Vector3 birthPostion=default(Vector3),Vector3 birthRotion=default(Vector3))
	{
		if(_secene!=null) _secene.Dsetory();
		_levelId = id;
		SetLevelTypeById(id);
		switch(_levelType)
		{
			case LevelType.Login:
			     Application.LoadLevel("Login");
			    break;
			case LevelType.City:
				break;
			case LevelType.Fight:
				break;
		}
	}

	private static void SetLevelTypeById(int id)
	{
		if (id == 0) _levelType = LevelType.Login;
		else if(id == 1) _levelType = LevelType.City;
		else if(id == 2) _levelType = LevelType.Fight;
	}

    public static LevelType LevelType { get { return _levelType; } }

	public void Dispose()
	{
		_secene.Dsetory();
	}

}
