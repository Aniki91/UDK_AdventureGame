class AG_Enemy1 extends AG_Actor
        placeable;

var() ParticleSystemComponent Template;
var UTEmitter Enemy_Destroyed;
var SoundCue DestroySound;
var SoundCue JazzHappy;

var Pawn Enemy;

var float FollowDistance;
var float AttackDistance;

var float BumpDamage;

// The functions to call when the Enemy takes damage and the TakeDamage function.
event TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum,
class<DamageType> DamageType, optional TraceHitInfo HitInfo, Optional Actor DamageCauser)
{
    local AG_PlayerController PC;
    
    foreach LocalPlayerControllers(class'AG_PlayerController',PC)
    {
        PC.GiveXP(250);
    }

    if(EventInstigator != none && EventInstigator.PlayerReplicationInfo != none)
        WorldInfo.Game.ScoreObjective(EventInstigator.PlayerReplicationInfo, 1);

        Enemy_Destroyed=Spawn(Class'UTEmitter',,,Location,Rotation);
        Enemy_Destroyed.SetTemplate(ParticleSystem'WP_ShockRifle.Particles.P_WP_ShockRifle_Ball_Impact');

        PlaySound(DestroySound);
        
        Destroy();
}

// The function to calculate the enemies position to the player and to update tick.
function Tick(float DeltaTime)
{
    local AG_PlayerController PC;
    local vector NewLocation;

    if(Enemy == none)
    {
        foreach LocalPlayerControllers(class'AG_PlayerController', PC)
        {
            if(PC.Pawn != none)
                Enemy = PC.Pawn;
        }
    }
    else if (Vsize(Location - Enemy.Location) < FollowDistance && PC.bEnemyFlee == False)
    {
        if(Vsize(Location - PC.Location) < AttackDistance)
        {
            PC.Bump(self, CollisionComponent, vect(0,0,0));
        }
        else
        {
            NewLocation = Location;
            NewLocation += (Enemy.Location * vect(1,1,1) - Location) * DeltaTime;
            SetLocation(NewLocation);
        }
    }
}

defaultproperties
{
    FollowDistance=2048.0

    BumpDamage=25.0

    bBlockActors=True
    bCollideActors=True

    DestroySound=SoundCue'A_Weapon_ShockRifle.Cue.A_Weapon_SR_WhipCue'
    JazzHappy=SoundCue'KismetGame_Assets.Sounds.Jazz_Chatter_Happy_Cue'

    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
        bEnabled=True
    End Object
    Components.Add(MyLightEnvironment)

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
    
    Begin Object Class=ParticleSystemComponent Name=ParticleSystemComponent0
        Template=ParticleSystem'WP_LinkGun.Effects.P_FX_LinkGun_3P_Beam_MF_Gold'
        Scale3D=(X=2.0,Y=2.0,Z=2.0)
    End Object
        Template=ParticleSystemComponent0
        Components.Add(ParticleSystemComponent0)

        Begin Object Class=SpriteComponent Name=EP_Sprite
        Sprite = S_Actor
        HiddenGame=true
    End Object
    Components.Add(EP_Sprite)
}