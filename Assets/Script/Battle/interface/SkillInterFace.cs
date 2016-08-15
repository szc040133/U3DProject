using UnityEngine;
using System.Collections;
using System.Collections.Generic;
/// <summary>
/// 技能接口 
/// </summary>
public interface SkillInterFace  
{
    /// <summary>
    /// 动作组件
    /// </summary>
    Animation Animation { get; }

    /// <summary>
    /// 挂点部分(这里简单的代替)
    /// </summary>
    Transform Transform { get; }

    /// <summary>
    /// 技能信息
    /// </summary>
    SkillVo SkillVo { get; }

    /// <summary>
    /// 技能
    /// </summary>
    List<SkillUtil> SkillUtilList { get; }

    //SkillUnit这里依靠人物驱动技能实时信息更变
    void Update();
    
}
