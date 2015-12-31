class AdventureGame_Info extends UTDeathMatch;

defaultproperties
{
    bDelayedStart=false

    DefaultInventory(0)=class'AG_Staff'

    PlayerControllerClass=class'AdventureGame.AG_PlayerController'

    DefaultPawnClass=class'AdventureGame.AG_Pawn'
    
    HUDType=class'AdventureGame.AG_HUD'
}