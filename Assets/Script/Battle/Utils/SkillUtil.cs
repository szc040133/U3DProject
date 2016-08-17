using UnityEngine;
using System.Collections;

public class SkillUtil 
{
    private int _skillID;
    private SkillInterFace _interFace;
    private SkillVo _skillvo;

    public SkillUtil(SkillInterFace interFace,int id)
    {
        _interFace = interFace;
        _skillID = id;
        _skillvo = interFace.SkillVo;
    }


    public void Play()
    {
        string content ="";//技能内容
        switch (content)
        {
            case BattleConst.Action:
                BattleAction();
                break;
            case BattleConst.Effect:
                BattleEffect();
                break;
            case BattleConst.Buff:
                BattleBuff();
                break;
        }
    }

    /// <summary>
    /// 战斗行为处理
    /// </summary>
    public void BattleAction()
    {
        BattleActionMgr.GetInstance().Play(_skillvo);
    }

    //战斗特效处理
    private void BattleEffect()
    {
        BattleEffectMgr.GetInstance().Play(_skillvo);
    }
    /// <summary>
    /// 战斗buff处理
    /// </summary>
    public void BattleBuff()
    {
        
    }

    private void Update()
    {

    }
   
}
