using UnityEngine;
using System.Collections;

/// <summary>
/// 基础元件
/// </summary>
public class UnitBase 
{
    /// <summary>
    /// 是否已经销毁
    /// </summary>
    public virtual bool IsDestroy { get; set; }

    /// <summary>
    /// 初始化
    /// </summary>
    protected void Init()
    {
        IsDestroy = false;
    }

    /// <summary>
    /// 销毁
    /// </summary>
    public void Destory()
    {
        if (IsDestroy) return;
        IsDestroy = true;
        DestroyIn();
    }

    /// <summary>
    /// 更新
    /// </summary>
    public void Update(float t)
    {
        if (IsDestroy) return;
        UpdateData(t);
    }

    protected virtual void DestroyIn()
    {
    }

    /// <summary>
    /// 内部更新,含更新打击 (此帧时用)
    /// </summary>
    protected virtual void UpdateData(float t)
    {
    }

}
