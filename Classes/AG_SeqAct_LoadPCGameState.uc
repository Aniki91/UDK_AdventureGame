class AG_SeqAct_LoadPCGameState extends SequenceAction;

event Activated()
{
    local AG_PlayerController PC;
    
    PC = AG_PlayerController(GetWorldInfo().GetALocalPlayerController());
    
    PC.loadPCProgress();
}

DefaultProperties()
{
    ObjName="Load PC's State"
    ObjCategory="AG_PlayerController"
    VariableLinks.Empty
}