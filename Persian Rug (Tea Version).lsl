/*************************************
script: Persion Rug (Tea Version)    *
author: TheResistor                  *
version: 2025-03-08                  *
**************************************/

vector pos = < 0.23, 0.0, 1.15 >;   // -y x z
rotation rot;
vector helper = < 0.23, 0.28, 1.15 >;   // -y x z
key av = NULL_KEY;
key av2;
integer numPrim;
/******Menu********/
integer channelDialog = -99;
integer listenDialog;
key detect;

default
{
    state_entry()
    {
        rot = < 0.0, 0.0, 180.0*PI , 1.0 >;        
        llSitTarget(pos, rot);        
    }
    
    changed(integer change)
    {        
        if (change & CHANGED_LINK)
        {
            numPrim = llGetNumberOfPrims();
            
            if (numPrim > 1)
            {                
                if (numPrim == 2)
                {
                    av = llGetLinkKey(numPrim);

                    llRequestPermissions(av, PERMISSION_TRIGGER_ANIMATION);
                }
                else if (numPrim == 3) //set it back to 3
                {
                    // send id to request script
                    av2 = llGetLinkKey(numPrim);
                    llMessageLinked(LINK_THIS, 0, "", av2);
                    
                    llSetLinkPrimitiveParamsFast(2,[PRIM_POS_LOCAL,helper, PRIM_ROT_LOCAL,rot]);
                }
            }
            else { llResetScript(); llResetOtherScript("Ava2 (Tea Version)");}
        }
    }

    run_time_permissions(integer perm)
    {
        if (PERMISSION_TRIGGER_ANIMATION & perm)
        {
            if (numPrim == 2)
            {
                llSetLinkPrimitiveParamsFast(2,[PRIM_POS_LOCAL,pos, PRIM_ROT_LOCAL,rot]);
            }
            
            llStopAnimation("sit");            
            llStartAnimation("sit_ground");
        }
    }
    
    touch_start(integer num_detected)
    {
        detect = llDetectedKey(0);
        if ( av == detect || av2 == detect)
            {
                llListenRemove(listenDialog);
                listenDialog = llListen(channelDialog, "", detect, "");
                llDialog(detect, "\nTea?", ["Yes", "No"] , channelDialog);
                llSetTimerEvent(60.0);
            }
    }
    
    listen(integer chan, string name, key id, string msg)
    {
        if (msg == "Yes")
            {
                //string uuid = (string)av;
                llRezObjectWithParams("Hot Tea (RHAND)rez param", [REZ_PARAM_STRING, (string)detect]);

                llSetTimerEvent(0.1);
            }
        else
            {
                // The user did not click "Yes" ...
                // Make the timer fire immediately, to do clean-up actions 
                llSetTimerEvent(0.1);
            }
    }
    
    timer()
    {
        llListenRemove(listenDialog);
        llSetTimerEvent(0.0);
    }        
}