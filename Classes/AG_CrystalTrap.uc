class AG_CrystalTrap extends AG_Actor
        placeable;

var SoundCue DestroySound;
var UTEmitter CrystalTrap_Destroyed;

// The functions to call when the CrystalTrap takes damage and the TakeDamage function.
event TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum,
class<DamageType> DamageType, optional TraceHitInfo HitInfo, Optional Actor DamageCauser)
{
    if(EventInstigator != none && EventInstigator.PlayerReplicationInfo != none)
        WorldInfo.Game.ScoreObjective(EventInstigator.PlayerReplicationInfo, 1);

        CrystalTrap_Destroyed=Spawn(Class'UTEmitter',,,Location,Rotation);
        CrystalTrap_Destroyed.SetTemplate(ParticleSystem'WP_ShockRifle.Particles.P_WP_ShockRifle_Explo');

        PlaySound(DestroySound);

        Destroy();
}

defaultproperties
{
    bStatic=False
    bNoDelete=False
    bBlockActors=True
    bCollideActors=True

    DestroySound=SoundCue'A_Weapon_ShockRifle.Cue.A_Weapon_SR_AltFireImpactCue'

    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
        bEnabled=True
    End Object
    Components.Add(MyLightEnvironment)

    Begin Object Class=StaticMeshComponent Name=AG_CrystalTrap
        StaticMesh=StaticMesh'AdventureGamePackages.Models.CrystalTrap_1'
        LightEnvironment=MyLightEnvironment
        Scale3D=(X=2.0,Y=2.0,Z=2.0)
    End Object
    Components.Add(AG_CrystalTrap)
    
    Begin Object Class=CylinderComponent Name=CollisionCylinder
        CollisionRadius=64.0
        CollisionHeight=128.0
        BlockNonZeroExtent=True
        BlockZeroExtent=True
        BlockActors=True
        CollideActors=True
    End Object
    CollisionComponent=CollisionCylinder
    Components.Add(CollisionCylinder)
}