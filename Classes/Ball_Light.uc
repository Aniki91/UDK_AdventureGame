class Ball_Light extends AG_Actor
        placeable;

var PointLightComponent BallLight;
var Color c;

event PostBeginPlay()
{
BallLight.setLightProperties(10,c);
}

defaultproperties()
{
    c=(R=0,G=90,B=165,A=0)

    Begin Object Class=StaticMeshComponent Name=Ball_Light
        StaticMesh=StaticMesh'AdventureGamePackages.Models.Staff_Orb'
        Scale3D=(X=1.0,Y=1.0,Z=1.0)
    End Object
    Components.Add(Ball_Light)
    
    Begin Object Class=PointLightComponent Name=MyBallLight
        bEnabled=True
        Radius=256.000000
        Brightness=0.5
    End Object
    Components.Add(MyBallLight)
    BallLight=MyBallLight
}