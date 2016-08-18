using UnityEngine;
using System.Collections;

public class SkillUtil 
{
    private int _skillID;
    private SkillInterFace _interFace;
    private SkillVo _skillvo;
    private float _time;

    public SkillUtil(SkillInterFace interFace,int id)
    {
        _interFace = interFace;
        _skillID = id;
        _skillvo = interFace.SkillVo;

        SkillManager.GetInstance().AddUtil(this);

    }




    public void Play()
    {
        string content = "Effect";//技能内容
        PlayUnit(content);
    }
    
    public void PlayUnit(string content)
    {
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
        //BattleEffectMgr.GetInstance().Play(_skillvo);
        int effectTpye = 2; //特效类型
        switch(effectTpye)
        {
            case 1://栗子特效
                break;
            case 2://混合特效
               BattleEffect effect =  new BattleEffect(_skillvo);
               effect.Init();
                break;
        }
    }
    /// <summary>
    /// 战斗buff处理
    /// </summary>
    public void BattleBuff()
    {
        
    }

    private void Update(float time)
    {
        _time += time;
    }
   
}
