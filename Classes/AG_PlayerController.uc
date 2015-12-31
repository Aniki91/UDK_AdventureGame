class AG_PlayerController extends SimplePC;

const MAX_LEVEL = 50;
const XP_INCREMENT = 500;

var() ParticleSystemComponent Template;

var int XP;
var int Level;
var int XPGatheredForNextLevel;
var int XPRequiredForNextLevel;

var vector PlayerViewOffset;
var vector CurrentCameraLocation;
var vector DesiredCameraLocation;

var SoundCue BallofLight_Sound;
var SoundCue BallofLight_Sound2;
var SoundCue LevelUp_Sound;

var AG_ShieldCage ShieldCage;
var AG_SprintWings SprintWings;
var AG_BallofLight BL;
var bool bOrbLight;
var bool bEnemyFlee;

var bool bShieldCageAbility;
var bool bSprintWingsAbility;
var bool bThirdPersonAbility;
var bool bSlowTimeAbility;

var int TimeVar;

var rotator CurrentCameraRotation;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    ShieldCage=Spawn(class'AdventureGame.AG_ShieldCage', self);
    ShieldCage.SetHidden(True);
    SprintWings=Spawn(class'AdventureGame.AG_SprintWings', self);
    SprintWings.SetHidden(True);
    
    CalculateLevelProgress();
}

function savePCProgress()
{
    local AG_GameState GS;
    
    GS = new class'AG_GameState';

    GS.PlayerLevel = Level;
    GS.GatheredXP = XPGatheredForNextLevel;
    GS.RequiredXP = XPRequiredForNextLevel;
    GS.TotalXP = XP;

    class'Engine'.static.BasicSaveObject(GS, "GameState.bin", true, 0);
}

function loadPCProgress()
{
    local AG_GameState GS;

    GS = new class'AG_GameState';

    if(class'Engine'.static.BasicLoadObject(GS, "GameState.bin", true, 0))
    {
        Level = GS.PlayerLevel;
        XPGatheredForNextLevel = GS.GatheredXP;
        XPRequiredForNextLevel = GS.RequiredXP;
        XP = GS.TotalXP;
    }
    else
    {
        `log("There is no saved PC data.");
    }
}

public function GiveXP(int amount)
{
    XP += amount;

    CalculateLevelProgress();

    while(XPGatheredForNextLevel >= XPRequiredForNextLevel && Level < MAX_LEVEL)
    {
        Level++;

        CalculateLevelProgress();

        PlaySound(LevelUp_Sound);
    }
}

// Calculate camera location and orientation to the pawn per tick.
function PlayerTick(float DeltaTime)
{
    super.PlayerTick(DeltaTime);

    if(Pawn != none)
    {
        if(bThirdPersonAbility == False)
        {
            DesiredCameraLocation = Pawn.Location + (PlayerViewOffset);
            
            CurrentCameraLocation += (DesiredCameraLocation - CurrentCameraLocation) * DeltaTime * TimeVar;
        }
        else
        {
            DesiredCameraLocation = Pawn.Location + (PlayerViewOffset >> Pawn.Rotation);
            
            CurrentCameraLocation += (DesiredCameraLocation - CurrentCameraLocation) * DeltaTime * TimeVar;
        }
    }
}

private function CalculateLevelProgress()
{
    local int XPToCurrentLevel;

    XPToCurrentLevel = 0.5*Level*(Level-1)*XP_INCREMENT;
    XPGatheredForNextLevel = XP - XPToCurrentLevel;
    XPRequiredForNextLevel = Level * XP_INCREMENT;
}

// Attach the Shield actor to the pawn.
event Possess(Pawn aPawn, bool bVehicleTransition)
{
    // Shield variables.
    local Vector Shield_loc;
    local Vector Wings_loc;
    super.Possess(aPawn, bVehicleTransition);
    Shield_loc.Z = -48;
    Wings_loc.Z = -64;
    Wings_loc.Y = 12;

    if (SprintWings != none)
    {
        SprintWings.SetBase(Pawn);
        SprintWings.SetRelativeLocation(Wings_loc);
    }

    if (ShieldCage != None)
    {
        ShieldCage.SetBase(Pawn);
        ShieldCage.SetRelativeLocation(Shield_loc);
    }
}

// Output the camera location and orientation.
simulated event GetPlayerViewPoint(out vector out_Location, out Rotator out_Rotation)
{
    super.GetPlayerViewPoint(out_Location, out_Rotation);

    if(Pawn != none)
    {
        Pawn.Mesh.SetOwnerNoSee(False);
        if(Pawn.Weapon != none)
                Pawn.Weapon.SetHidden(True);

        out_Location = CurrentCameraLocation;
        
        if(bThirdPersonAbility == False)
        {
            out_Rotation = rotator(Pawn.Location - out_Location);
        }
    }

    if(bThirdPersonAbility == False)
    {
        CurrentCameraRotation = out_Rotation;
    }
}

// To adjust the weapon fire location.
function Rotator GetAdjustedAimFor(Weapon W, vector StartFireLoc)
{
    return Pawn.Rotation;
}

// When the player in is this state, the controls are in relation to the camera's view point.
state PlayerWalking
{
    function ProcessMove(float DeltaTime, vector newAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
    {
        local vector X, Y, Z, AltAccel;

        GetAxes(CurrentCameraRotation, X, Y, Z);
        AltAccel = PlayerInput.aForward * Z + PlayerInput.aStrafe * Y;
        AltAccel.Z = 0;
        AltAccel = Pawn.AccelRate * Normal(AltAccel);
            
        super.ProcessMove(DeltaTime, AltAccel, DoubleClickMove, DeltaRot);
    }
}

// Spawn Navigation Star
exec function Use()
{
    if (bOrbLight == False && Level >= 3)
    {
        bOrbLight = True;
        bEnemyFlee = False;
        BL.Destroy();
        PlaySound(BallofLight_Sound2);
    }
    else if (bOrbLight == True && Level >= 3)
    {
        bOrbLight = False;
        bEnemyFlee = True;
        BL.Destroy();
        BL = spawn(class'AG_BallofLight',,, Pawn.Location);
        PlaySound(BallofLight_Sound);
    }
}

// Use custom HUD.
reliable client function ClientSetHUD(class<HUD> newHUDtype)
{
    if(myHUD != none)
    {
        myHUD.Destroy();

        myHUD = spawn(class'AG_HUD', self);
    }
}

defaultproperties
{
    Level=1;
    XP=0;

    InputClass=Class'AdventureGame.AG_PlayerInput'

    bOrbLight=True
    bEnemyFlee=False

    BallofLight_Sound=SoundCue'A_Interface.menu.UT3MenuCheckboxSelectCue'
    BallofLight_Sound2=SoundCue'A_Interface.menu.UT3MenuCheckboxDeselectCue'
    LevelUp_Sound=SoundCue'CastleAudio.UI.UI_MainMenu_Cue'

    TimeVar=15

    PlayerViewOffset=(X=-192,Y=-344,Z=312)
}