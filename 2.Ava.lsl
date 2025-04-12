/*
script: RequestPermissions
version: 12.04.2025
author: TheResistor
*/

key av2;
vector pos = <-0.235, -0.3, 1.104>;
rotation rot = ZERO_ROTATION;

float offset(float avSizeZ){
   float offs = 1.066 + 0.1470173019125983 * (avSizeZ - 1.3907965421676636);
   return offs;
}

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
            vector helpPos = < pos.x, pos.y, offset(avSize.z) >;
            llSetLinkPrimitiveParamsFast(3,[PRIM_POS_LOCAL,helpPos, PRIM_ROT_LOCAL,rot]);           
            llStopAnimation("sit");            
            llStartAnimation("sit_ground");
        }
    }    
}
