// size of the area : 48 x 48 = 2.304

/*  Script gets people in the area and repeats
    the chat direct , except to the writer.
*/

list people_scan;
integer i;

key person_id;
string person_name;
string person_language;

integer listen_handle;
integer repeat_channel = 0;
float timer_interval = 60;

default
{
    state_entry()
    {
        listen_handle = llListen(0, "", "", "");
        llSetTimerEvent( timer_interval );
    }
    
    timer()
    {
        people_scan = llGetAgentList(AGENT_LIST_PARCEL,[]);       
    }

    listen( integer channel, string name, key id, string message )
    {
        for (i = 0; i < llGetListLength(people_scan); i++)
        {
            person_id = llList2Key(people_scan, i);
            if (person_id != id)
            {            
                llRegionSayTo( person_id, repeat_channel, message );             
            } 
        }
    }
}
