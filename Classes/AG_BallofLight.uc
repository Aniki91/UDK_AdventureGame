class AG_BallofLight extends AG_Actor
        placeable;

var PointLightComponent BallLight;
var Color c;
var AG_BallofLight BoL;
var float GoalDistance;
var Actor Goal;
var Pawn Enemy;

var float velRotation;

event PostBeginPlay()
{
BallLight.setLightProperties(1,c);
}

// Navigation Star: Function to calculate per frame the position and to move it towards
// the AG_NavGoal actor within the game.
function Tick(float DeltaTime)
{
    local AG_NavGoal NG;
    local vector NewLocation;
    
    local float deltaRotation;
   local Rotator newRotation;

    if(Goal == none)
    {
        foreach AllActors(class'AG_NavGoal', NG)
        {
            if(NG != none)
                Goal = NG;
        }
    }
    else if(Vsize(Location - Goal.Location) < GoalDistance)
    {
            NewLocation = Location;
            NewLocation += (Goal.Location * vect(1,1,1) - Location) * 0.01;
            SetLocation(NewLocation);

    }

// Rotates the actor for effect
   deltaRotation = velRotation * DeltaTime;

   newRotation = Rotation;

   newRotation.Pitch += deltaRotation;
   newRotation.Yaw  += deltaRotation;   
   newRotation.Roll  += deltaRotation;   

   SetRotation( newRotation );
}

defaultproperties()
{
    velRotation=5000

    GoalDistance=100000.0
    c=(R=255,G=165,B=0,A=0)

    Begin Object Class=StaticMeshComponent Name=Ball_Light
        StaticMesh=StaticMesh'AdventureGamePackages.Models.Nav_Star'
        Scale3D=(X=1.0,Y=1.0,Z=1.0)
    End Object
    Components.Add(Ball_Light)

    Begin Object Class=PointLightComponent Name=MyBallLight
        bEnabled=True
        Radius=256.000000
        Brightness=0.0
    End Object
    Components.Add(MyBallLight)
    BallLight=MyBallLight
}