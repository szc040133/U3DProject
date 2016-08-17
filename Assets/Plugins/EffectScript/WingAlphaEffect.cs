using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class WingAlphaEffect : MonoBehaviour 
{
    public float Timer;
    public float Alpha;
    public float OneDelayTimer;
    public float TwoDelayTimer;

    private float _timer;
    private float _delayTimer;
    private bool _positive = true;
    private Renderer[] _renderers;
    private List<Material> _materials = new List<Material>();
    private List<Color> _colors = new List<Color>();
    private List<float> _colorsAlpha = new List<float>();
    void Awake()
    {
        _renderers = transform.GetComponentsInChildren<Renderer>();
        for (int i = 0; i < _renderers.Length; i++)
        {
            _materials.AddRange(_renderers[i].materials);
        }
        for (int i = 0; i < _materials.Count; i++)
        {
            _colors.Add(_materials[i].GetColor("_Color"));
            _colorsAlpha.Add(_colors[i].a);
        }
    }

    void OnEnable()
    {
        _delayTimer = _timer = 0;
        _positive = true;
    }

    void OnDisable()
    {

    }

	void Update()
    {
        if (_delayTimer > 0)
        {
            _delayTimer -= Time.deltaTime;
            return;
        }
        _timer += Time.deltaTime;
        if (_timer > Timer)
        {
            _delayTimer = _positive ? OneDelayTimer : TwoDelayTimer;
            _positive = !_positive;
            _timer = 0;
        }
        float lerp = _timer / Timer;
        if (!_positive) lerp = 1 - lerp;

        for (int i = 0; i < _materials.Count; i++)
        {
            var color = _colors[i];
            color.a = Mathf.Lerp(_colorsAlpha[i], Alpha, lerp);
            _materials[i].SetColor("_Color", color);
        }
	}
}
