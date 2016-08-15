using UnityEngine;
using System.Collections;

public class LoadingView : MonoBehaviour 
{
    private Transform _myTransform;
    private LoadingServer _server;
    private UISlider _uiSlider;
    private Transform _bg;
    private UILabel _tipText;
    private GameObject _tipGo;

	void Awake()
    {
        _myTransform = transform;
        _bg = _myTransform.Find("Background");
        _uiSlider = _bg.Find("UISlider").GetComponent<UISlider>();
        _tipText = _bg.Find("TipsBg/Text").GetComponent<UILabel>();
        _tipGo = _bg.Find("TipsBg").gameObject;
        _tipGo.SetActive(false);
        DontDestroyOnLoad(gameObject);
        Application.LoadLevel("Loading");
    }

    IEnumerator Start()
    {
        MonoManaer.GetInstance().StopAllCoroutines();
        DownLoadManager.GetInstance().UnLoadUnnecessary(new[] { DownUtils.NeedSign, _server.Sign });
        _tipText.text = "正在加载中……";
        _tipGo.SetActive(true);
        yield return new WaitForEndOfFrame();
        _server.DownLoad.Load(delegate(ResDownLoader dl) { StartCoroutine(LoadLevel()); }, Progress);
    }

    private IEnumerator LoadLevel()
    {
        _uiSlider.value = 0.98f;
        yield return Application.LoadLevelAsync(_server.Level);
        _uiSlider.value = 1f;
        yield return new WaitForEndOfFrame();
        new GameObject("Scene").AddComponent<SceneMananger>();
    }

    private void Progress(float progress, string path)
    {
        _uiSlider.value = progress * 0.95f;
    }

    public void Close(EventDelegate.Callback callBack)
    {
        EventDelegate.Add(TweenAlpha.Begin(_bg.gameObject, 1f, 0f).onFinished, callBack);
    }

    public LoadingServer Server { set { _server = value; } }
}
