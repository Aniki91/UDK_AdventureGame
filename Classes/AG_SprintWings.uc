class AG_SprintWings extends AG_Actor
        placeable;

var StaticMeshComponent SprintWings_Mesh;

defaultproperties()
{
     Begin Object Class=StaticMeshComponent Name=SprintWings
        StaticMesh=StaticMesh'AdventureGamePackages.Models.SprintWings_Ability'
        Scale3D=(X=5.0,Y=5.0,Z=5.0)
        CollideActors=true
	BlockActors=true
    End Object
    Components.Add(SprintWings)
    SprintWings_Mesh=SprintWings
    CollisionComponent=SprintWings
}