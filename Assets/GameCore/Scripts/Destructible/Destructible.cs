using System.Collections;
using System.Collections.Generic;
using NaughtyAttributes;
using UnityEngine;
using UnityEngine.Events;

public abstract class Destructible : MonoBehaviour, IProgressible
{
    [SerializeField] private int _health;
    [SerializeField] private WeaponType _weaponTypeToDamage;
    
    [SerializeField, ShowIf(nameof(_debug))] private int _damage = 0;
    [SerializeField] private bool _debug;
    private bool _using = false;
    
    public int MaxHealth => _health;
    public int Health => MaxHealth - _damage;

    public bool IsAlive => Health > 0;

    public UnityAction<int> Damaged { get; set; }
    public UnityAction HealthChanged { get; set; }
    
    public Weapon CurrentWeaponInUse { get; private set; }
    
    public UnityAction<float> ProgressChanged { get; set; }

    public void Respawn()
    {
        _damage = 0;
        _using = false;
        HealthChanged?.Invoke();
        ProgressChanged?.Invoke(1);
    }
    
    public void Use(EquippedCharacter equippedCharacter)
    {
        if(IsAlive == false || _using)
            return;
        if (equippedCharacter.WeaponController.TryGetWeapon(_weaponTypeToDamage, out Weapon weapon))
        {
            UseWeapon(weapon);
        }
    }

    public void UseWeapon(Weapon weapon)
    {
        if(IsAlive == false || _using)
            return;
        
        CurrentWeaponInUse = weapon;
        _using = true;
        weapon.Used += OnWeaponUse;
        weapon.EndedUsing += OnWeaponEndUse;
        weapon.Use();
    }

    public void AbortWeaponUse(Weapon weapon)
    {
        if (weapon == CurrentWeaponInUse)
        {
            OnWeaponEndUse(weapon);
            weapon.AbortUse();
        }
    }

    private void OnWeaponUse(Weapon weapon)
    {
        if (IsAlive == false || UseCondition(weapon) == false)
        {
            OnWeaponEndUse(weapon);
            return;
        }
        CurrentWeaponInUse = weapon;
        int damage = weapon.Damage;
        if (Health - damage < 0)
            damage = Health;
        
        _damage += damage;
        ProgressChanged?.Invoke((float)Health/MaxHealth);
        Damaged?.Invoke(damage);
        HealthChanged?.Invoke();
        OnHealthChanged(Health);
        if (IsAlive == false)
        {
            CurrentWeaponInUse = null;
            return;
        }
        
        weapon.Use();
    }

    private void OnWeaponEndUse(Weapon weapon)
    {
        _using = false;
        CurrentWeaponInUse = null;
        weapon.Used -= OnWeaponUse;
        weapon.EndedUsing -= OnWeaponEndUse;
    }

    protected abstract bool UseCondition(Weapon weapon);

    protected virtual void OnHealthChanged(int health)
    {
    }

    private void DebugLog(string log)
    {
        if(_debug == false)
            return;
        Debug.Log(log);
    }

}
