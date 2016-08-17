using UnityEngine;
using System.Collections;

public class BattleView : MonoBehaviour 
{
    private Transform _myTransform;
    private GameObject buttonAttack;
    void Awake()
    {
        _myTransform = transform;
        buttonAttack = _myTransform.Find("SkillPanel/ButtonAttack").gameObject;
        UIEventListener.Get(buttonAttack).onClick += Onclick;
    }

    private void Onclick(GameObject go)
    {
       //释放技能
        SkillRole skill = new  SkillRole();
        SkillManager.GetInstance().Play(skill, skill.SkillVo.id);
    }
}
