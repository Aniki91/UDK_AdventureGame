class AG_NavGoal extends AG_Actor
        placeable;
        
defaultproperties
{
    bHidden=True

    Begin Object Class=StaticMeshComponent Name=AG_NavGoal
        StaticMesh=StaticMesh'AdventureGamePackages.Models.Nav_Goal'
        Scale3D=(X=1.0,Y=1.0,Z=1.0)
    End Object
    Components.Add(AG_NavGoal)

    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
        bEnabled=True
    End Object
    Components.Add(MyLightEnvironment)
}