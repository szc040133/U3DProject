using UnityEngine;
using System.Collections;
using System.Collections.Generic;
public delegate void ResDownLoaderComplete(ResDownLoader downloader);
public delegate void ResDownLoaderProgress(float progress,string path);

public class ResDownLoader 
{
    private List<DownLoad> _downLoader = new List<DownLoad>();
    private List<ResDownLoaderComplete> _completes = new List<ResDownLoaderComplete>();
    private List<ResDownLoaderProgress> _progress = new List<ResDownLoaderProgress>();
    private DownLoadState _state = DownLoadState.None;
    private DownLoadManager _downManager;
    private MonoManaer _monoManager;
    private string[] _path;
    private bool _async;
    private string[] _loadPath;
    private int _completeCount;
    private int _loadIndex;
    public int FpsNum = 3;
    private int _nowFpsNum;

    private void Initialize(string[] path,bool async)
    {
        _downManager = DownLoadManager.GetInstance();
        _monoManager = MonoManaer.GetInstance();
        _path = path;
        _async = async;

        //_loadPath = DownLoadManager.GetDependencies(path, true);
        //for (int i = 0; i < _loadPath.Length; i++)
        //{
        //    _downLoader.Add(DownLoadManager.DownLoader(_loadPath[i]));
        //}
    }

    public void Load(ResDownLoaderComplete complete=null,ResDownLoaderProgress progress = null)
    {
        switch (_state)
        {
            case DownLoadState.None:
                if (complete != null) _completes.Add(complete);
                if (progress != null) _progress.Add(progress);
                _state = DownLoadState.Runing;
                DownLoader();
                break;
            case DownLoadState.Runing:
                if (complete != null) _completes.Add(complete);
                if (progress != null) _progress.Add(progress);
                break;
            case DownLoadState.Complete:
                if (complete != null) complete(this);
                break;
        }
    }

    private void DownLoader(DownLoad download=null)
    {
        if (download != null)
        {
            _completeCount++;
            for (int i = 0; i < _progress.Count; i++)
            {
                _progress[i](Progress, download.Path);
            }
            if (_completeCount == _loadPath.Length)
            {
                Completes();
                return;
            }
        }
        if (_loadIndex < _loadPath.Length)
        {
            _monoManager.StartCoroutine(StartCoroutine());
        }
    }

    private IEnumerator StartCoroutine()
    {
        if (!_async && FpsNum > 0 && _nowFpsNum >= FpsNum)
        {
            _nowFpsNum = 0;
            yield return new WaitForEndOfFrame();
        }
        _nowFpsNum++;
        _loadIndex++;
        _downLoader[_loadIndex - 1].Load(DownLoader, _async);
    }


    private void Completes()
    {
        for (int i = 0; i < _downLoader.Count;i++ )
        {
            _downLoader[i].UnloadFalse();
        }
        for (int i = 0; i < _completes.Count;i++)
        {
            _completes[i](this);
        }
        _completes.Clear();
        _progress.Clear();
        _completeCount = _loadIndex = 0;
        _state = DownLoadState.None;
    }

    public float Progress
    {
        get
        {
            switch(_state)
            {
                case DownLoadState.None:
                    return 0f;
                case DownLoadState.Runing:
                    float length = _loadPath.Length;
                    float curr = _completeCount;
                    return curr / length;
                case DownLoadState.Complete:
                    return 1f;
            }
            return 0f;
        }
    }
}
