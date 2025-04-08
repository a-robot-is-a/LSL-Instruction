/*
script: Persion Rug (School Version)
author: TheResistor
version: 06.04.2025

Prozentsatz = Prozentwert / Grundwert = 1.12 / 1.578921 = 0.7093451793978293
*/

vector pos = <-0.235, 0.4, 1.12>;
rotation rot = ZERO_ROTATION;

key av = NULL_KEY;
key av2 = NULL_KEY;
integer numPrim;
list sitter = [NULL_KEY,NULL_KEY];
float Percentage = 0.7093451793978293;

key rezzee_key;

default
{
    state_entry()
    {
        llSitTarget(pos, rot);
    }
    
    changed(integer change)
    {        
        if (change & CHANGED_LINK)
        {
            numPrim = llGetNumberOfPrims();
            
            // state 0
            if (numPrim == 1)
            {
                sitter = [NULL_KEY,NULL_KEY];
                llResetOtherScript("2.Ava");
                if (rezzee_key != NULL_KEY)
                {
                    llSay(91, "Poof");
                }   
            }

            // state 1            
            if (numPrim > 1)
            {
                if ( llList2Key(sitter,0) == NULL_KEY && llList2Key(sitter,1) == NULL_KEY )
                    {
                        av = llGetLinkKey(numPrim);
                        sitter = llListReplaceList((sitter = []) + sitter, [av], 0, 0);
                        llRequestPermissions(av, PERMISSION_TRIGGER_ANIMATION); 
                    }
                else if ( llList2Key(sitter,0) != NULL_KEY && llList2Key(sitter,1) == NULL_KEY )
                    {
                        av2 = llGetLinkKey(numPrim);
                        sitter = llListReplaceList((sitter = []) + sitter, [av2], 1, 1);
                        //llSetLinkPrimitiveParamsFast(2,[PRIM_POS_LOCAL,helpPos, PRIM_ROT_LOCAL,rot]);
                        llMessageLinked(LINK_THIS, 0, "", av2);                        
                    }
                else if ( llList2Key(sitter,0) == NULL_KEY && llList2Key(sitter,1) != NULL_KEY )
                    {
                        av = llGetLinkKey(numPrim);
                        sitter = llListReplaceList((sitter = []) + sitter, [av], 0, 0);
                        llRequestPermissions(av, PERMISSION_TRIGGER_ANIMATION);                        
                    }
                    
                    // state 2
                else if ( llList2Key(sitter,0) != NULL_KEY && llList2Key(sitter,1) != NULL_KEY )
                    {
                        if (  llGetLinkKey(numPrim) == llList2Key(sitter,0) )
                            { sitter = llListReplaceList((sitter = []) + sitter, [NULL_KEY], 1, 1); }                           
                        else if (  llGetLinkKey(numPrim) == llList2Key(sitter,1) )
                            { sitter = llListReplaceList((sitter = []) + sitter, [NULL_KEY], 0, 0); }                
                    }                    
                }                            
        }
    }

    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION)
        {  
            vector avSize = llGetAgentSize(av);
            vector helpPos = < pos.x, pos.y, (avSize.z * Percentage) >;
            //llRezObject("Cushion", llGetPos() + <0.0,0.0,0.06>, ZERO_VECTOR, ZERO_ROTATION, 0);
            
            if ( numPrim == 2)
                {
                    llSetLinkPrimitiveParamsFast(2,[PRIM_POS_LOCAL,helpPos, PRIM_ROT_LOCAL,rot]);
                }
            else if (numPrim == 3)
                {
                    llSetLinkPrimitiveParamsFast(3,[PRIM_POS_LOCAL,helpPos, PRIM_ROT_LOCAL,rot]);
                }
            
            llStopAnimation("sit");
            llStartAnimation("sit_ground");
        }
    }
    
    object_rez(key id)
    {
        rezzee_key = id;
    }
}