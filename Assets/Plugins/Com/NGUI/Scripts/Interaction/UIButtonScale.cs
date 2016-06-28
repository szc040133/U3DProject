using System;
using DG.Tweening;
using UnityEngine;
using UnityEngine.Events;

[AddComponentMenu("NGUI/Interaction/Button Scale")]
public class UIButtonScale : MonoBehaviour
{
	[Serializable]
	public class ButtonScaleDelayEvent : UnityEvent { }

	[SerializeField]
	private readonly ButtonScaleDelayEvent _onDelayClick = new ButtonScaleDelayEvent();

	public ButtonScaleDelayEvent onDelayClick { get { return _onDelayClick; } }

	public Transform tweenTarget;

	public bool showPressed = false;
	public Vector3 pressed = new Vector3(0.97f, 0.97f, 0.97f);
	public float pressedDuration = 0.2f;

	public bool showDiverge = false;
	public Vector3 diverge = new Vector3(1.15f, 1.4f, 1.1f);
	public float divergeDuration = 0.2f;

	private Vector3 _mScale;
	private bool _mStarted;

	private bool _isUp;
	private bool _inMin;
	private Tweener _tweener;
	private bool _enabled;
	private UISprite _buttonSprite;
	private UISprite _lightSprite;
	private UILabel _buttonLabel;
	private Color _buttonColor;
	private Color _effectColor;
	private int _currentType;

	void Awake()
	{
		_buttonSprite = GetComponent<UISprite>();

		Transform transLight = transform.Find("Light");
		if (transLight) _lightSprite = transLight.GetComponent<UISprite>();

		if (_buttonSprite && _buttonSprite.spriteName.StartsWith("ButtonType"))
		{
			_currentType = int.Parse(_buttonSprite.spriteName.Substring(10));
		}
		Transform transLabel = transform.Find("Text");
		if (transLabel)
		{
			_buttonLabel = transLabel.GetComponent<UILabel>();
			_buttonColor = _buttonLabel.color;
			_effectColor = _buttonLabel.effectColor;
		}
	}

	void Start()
	{
		if (!_mStarted)
		{
			_mStarted = true;
			if (tweenTarget == null) tweenTarget = transform;
			_mScale = tweenTarget.localScale;
		}
	}

	void OnPress(bool isPressed)
	{
		if (enabled && showPressed)
		{
			if (!_mStarted) Start();
			_isUp = !isPressed;
			if (isPressed)
			{
				if (_tweener != null && _tweener.IsPlaying()) _tweener.Kill();
				_tweener = tweenTarget.transform.DOScale(pressed, pressedDuration);
				_tweener.OnComplete(() => { _inMin = true; if (_isUp) { TweenUp(); } });
			}
			else if (_inMin) TweenUp();
		}
	}

	private void TweenUp()
	{
		_inMin = false;
		tweenTarget.transform.DOScale(_mScale, pressedDuration);
	}

	void OnClick()
	{
		if (showDiverge)
		{
			GameObject go = NGUITools.AddChild(tweenTarget.parent.gameObject, tweenTarget.gameObject);
			go.transform.localPosition = tweenTarget.localPosition;
			TweenAlpha.Begin(go, divergeDuration * 4, 0);
			go.transform.DOScale(diverge, divergeDuration * 4).OnComplete(() => { _onDelayClick.Invoke(); });
			Destroy(go, divergeDuration * 4);
		}
	}

	public void SetEnabled(bool value)
	{
		_enabled = value;
		if (_currentType > 0)
		{
			if (_buttonSprite) _buttonSprite.spriteName = "ButtonType" + (value ? _currentType : 5);
			if (_lightSprite) _lightSprite.spriteName = "LightType" + (value ? _currentType : 5);
			if (_buttonLabel)
			{
				_buttonLabel.color = value ? _buttonColor : new Color(0.8f, 0.8f, 0.8f, 1);
				_buttonLabel.effectColor = value ? _effectColor : new Color(0.1f, 0.1f, 0.1f, 1);
			}
		}
	}

	public bool Enabled { get { return _enabled; } }
}