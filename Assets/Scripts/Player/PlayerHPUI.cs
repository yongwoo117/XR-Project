using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlayerHPUI : MonoBehaviour
{
    [SerializeField] private GameObject hpUIPrefab;
    [SerializeField] private Transform contentOfScrollView;
    [SerializeField] private int spriteCount;
    [SerializeField] private List<Sprite> spriteList;

    private Image[] hpComponents;
    
    private void Awake()
    {
        hpComponents = new Image[spriteCount];
        for (var index = 0; index < hpComponents.Length; ++index)
        {
            var instance = Instantiate(hpUIPrefab, contentOfScrollView);
            hpComponents[index] = instance.GetComponent<Image>();
        }
    }

    public void OnHealthRatioChanged(float value)
    {
        var spriteIndex = Mathf.FloorToInt(value * spriteCount);
        var lowerSpriteIndex = Mathf.Clamp(Mathf.CeilToInt(value * spriteCount % 1 * spriteList.Count), 0, 3);

        for (var index = 0; index < spriteIndex; ++index) hpComponents[index].sprite = spriteList[^1];
        if (spriteIndex < spriteCount) hpComponents[spriteIndex].sprite = spriteList[lowerSpriteIndex];
        for (var index = spriteIndex + 1; index < spriteCount; ++index) hpComponents[index].sprite = spriteList[0];
    }
}
