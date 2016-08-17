using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class SkillVo 
{

    /// <summary>
    /// 技能iD
    /// </summary>
    public int id;

    /// <summary>
    /// 动作名称
    /// </summary>
    public string anim = "attack01";

    /// <summary>
    /// 收手动画
    /// </summary>
    public List<string> end_anim = new List<string>() { "attack01End1", "attack01End2" };

    /// <summary>
    /// 动画时间
    /// </summary>
    public float anim_time = 0.7f;
}
