using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class SkillRole : SkillInterFace 
{

    private Animation _animation;
    private Transform _transfrom;
    private SkillVo _skillvo;
    private List<SkillUtil> _skillUtilList;

    public SkillRole()
    {
        Init();
    }

    private void Init()
    {
        _skillvo = new SkillVo();
        _skillvo.id = 1001;
    }

    /// <summary>
    /// 动作组件
    /// </summary>
    public Animation Animation { get { return _animation; } }
    
    /// <summary>
    /// 挂点部分(这里简单的代替)
    /// </summary>
    public Transform Transform { get{return _transfrom;} }

    /// <summary>
    /// 技能信息
    /// </summary>
    public SkillVo SkillVo { get { return _skillvo; } }

    /// <summary>
    /// 技能
    /// </summary>
    public List<SkillUtil> SkillUtilList { get { return _skillUtilList; } }

    //SkillUnit这里依靠人物驱动技能实时信息更变
    public void Update()
    {

    }
}
