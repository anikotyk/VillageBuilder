using UnityEngine;
using System.Collections;
using System.Linq;
using System.Collections.Generic;
using UnityEngine.Events;

public class WeaponController : MonoBehaviour
{
    [SerializeField] private List<Weapon> _weapons;

    private bool _enabled = true;
    public bool Enabled
    {
        get => _enabled;
        private set
        {
            if(_enabled == value)
                return;
            _enabled = value;
            ChangedActive?.Invoke(_enabled);
        }
    }
    
    public UnityAction<bool> ChangedActive { get; set; }
    public UnityAction UsedDisabledWeapon { get; set; }

    public bool TryGetWeapon(WeaponType weaponType, out Weapon weapon)
    {
        weapon = null;
        if (Enabled == false)
        {
            UsedDisabledWeapon?.Invoke();
            return false;
        }

        if (_weapons.Count(x => x.InUse && x.Type != weaponType) > 0)
            return false;
        
        weapon = _weapons.Find(x => x.Type == weaponType);
        if (weapon == null)
            return false;
        
        return true;
    }

    public void Disable()
    {
        foreach (var weapon in _weapons)
        {
            weapon.gameObject.SetActive(false);
        }
        Enabled = false;
    }

    public void Enable()
    {
        foreach (var weapon in _weapons)
        {
            weapon.gameObject.SetActive(true);
        }
        Enabled = true;
    }
}
