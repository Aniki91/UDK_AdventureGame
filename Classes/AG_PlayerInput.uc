class AG_PlayerInput extends PlayerInput within AG_PlayerController;

var UTEmitter Ability_Activate;
var UTEmitter Ability_Activate_2;
var UTEmitter Ability_Deactivate;

var UTEmitter Sprint_Ability_Activate;
var UTEmitter Sprint_Ability_Deactivate;

var AG_PlayerController PC;
var AG_Pawn Pwn;

var bool isVisible_ShieldCage;
var bool isVisible_SprintWings;
var int Shield_SpawnCount;
var int Sprint_SpawnCount;

var SoundCue Shield_ActivateSound;
var SoundCue Shield_DeactivateSound;
var SoundCue Sprint_ActivateSound;
var SoundCue Sprint_DeactivateSound;
var SoundCue SlowMo_ActivateSound;
var SoundCue SlowMo_DeactivateSound;

var float Shield_AbilityTime;
var float Shield_ActivateTime;
var float Sprint_AbilityTime;
var float Sprint_ActivateTime;
var float SlowMo_AbilityTime;
var float SlowMo_ActivateTime;

var bool Shield_PlayOnce;
var bool Sprint_PlayOnce;
var bool SlowMo_PlayOnce;

// Call to spawn the SprintBurstAbility.
simulated exec function SprintBurstAbility()
{
    if(Pawn != none && !isVisible_SprintWings && Sprint_SpawnCount > 0 && !bShieldCageAbility && Level >= 4)
    {
        bSprintWingsAbility = True;
        `log("bSprintWingsAbility?: " @bSprintWingsAbility);

        Sprint_SpawnCount--;
        Sprint_AbilityTime = 3.0;

        Sprint_ActivateTime = WorldInfo.TimeSeconds;
        
        Sprint_Ability_Activate=Spawn(Class'UTEmitter',,,Pawn.Location,Pwn.Rotation);
        Sprint_Ability_Activate.SetTemplate(ParticleSystem'Envy_Effects.Particles.P_Player_Spawn_Blue');

        PlaySound(Sprint_ActivateSound);

        Pawn.GroundSpeed = 400;
        isVisible_SprintWings = True;
        SprintWings.SetHidden(False);
    }
}

// Call Third Person View
simulated exec function ThirdPersonAbility()
{
    if(Pawn != none && bThirdPersonAbility == False)
    {
        bThirdPersonAbility = True;
        `log("bThirdPersonAbility?: " @bThirdPersonAbility);

        PlayerViewOffset.X = -96;
        PlayerViewOffset.Y = 48;
        PlayerViewOffset.Z = 16;

        Pawn.GroundSpeed = 0;
    }
    else if(Pawn != none && bThirdPersonAbility == True)
    {
        bThirdPersonAbility = False;
        `log("bThirdPersonAbility?: " @bThirdPersonAbility);

        PlayerViewOffset.X = -192;
        PlayerViewOffset.Y = -344;
        PlayerViewOffset.Z = 312;

        Pawn.GroundSpeed = 225;
    }
}

simulated exec function SlowTimeAbility()
{
    if(Pawn != none && bSlowTimeAbility == False && SlowMo_PlayOnce == False)
    {
        bSlowTimeAbility = True;
        `log("bSlowDownTime?: " @bSlowTimeAbility);

        SlowMo_AbilityTime = 1.0;

        SlowMo_ActivateTime = WorldInfo.TimeSeconds;
        
        PlaySound(SlowMo_ActivateSound);

        ConsoleCommand("Slomo 0.25");
        Pawn.GroundSpeed = 750;
    }
}

// Call to Spawn the ShieldCageAbility.
simulated exec function ShieldCageAbility()
{
    if(Pawn != none && !isVisible_ShieldCage && Shield_SpawnCount > 0 && !bSprintWingsAbility && Level >= 5)
    {
        bShieldCageAbility = True;
        `log("bShieldCageAbility?: " @bShieldCageAbility);

        Shield_SpawnCount--;
        Shield_AbilityTime = 3.0;

        Shield_ActivateTime = WorldInfo.TimeSeconds;

        Ability_Activate_2=Spawn(Class'UTEmitter',,,Pawn.Location,Pwn.Rotation);
        Ability_Activate_2.SetTemplate(ParticleSystem'KismetGame_Assets.Effects.P_PickupRing_01');
        Ability_Activate=Spawn(Class'UTEmitter',,,Pawn.Location,Pwn.Rotation);
        Ability_Activate.SetTemplate(ParticleSystem'VH_Scorpion.Effects.PS_Scorpion_Gun_Impact');

        PlaySound(Shield_ActivateSound);

        Pawn.GroundSpeed = 0;
        isVisible_ShieldCage = True;
        ShieldCage.SetHidden(False);
        KillEnemies();
    }
}

// Function to find all currently alive enemies and Destroy them.
function KillEnemies()
{
    local AG_Enemy1 EP;
    local int Count;

    foreach AllActors(class'AG_Enemy1', EP)
    {
        Count++;
        EP.Destroy();
    }

    foreach LocalPlayerControllers(class'AG_PlayerController', PC)
    {
        PC.GiveXP(250*Count);
    }
}

// The count per frame of the abbility to dissapear after 3 seconds.
function Tick(float DeltaTime)
{
    if((WorldInfo.TimeSeconds - Shield_ActivateTime) >= Shield_AbilityTime && Shield_PlayOnce == True)
    {
        bShieldCageAbility = False;
        `log("bShieldCageAbility?: " @bShieldCageAbility);

        Shield_PlayOnce = False;
        PlaySound(Shield_DeactivateSound);

        isVisible_ShieldCage = False;
        ShieldCage.SetHidden(True);
        Pawn.GroundSpeed = 225;
        
        Ability_Deactivate=Spawn(Class'UTEmitter',,,Pawn.Location,Pawn.Rotation);
        Ability_Deactivate.SetTemplate(ParticleSystem'Pickups.Flag.Effects.P_Flagbase_FlagCaptured_Blue');
    }
    
    if((WorldInfo.TimeSeconds - Sprint_ActivateTime) >= Sprint_AbilityTime && Sprint_PlayOnce == True)
    {
        bSprintWingsAbility = False;
        `log("bSprintWingsAbility?: " @bSprintWingsAbility);

        Sprint_PlayOnce = False;
        PlaySound(Sprint_DeactivateSound);

        isVisible_SprintWings = False;
        SprintWings.SetHidden(True);
        Pawn.GroundSpeed = 225;
        
        Sprint_Ability_Deactivate=Spawn(Class'UTEmitter',,,Pawn.Location,Pwn.Rotation);
        Sprint_Ability_Deactivate.SetTemplate(ParticleSystem'Envy_Effects.Particles.P_Player_Spawn_Blue');
    }
    
    if((WorldInfo.TimeSeconds - SlowMo_ActivateTime) >= SlowMo_AbilityTime && SlowMo_PlayOnce == True)
    {
        bSlowTimeAbility = False;
        `log("bSlowDownTime?: " @bSlowTimeAbility);
        
        SlowMo_PlayOnce = False;
        
        PlaySound(SlowMo_DeactivateSound);

        ConsoleCommand("Slomo 1.0");
        Pawn.GroundSpeed = 225;
    }
}

defaultproperties()
{
    Shield_AbilityTime=64000.0
    Shield_PlayOnce=True
    Sprint_AbilityTime=64000.0
    Sprint_PlayOnce=True
    SlowMo_AbilityTime=64000.0
    SlowMo_PlayOnce=True

    Shield_ActivateSound=SoundCue'A_Pickups.ShieldBelt.Cue.A_Pickups_Shieldbelt_Activate_Cue'
    Shield_DeactivateSound=SoundCue'A_Pickups.Ammo.Cue.A_Pickup_Ammo_Respawn_Cue'
    
    Sprint_ActivateSound=SoundCue'A_Pickups_Powerups.PowerUps.A_Powerup_JumpBoots_JumpCue'
    Sprint_DeactivateSound=SoundCue'A_Pickups_Powerups.PowerUps.A_Powerup_JumpBoots_PickupCue'
    
    SlowMo_ActivateSound=SoundCue'A_Pickups_Powerups.PowerUps.A_Powerup_UDamage_PickupCue'
    SlowMo_DeactivateSound=SoundCue'A_Gameplay.A_Gameplay_Onslaught_PowerNodeStartBuild01Cue'

    Shield_SpawnCount=1
    Sprint_SpawnCount=1
}