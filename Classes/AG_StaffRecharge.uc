class AG_StaffRecharge extends AG_Actor
        HideCategories(Attachment, Physics, Debug, Object)
        placeable;
        
        var() ParticleSystemComponent Template;
        var SoundCue PickupSound_Chatter;
        var SoundCue PickupSound_Recharge;

        // Event to pickup the Crystals if you are the Player and are holding the AG_Weapon actor class.
        event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
        {
            local AG_PlayerController PC;
            
            if (Pawn(Other) != none && AG_Weapon(Pawn(Other).Weapon) != none)
            {
                AG_Weapon(Pawn(Other).Weapon).RechargeWeapon();
                PlaySound(PickupSound_Recharge);
                PlaySound(PickupSound_Chatter);
                Destroy();
            }
            
            foreach LocalPlayerControllers(class'AG_PlayerController',PC)
            {
                PC.GiveXP(250);
            }
        }

defaultproperties
{
        bCollideActors=true
        bStatic=false
        PickupSound_Chatter=SoundCue'KismetGame_Assets.Sounds.Jazz_Chatter_Pickup_Cue'
        PickupSound_Recharge=SoundCue'A_Pickups.Ammo.Cue.A_Pickup_Ammo_Shock_Cue'

        Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
                bEnabled=true
        End Object
                Components.Add(MyLightEnvironment)
                
        Begin Object Class=StaticMeshComponent Name=StaffRecharge
                StaticMesh=StaticMesh'AdventureGamePackages.Models.Staff_Recharge_Pickup'
                LightEnvironment=MyLightEnvironment
                Scale3D=(X=2.25,Y=2.25,Z=2.25)
        End Object
                Components.Add(StaffRecharge)

        Begin Object Class=CylinderComponent Name=CollisionCylinder
                CollisionRadius=16.0
                CollisionHeight=16.0
                BlockNonZeroExtent=true
                BlockZeroExtent=true
                BlockActors=true
                CollideActors=true
        End Object
                CollisionComponent=CollisionCylinder
                Components.Add(CollisionCylinder)

        Begin Object Class=ParticleSystemComponent Name=ParticleSystemComponent0
                Template=ParticleSystem'CTF_Flag_IronGuard.Effects.P_CTF_Flag_IronGuard_Idle_Blue'
                Scale3D=(X=5.0,Y=5.0,Z=5.0)
        End Object
                Template=ParticleSystemComponent0
                Components.Add(ParticleSystemComponent0)
}