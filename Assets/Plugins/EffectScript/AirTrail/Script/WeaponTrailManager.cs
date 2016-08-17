using UnityEngine;
using System.Collections.Generic;

public class WeaponTrailManager : MonoBehaviour
{
    //20150325谭志恒:省了1个组件
    private static RenderTexture s_renderTexture = null;
    private const int TEXTURE_WIDTH = 256;

    //20150325谭志恒:省了1个组件
    public RenderTexture CreateTexture()
    {
        if (s_renderTexture == null)
        {
            //如果设备分辨率发生改变，这里需要重新创建
            int width = TEXTURE_WIDTH;
            int height = 0;
            if (Screen.width > Screen.height)
            {
                float f = Screen.width / (float)TEXTURE_WIDTH;
                height = (int)(Screen.height / f);
                width = TEXTURE_WIDTH;
            }
            else
            {
                float f = Screen.height / (float)TEXTURE_WIDTH;
                width = (int)(Screen.width / f);
                height = TEXTURE_WIDTH;
            }

            s_renderTexture = new RenderTexture(width, height, 16, RenderTextureFormat.RGB565);
        }

        camera.targetTexture = s_renderTexture;

        return s_renderTexture;
    }

    private Camera distortCamera;
    private List<WeaponTrail> weaponTrails = new List<WeaponTrail>();

    void Awake()
    {
        distortCamera = GetComponent<Camera>();
    }

    public void AddTrail(WeaponTrail trail)
    {
        if (!weaponTrails.Contains(trail))
            weaponTrails.Add(trail);
    }

    public void RemoveTrail(WeaponTrail trail)
    {
        weaponTrails.Remove(trail);
    }

    void Update()
    {
        /*
        for (int i = weaponTrails.Count - 1; i >= 0; i--)
        {
            WeaponTrail trail = weaponTrails[i];
            if (trail == null)
                weaponTrails.RemoveAt(i);
        }
        */

        if (distortCamera.enabled)
        {
            if (weaponTrails.Count == 0)
                distortCamera.enabled = false;
        }
        else
        {
            if (weaponTrails.Count > 0)
                distortCamera.enabled = true;
        }
    }

}
