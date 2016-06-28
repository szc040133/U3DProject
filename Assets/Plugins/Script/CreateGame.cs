using UnityEngine;
using System.Collections;

public class CreateGame : MonoBehaviour
{

	void Start () 
	{
		RunGame ();
	}

	private void RunGame()
	{
		//  开始我的项目啦^_^
		EngineManger.GetInstance().AddCompentToGo(gameObject,"SceneMananger");
		DestroyImmediate (this);
	}
}
