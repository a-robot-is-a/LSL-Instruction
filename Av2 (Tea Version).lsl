/*
script: av2 tea rug
author: TheResistor
version: 2025/03/08
*/

vector thelper = < 0.23, -0.28, 1.15 >;   // -y x z
rotation trot;

default
{
    link_message(integer sender_num, integer num, string str, key id)
    {
        llRequestPermissions(id, PERMISSION_TRIGGER_ANIMATION);
    }
    
    run_time_permissions(integer perm)
    {
        if (perm)
        {
            trot = < 0.0, 0.0, 180.0*PI , 1.0 >;
            
            llSetLinkPrimitiveParamsFast(3,[PRIM_POS_LOCAL,thelper, PRIM_ROT_LOCAL,trot]);
            
            llStopAnimation("sit");
            
            llStartAnimation("sit_ground");
        }
    }   
}
