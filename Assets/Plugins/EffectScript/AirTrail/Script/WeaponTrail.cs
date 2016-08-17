using UnityEngine;
using System.Collections.Generic;

//如下接口可以调用:
//void StartTrail()

//立即清除
//void ClearTrail()

//开始消隐，time为消隐时长
//void Fadeout(float time)

//设置当前亮度
//void SetBrightness(float value)

//获取当前亮度
//float GetBrightness()

//设置当前透明度
//void SetAlpha(float value)

//获取当前透明度
//float GetAlpha()

public class WeaponTrail : MonoBehaviour
{
    //属性
    static GameObject _camAir;//刀空气流镜头

    //活动
    void UpdateLayer()//20150520谭志恒:有镜头则更新层,防QTE状态镜头的层有变
    {
        if (_camAir != null)
        {
            _camAir.GetComponent<Camera>().cullingMask = Camera.main.cullingMask &
                ~((1 << LayerMask.NameToLayer("UI")) |
                    (1 << LayerMask.NameToLayer("WeaponTrail")));
        }
    }

    public Transform[] shapePoints;
    public float time = 0.4f;

    private class TrailSectionData
    {
        public Vector3[] points;
    }

    private class TronTrailSection
    {
        public Vector3[] points;
        public float time;
    }

    private Mesh mesh;
    private Vector3[] vertices;
    private Vector2[] uv;

    private static WeaponTrailManager trailCountManager;
    private TrailSectionData sectionData;

    private int shaderBrightness;
    private int shaderAlphaIdx;
    private float brightness;
    private float alpha;
    private float originalBrightness;
    private float originalAlpha;

    private List<TronTrailSection> sections = new List<TronTrailSection>();

    public void StartTrail()
    {
        CreateDistortCamera();
        if (trailCountManager != null)
            trailCountManager.AddTrail(this);

        SetBrightness(originalBrightness);
        SetAlpha(originalAlpha);
    }

    public void ClearTrail()
    {
        if (trailCountManager != null)
            trailCountManager.RemoveTrail(this);

        if (mesh != null)
        {
            mesh.Clear();
            sections.Clear();
        }
    }

    void OnDisable()
    {
        ClearTrail();
    }

    public void SetBrightness(float value)
    {
        value = Mathf.Clamp(value, 1, 8);
        renderer.material.SetFloat(shaderBrightness, value);
        brightness = value;
    }

    public float GetBrightness()
    {
        return brightness;
    }

    public void SetAlpha(float value)
    {
        value = Mathf.Clamp(value, 0, 1);
        renderer.material.SetFloat(shaderAlphaIdx, value);
        alpha = value;
    }

    public void Fadeout(float lerp) 
    {
        alpha = Mathf.Lerp(originalAlpha, 0, lerp);
        renderer.material.SetFloat(shaderAlphaIdx, alpha);
    }

    public float GetAlpha()
    {
        return alpha;
    }

    void Awake()
    {
        if (shapePoints == null || shapePoints.Length < 2)
        {
            Debug.LogError("two shap points at least!");
            return;
        }

        MeshFilter meshF = GetComponent(typeof(MeshFilter)) as MeshFilter;
        mesh = meshF.mesh;

        sectionData = new TrailSectionData();
        sectionData.points = new Vector3[shapePoints.Length];
        for (int i = 0; i < shapePoints.Length; i++)
            sectionData.points[i] = shapePoints[i].localPosition;

        shaderBrightness = Shader.PropertyToID("_Brightness");
        shaderAlphaIdx = Shader.PropertyToID("_Alpha");

        brightness = renderer.material.GetFloat(shaderBrightness);
        alpha = renderer.material.GetFloat(shaderAlphaIdx);
        originalBrightness = brightness;
        originalAlpha = alpha;
    }

    private void CreateDistortCamera()
    {
        //20150504志恒:无空气流镜头则加
        if (_camAir== null)
        {
            _camAir = new GameObject("Distort_Camera");
            Camera distortCamera = _camAir.AddComponent<Camera>();
            distortCamera.CopyFrom(Camera.main);

            //20150520谭志恒:有镜头则更新层,防QTE状态镜头的层有变
            UpdateLayer();
            distortCamera.clearFlags = CameraClearFlags.SolidColor;//20150521谭志恒:显实心色

            Transform distortCamTr = distortCamera.transform;
            distortCamTr.parent = Camera.main.transform;
            distortCamTr.localPosition = Vector3.zero;

            distortCamTr.localRotation = Quaternion.identity;
            distortCamTr.localScale = Vector3.one;

            //20150325谭志恒:省了1个组件
            trailCountManager = _camAir.AddComponent<WeaponTrailManager>();
        }

        //20150504志恒:换武器时需更新镜头贴图
        Material matCam = renderer.material;
        Texture imgCam = matCam.GetTexture("_SceneTex");
        if (imgCam==null)
            matCam.SetTexture("_SceneTex", trailCountManager.CreateTexture());
    }

    public void Itterate(float itterateTime)
    {
        TronTrailSection section = new TronTrailSection();

        //这里都预先分配出来
        section.points = new Vector3[sectionData.points.Length];
        for (int i = 0; i < sectionData.points.Length; i++)
            section.points[i] = transform.TransformPoint(sectionData.points[i]);

        section.time = itterateTime;
        sections.Insert(0, section);
    }

    public void UpdateTrail(float currentTime)
    {
        //20150520谭志恒:有镜头则更新层,防QTE状态镜头的层有变
        UpdateLayer();

        // Rebuild the mesh	
        mesh.Clear();
        //
        // Remove old sections
        while (sections.Count > 0 && currentTime > sections[sections.Count - 1].time + time)
            sections.RemoveAt(sections.Count - 1);

        // We need at least 2 sections to create the line
        if (sections.Count < 2)
            return;

        int vertexCountPerSection = sectionData.points.Length;
        vertices = new Vector3[sections.Count * vertexCountPerSection];
        uv = new Vector2[sections.Count * vertexCountPerSection];
        //
        TronTrailSection currentSection = sections[0];
        //
        // Use matrix instead of transform.TransformPoint for performance reasons
        Matrix4x4 localSpaceTransform = transform.worldToLocalMatrix;

        // Generate vertex, uv and colors
        for (var i = 0; i < sections.Count; i++)
        {
            currentSection = sections[i];
            // Calculate u for texture uv and color interpolation
            float u = 0.0f;
            if (i != 0)
                u = Mathf.Clamp01((currentTime - currentSection.time) / time);

            for (int j = 0; j < vertexCountPerSection; j++)
            {
                vertices[i * vertexCountPerSection + j] = localSpaceTransform.MultiplyPoint(currentSection.points[j]);
                uv[i * vertexCountPerSection + j] = new Vector2(u, (float)j / (vertexCountPerSection - 1));
            }
        }

        int[] triangles = new int[(sections.Count - 1) * (vertexCountPerSection - 1) * 2 * 3];

        for (int i = 0; i < sections.Count - 1; i++)
            for (int j = 0; j < vertexCountPerSection - 1; j++)
            {
                int lbIdx = i * vertexCountPerSection + j;
                int ltIdx = (i + 1) * vertexCountPerSection + j;

                int startTriIdx = (i * (vertexCountPerSection - 1) + j) * 6;
                triangles[startTriIdx + 0] = lbIdx;
                triangles[startTriIdx + 1] = lbIdx + 1;
                triangles[startTriIdx + 2] = ltIdx;

                triangles[startTriIdx + 3] = ltIdx;
                triangles[startTriIdx + 4] = lbIdx + 1;
                triangles[startTriIdx + 5] = ltIdx + 1;
            }

        mesh.vertices = vertices;
        mesh.uv = uv;
        mesh.triangles = triangles;
    }

    void OnDrawGizmos()
    {
        Gizmos.color = Color.red;

        for (int i = 0; i < shapePoints.Length - 1; i++)
            Gizmos.DrawLine(shapePoints[i].position, shapePoints[i + 1].position);
    }
}