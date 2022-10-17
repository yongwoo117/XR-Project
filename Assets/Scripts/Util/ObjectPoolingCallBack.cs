using  UnityEngine;
using UnityEngine.Pool;

public class ObjectPoolingCallBack: MonoBehaviour
{
    private IObjectPool<GameObject> m_pool;

    public IObjectPool<GameObject> Pool => m_pool;

    public void SetPool(IObjectPool<GameObject> pool)
    {
        m_pool = pool;
    }
}
