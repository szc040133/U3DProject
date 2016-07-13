using UnityEngine;
using System.Collections;

public enum WindowType
{
    /// <summary> 替换，新打开的界面将替换已打开的界面，关闭新界面后重新打开旧界面</summary>
    Replace,

    /// <summary> 堆叠，新打开的界面将叠盖到旧界面上面，多用于子界面</summary>
    Stack,

    /// <summary> 移除，新打开的界面将已打开的界面清除掉，但在关闭时并不会重新打开旧界面，多用于一级界面  </summary>
    Remove,
}

public class Windows 
{

    public static string GetViewPathByName(string name)
    {
        return WinPathUtils.GetWinPathByName(name);
    }

	public const string LoginView = "LoginView";
    public const string BagView = "BagView";
    public const string LoadingView = "LoadingView";

}
