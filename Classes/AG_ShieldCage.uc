class AG_ShieldCage extends AG_Actor
        placeable;

var float velRotation;
var PointLightComponent ShieldCageLight;
var StaticMeshComponent ShieldCage_Mesh;
//var Color c;
var AG_ShieldCage SC;

event PostBeginPlay()
{
    // Shield Cage Light properties, for a dynamic light component that spawns wit it.
    //ShieldCageLight.setLightProperties(1,c);
}

// Shield cage to rotate per tick.
function Tick(float DeltaTime)
{
   local float deltaRotation;
   local Rotator newRotation;
   
   deltaRotation = velRotation * DeltaTime;

   newRotation = Rotation;
   newRotation.Yaw  += deltaRotation;

   SetRotation( newRotation );
}

defaultproperties()
{
    bWorldGeometry=True
    velRotation=7500

    //c=(R=0,G=255,B=127,A=0)

    Begin Object Class=StaticMeshComponent Name=Shield_Cage
        StaticMesh=StaticMesh'AdventureGamePackages.Models.Pawn_Shield'
        Scale3D=(X=2.0,Y=2.0,Z=3.0)
        CollideActors=true
	BlockActors=true
    End Object
    Components.Add(Shield_Cage)
    ShieldCage_Mesh=Shield_Cage
    CollisionComponent=Shield_Cage

    /*Begin Object Class=PointLightComponent Name=My_Shield_Cage
        bEnabled=True
        Radius=384.000000
        Brightness=0.25
    End Object
    Components.Add(My_Shield_Cage)
    ShieldCageLight=My_Shield_Cage*/
}