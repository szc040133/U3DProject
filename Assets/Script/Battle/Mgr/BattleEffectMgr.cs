using UnityEngine;
using System.Collections;

public class BattleEffectMgr 
{
    private static BattleEffectMgr _instance;

    public static BattleEffectMgr GetInstance()
    {
        if (_instance == null) _instance = new BattleEffectMgr();
        return _instance;
    }

    public void Play(SkillVo data)
    {

    }


}
