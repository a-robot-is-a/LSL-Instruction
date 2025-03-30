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
list sitter = [];
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
            if (numPrim == 1) { sitter = []; llResetOtherScript("2.Ava (School Version)"); }
            
            // state 1 start sit logic 
            if (numPrim > 1)
            {
                // lets make a list chack
                if (llGetListLength(sitter) == 0)
                {
                    av = llGetLinkKey(numPrim);
                    // store the first sitter
                    sitter = (sitter=[]) + sitter + av;
                    llOwnerSay(llList2String(sitter, 0));
                    llRequestPermissions(av, PERMISSION_TRIGGER_ANIMATION);
                }
                else if (llGetListLength(sitter) == 1)
                {
                    av2 = llGetLinkKey(numPrim);
                    // store the second sitter , now all 2 are on the list
                    sitter = (sitter=[]) + sitter + av2;
                    llOwnerSay(llList2String(sitter, 1) + llList2String(sitter, 1));
                    llSetLinkPrimitiveParamsFast(2,[PRIM_POS_LOCAL,helpPos, PRIM_ROT_LOCAL,rot]);      
                                 
                    // send id to permission request script
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
            pos.z = (newPos.z / 1.4);
            helpPos = < 0.0, newPos.y, (newPos.z / 1.4) >;
            llSetLinkPrimitiveParamsFast(2,[PRIM_POS_LOCAL,pos, PRIM_ROT_LOCAL,rot]);
            
            llStopAnimation("sit");
            llStartAnimation("sit_ground");
        }
    }
}
