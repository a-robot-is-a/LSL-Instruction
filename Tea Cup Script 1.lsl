default
{
    on_rez(integer param)
    {
        llResetScript();
    }

    state_entry()
    {
        string s = llGetStartString();
        key av = (key)s;
        llRequestPermissions( av, PERMISSION_ATTACH | PERMISSION_TRIGGER_ANIMATION);
    }    

    run_time_permissions( integer vBitPermissions )
    {
        if( vBitPermissions)
            { 
                if (llGetAttached())
                    {
                        llDetachFromAvatar();
                    }
                else
                    {
                        llAttachToAvatarTemp( ATTACH_RHAND );
                        llStartAnimation("hold_tea_RHAND");
                        llSetTimerEvent(30.0);
                    }
            }
        else
            {
                llDie();
            }
    }

    timer()
    {
        llDetachFromAvatar( );
    }
}