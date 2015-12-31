class AG_SeqAct_SavePCGameState extends SequenceAction;

event Activated()
{
    local AG_PlayerController PC;
    
    PC = AG_PlayerController(GetWorldInfo().GetALocalPlayerController());
    
    PC.savePCProgress();
}

DefaultProperties()
{
    ObjName="Save PC's State"
    ObjCategory="AG_PlayerController"
    VariableLinks.Empty
}