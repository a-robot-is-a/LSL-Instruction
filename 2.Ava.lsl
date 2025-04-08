/*
script: RequestPermissions
version: 06.04.2025
author: TheResistor
*/

key av2;
vector pos = <-0.235, -0.4, 1.12>;
rotation rot = ZERO_ROTATION;
float Percentage = 0.6405144800344585;

default
{
    link_message(integer sender_num, integer num, string str, key id)
    {
        av2 = id;        
        llRequestPermissions(av2, PERMISSION_TRIGGER_ANIMATION);
    }
    
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION)
        {
            vector avSize = llGetAgentSize(av2);
            vector helpPos = < pos.x, pos.y, (avSize.z * Percentage) >;
            llSetLinkPrimitiveParamsFast(3,[PRIM_POS_LOCAL,helpPos, PRIM_ROT_LOCAL,rot]);           
            llStopAnimation("sit");            
            llStartAnimation("sit_ground");
        }
    }    
}
