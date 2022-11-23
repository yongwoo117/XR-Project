using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyHpBar : MonoBehaviour
{
    private Material material;
    private float blend;
    private float fill;
    private void Awake()
    {
        material = GetComponent<SpriteRenderer>().material;
        blend = 1f;
    }

    public void SetHp(float ratio)
    {
        fill = ratio;
        material?.SetFloat("Fill", ratio);
    }


    private void FixedUpdate()
    {
        if (fill < blend)
        {
            blend -= Time.deltaTime;
            material.SetFloat("BlendFill", blend);
        }
    }
  
}
