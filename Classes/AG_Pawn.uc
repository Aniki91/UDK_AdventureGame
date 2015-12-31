class AG_Pawn extends Pawn;

var bool bInvulnerable;
var float InvulnerableTime;

var SoundCue Take_Damage;
var SoundCue Take_Damage_2;

var float ElapsedRegenTime;
var float RegenAmount;
var float RegenTime;

// For the player's pawn to recieve damage and the functions to call.
event Bump(Actor Other, PrimitiveComponent OtherComp, vector HitNormal)
{
    if (AG_Enemy1(Other) != none && !bInvulnerable)
    {
        bInvulnerable = True;
        SetTimer(InvulnerableTime, false, 'EndInvulnerable');
        TakeDamage(AG_Enemy1(Other).BumpDamage, none, Location, vect(0,0,0), class'UTDmgType_LinkPlasma');
        PlaySound(Take_Damage);
        PlaySound(Take_Damage_2);
    }
}

// Health Regeneration per tick.
public function Tick(float DeltaTime)
{
    ElapsedRegenTime += DeltaTime;

    if (ElapsedRegenTime >= RegenTime)
    {
        HealDamage(RegenAmount,Controller, class'DamageType');
        ElapsedRegenTime = 0.0f;
    }
}

// End of invulnerability function.
function EndInvulnerable()
{
    bInvulnerable = False;
}

defaultproperties
{
    RegenAmount=1
    RegenTime=0.25

    GroundSpeed=225

    InvulnerableTime=0.5

    Take_Damage=SoundCue'KismetGame_Assets.Sounds.Jazz_Pain_Cue'
    Take_Damage_2=SoundCue'A_Weapon_ShockRifle.Cue.A_Weapon_SR_RaiseCue'

    Begin Object class=SkeletalMeshComponent Name=AG_PawnSkeletalMesh
	SkeletalMesh=SkeletalMesh'KismetGame_Assets.Anims.SK_Jazz_Custom'
	AnimSets(0)=AnimSet'KismetGame_Assets.Anims.SK_Jazz_Anims'
	AnimTreeTemplate=AnimTree'KismetGame_Assets.Anims.Jazz_AnimTree'
	Scale3D=(X=0.5,Y=0.5,Z=0.5)
	HiddenGame=false
	HiddenEditor=false
    End Object
    Mesh=AG_PawnSkeletalMesh
    Components.Add(AG_PawnSkeletalMesh)
}