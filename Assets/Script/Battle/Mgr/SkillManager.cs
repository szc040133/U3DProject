﻿using UnityEngine;
using System.Collections;
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

    public void Play(SkillInterFace interFace,int id)
    {
        SkillUtil skllutil = new SkillUtil(interFace, id);
        skllutil.Play();
    }

    /// <summary>
    /// 技能执行
    /// </summary>
    public void Run()
    {
       
    }
	
}
