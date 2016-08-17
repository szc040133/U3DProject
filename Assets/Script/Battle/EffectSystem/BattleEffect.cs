using UnityEngine;
using System.Collections;

public class BattleEffect 
{
    private SkillVo _skillvo;

    public BattleEffect(SkillVo data)
    {
        _skillvo = data;
    }
	
    /// <summary>
    /// 初始化
    /// </summary>
    private void Init()
    {
        ShotVO shotvo = new ShotVO();
        shotvo.BulletEffect = 1001;
    }

}
