using UnityEngine;
using System.Collections;

public class FightScene : SceneBase
{
    public FightScene(int id)
    : base(id)
	{
		WindowManager.GetInstance ().Add(Windows.BattleView);
	}
}
