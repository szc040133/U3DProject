using UnityEngine;
using System.Collections;

public class ObjectBase 
{
    protected ulong _id;
    protected Transform _transform;
    protected bool _isDestroy;
    protected float _scale = 1;

    public ObjectBase(ulong id)
    {
        _id = id;
        _transform = new GameObject(id.ToString()).transform;
    }

    protected virtual void Init()
    {

    }

    public virtual void Start()
    {

    }

    public virtual float Scale
    {
        get { return _scale; }
        set
        {
            _scale = value;
            _transform.localScale = new Vector3(_scale, _scale, _scale);
        }
    }

    public virtual void Destroy()
    {
        if (_transform != null) GameObject.Destroy(_transform.gameObject);
        _isDestroy = true;
    }

    public ulong Id
    {
        get { return _id; }
        set { _id = value; }
    }

    public bool IsDestroy { get { return _isDestroy; } }
}
