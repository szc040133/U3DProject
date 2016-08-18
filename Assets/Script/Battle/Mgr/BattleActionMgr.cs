using UnityEngine;
using System.Collections;

public class BattleActionMgr 
{
    private static BattleActionMgr _instance;

    public static BattleActionMgr GetInstance()
    {
        if (_instance == null) _instance = new BattleActionMgr();
        return _instance;
    }

    public void Play(SkillVo data)
    {
      
    }
}
