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
    public void Init()
    {
        ShotVO shotvo = new ShotVO();
        shotvo.BulletEffect = 1001;
        var effectS = new SingleEffect();
        _unit_of_EffectConfig data = null;
        GameConfig.EffectConfig.TryGetValue(1001, out data);
        effectS.Init(data, 5);

        Vector3 dir = new Vector3(1,1,1);
        float aX = 0;
        effectS.Direction = Vector3.forward;
        var q = Quaternion.LookRotation(dir);
        effectS.Quaternion = q * Quaternion.Euler(aX, 0, 0);

    }


}
