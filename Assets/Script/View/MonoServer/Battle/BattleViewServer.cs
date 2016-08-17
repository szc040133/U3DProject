using UnityEngine;
using System.Collections;

public class BattleViewServer : WindowBaseServer 
{

    public BattleViewServer()
    {
        _assetPath = new[] { Windows.GetViewPathByName(Windows.BattleView) };
    }

    public override void Init()
    {
        base.Init();
        _root.AddComponent<BattleView>();
    }
}
