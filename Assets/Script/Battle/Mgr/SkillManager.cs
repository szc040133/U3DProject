using UnityEngine;
using System.Collections;
using System.Collections.Generic;
/*
 * 技能管理类
 */
public class SkillManager 
{

    private static SkillManager _instance;
    public static SkillManager GetInstance()
    {
       if (_instance == null) _instance = new SkillManager();
       return _instance;
    }

    private List<SkillUtil> _listUtil = new List<SkillUtil>();
    public void Play(SkillInterFace interFace,int id)
    {
        SkillUtil skllutil = new SkillUtil(interFace, id);
        skllutil.Play();
    }

    public void AddUtil(SkillUtil util)
    {
        _listUtil.Add(util);
    }

    /// <summary>
    /// 技能执行
    /// </summary>
    public void Run()
    {
       
    }

	
}
