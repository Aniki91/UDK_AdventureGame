class AG_Staff extends AG_Weapon;

defaultproperties
{
        Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'WP_RocketLauncher.Mesh.SK_WP_RocketLauncher_3P'
        End Object

        AttachmentClass=class'UTGameContent.UTAttachment_RocketLauncher'

        WeaponFireTypes(0)=EWFT_Projectile
        WeaponFireTypes(1)=EWFT_Projectile
        
        WeaponProjectiles(0)=class'UTProj_Rocket'
        WeaponProjectiles(1)=class'UTProj_Rocket'

        AmmoCount=0
        MaxAmmoCount=3

        FireInterval(0)=1.0
        FireInterval(1)=1.0
}