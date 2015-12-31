class AG_HUD extends UTHUD;

//var CanvasIcon HUD_Backdrop;
var GFxMoviePlayer PauseMenuInGame;
var AG_PlayerInput PlyInp;
var SoundCue MenuScrollOpen;
var SoundCue MenuScrollClose;
var float PauseDelay;

/*
function DrawBar_Health(String Title, float Value, float MaxValue,int X, int Y, int R, int G, int B)
{

    local int PosX,NbCases,i;

    PosX = X;
    NbCases = 10 * Value / MaxValue;
    i=0;

    while(i < NbCases && i < 10)
    {
        Canvas.SetPos(PosX + Canvas.ClipX * 0.45, Canvas.ClipY * 0.95);
        Canvas.SetDrawColor(R,G,B,255);
        Canvas.DrawRect(12,16);

        PosX += 15;
        i++;

    }

    while(i < 10)
    {
        Canvas.SetPos(PosX + Canvas.ClipX * 0.45, Canvas.ClipY * 0.95);
        Canvas.SetDrawColor(255,255,255,80);
        Canvas.DrawRect(12,16);

        PosX += 15;
        i++;

    }

    Canvas.SetPos(PosX + Canvas.ClipX * 0.45 + 5,Canvas.ClipY * 0.95);
    Canvas.SetDrawColor(R,G,B,255);
    Canvas.Font = class'Engine'.static.GetSmallFont();
    Canvas.DrawText(Title);

}
*/

/*
function DrawBar_Recharge(String Title, float Value, float MaxValue,int X, int Y, int R, int G, int B)
{

    local int PosX,NbCases,i;

    PosX = X;
    NbCases = 10 * Value / MaxValue;
    i=0;

    while(i < NbCases && i < 10)
    {
        Canvas.SetPos(PosX + Canvas.ClipX * 0.45, Canvas.ClipY * 0.90);
        Canvas.SetDrawColor(R,G,B,200);
        Canvas.DrawRect(12,16);

        PosX += 15;
        i++;

    }

    while(i < 10)
    {
        Canvas.SetPos(PosX + Canvas.ClipX * 0.45, Canvas.ClipY * 0.90);
        Canvas.SetDrawColor(255,255,255,80);
        Canvas.DrawRect(12,16);

        PosX += 15;
        i++;

    }

    Canvas.SetPos(PosX + Canvas.ClipX * 0.45 + 5,Canvas.ClipY * 0.90);
    Canvas.SetDrawColor(R,G,B,200);
    Canvas.Font = class'Engine'.static.GetSmallFont();
    Canvas.DrawText(Title);

}
*/

// Pause menu function.
function TogglePauseMenu()
{
        if (PauseMenuInGame != none && PauseMenuInGame.bMovieIsOpen)
        {
                PlaySound(MenuScrollClose);
                PlayerOwner.SetPause(False);
                PauseMenuInGame.Close(False);
                SetVisible(True);
        }
        else
        {
                PlaySound(MenuScrollOpen);
                SetTimer(PauseDelay, false, 'EndPauseDelay');
                //PlayerOwner.SetPause(False);


                if (PauseMenuInGame == None)
                {
                        PauseMenuInGame = new class'GFxMoviePlayer';
                        PauseMenuInGame.MovieInfo = SwfMovie'AG_Flash.AbilitiesMenu';
                        PauseMenuInGame.bEnableGammaCorrection = False;
                        PauseMenuInGame.LocalPlayerOwnerIndex = class'Engine'.static.GetEngine().GamePlayers.Find( LocalPlayer(PlayerOwner.Player));
                        PauseMenuInGame.SetTimingMode(TM_Real);
                }

                SetVisible(false);
                PauseMenuInGame.Start();
                PauseMenuInGame.Advance(0);

                if( !WorldInfo.IsPlayInMobilePreview() )
                {
                        PauseMenuInGame.AddFocusIgnoreKey('Escape');
                }
        }
}

function EndPauseDelay()
{
    PlayerOwner.SetPause(True);
}

function DrawBar_XP(String Title, float Value, float MaxValue, int X, int Y, int R, int G, int B)
{
    Canvas.SetPos(Canvas.ClipX * 0.45, Canvas.ClipY * 0.05);
    Canvas.Font=Font'AdventureGamePackages.Fonts.KnightsQuest';
    Canvas.DrawText(Title);
}

function DrawBar_Level(String Title, float Value, float MaxValue, int X, int Y, int R, int G, int B)
{
    Canvas.SetPos(Canvas.ClipX * 0.45, Canvas.ClipY * 0.00);
    Canvas.Font=Font'AdventureGamePackages.Fonts.KnightsQuest';
    Canvas.DrawText(Title);
}

// Drawing to the canvas.
function DrawGameHUD()
{
    //Canvas.DrawIcon(HUD_Backdrop, 0, 0);
    local AG_PlayerController PC;
    PC = AG_PlayerController(PlayerOwner);

    Canvas.Font = Font'AdventureGamePackages.Fonts.KnightsQuest';

    if(!PlayerOwner.IsDead() && !PlayerOwner.IsInState('Spectating'))
    {
        Canvas.SetPos(Canvas.ClipX * 0.45, Canvas.ClipY * 0.90);
        Canvas.DrawText("Crystals: " @AG_Weapon(PawnOwner.Weapon).AmmoCount);
        
        Canvas.SetPos(Canvas.ClipX * 0.55, Canvas.ClipY * 0.90);
        Canvas.DrawText("/ 3");

        Canvas.SetPos(Canvas.ClipX * 0.45, Canvas.ClipY * 0.95);
        Canvas.DrawText("Health: " @PlayerOwner.Pawn.Health);
    }
    
    //DrawBar("Health: " @PlayerOwner.Pawn.Health$"%", PlayerOwner.Pawn.Health, PlayerOwner.Pawn.HealthMax, 20, 20, 200, 80, 80);
    DrawBar_Level("Level: " @PC.Level, PC.Level, PC.MAX_LEVEL, 20, 20, 200, 80, 80);
    if(PC.Level != PC.MAX_LEVEL)
    {
        DrawBar_XP("XP: " @PC.XPGatheredForNextLevel$"/"$PC.XPRequiredForNextLevel, PC.XPGatheredForNextLevel, PC.XPRequiredForNextLevel, 20, 60, 80, 255, 80);
    }
}

defaultproperties
{
    PauseDelay=0.75
    MenuScrollOpen=SoundCue'AdventureGamePackages.SFX.MenuScrollOpen_Cue'
    MenuScrollClose=SoundCue'AdventureGamePackages.SFX.MenuScrollClose_Cue'
    //HUD_Backdrop=(Texture=Texture2D'UDKHUD.AG_Screen_Border')
}