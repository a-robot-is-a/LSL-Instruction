/*
script: Persion Rug (School Version)
author: TheResistor
version: 30.03.2025

        vector rezPosition = llGetPos() + <1, 0, 0>; // Position relativ zum rezzer
        rotation rezRotation = llGetRot(); // Rotation des Objekts
        llRezObject("Objektname", rezPosition, ZERO_VECTOR, rezRotation, 0);

*/

vector pos = ZERO_VECTOR;
rotation rot = ZERO_ROTATION;

key av = NULL_KEY;
key av2 = NULL_KEY;
integer numPrim;
integer bool = FALSE;
vector helpPos = ZERO_VECTOR;

default
{
    state_entry()
    {
        pos.z = 0.8;
        llSitTarget(pos, rot);
    }
    
    changed(integer change)
    {        
        if (change & CHANGED_LINK)
        {
            numPrim = llGetNumberOfPrims();
            
            // state 0 do some cleanup
            if (numPrim == 1) { bool = FALSE; llResetOtherScript("2.Ava (School Version)"); }
            
            // state 1 start sit logic 
            if (numPrim > 1)
            {                
                if (numPrim == 2)   // here is the get back from 3 problem
                {   
                    if (bool == FALSE) //First time , not sitting
                    {
                        av = llGetLinkKey(numPrim);
                        llRequestPermissions(av, PERMISSION_TRIGGER_ANIMATION);
                    }
                }
                else if (numPrim == 3)
                {
                    llSetLinkPrimitiveParamsFast(2,[PRIM_POS_LOCAL,helpPos, PRIM_ROT_LOCAL,rot]);                    
                    // send id to request script
                    av2 = llGetLinkKey(numPrim);
                    llMessageLinked(LINK_THIS, 0, "", av2);                    
                }
            }
        }
    }

    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION)
        {  
            vector newPos = llGetAgentSize(av);
            bool = TRUE;
            pos.z = (newPos.z / 1.4);
            helpPos = < 0.0, newPos.y, (newPos.z / 1.4) >;
            llSetLinkPrimitiveParamsFast(2,[PRIM_POS_LOCAL,pos, PRIM_ROT_LOCAL,rot]);
            
            llStopAnimation("sit");
            llStartAnimation("sit_ground");
        }
    }
}
