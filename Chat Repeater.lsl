// size of the area : 48 x 48 = 2.304

list people_scan;
integer i;

vector REPEATER_POSITION;   // maybe :)

key person_id;
string person_name;
vector person_pos;
string person_language;

default
{
    state_entry()
    {
        REPEATER_POSITION = llGetPos();
    }

    touch_start(integer total_number)
    {
        people_scan = llGetAgentList(AGENT_LIST_PARCEL,[]);
        llSay(0, "\nScan for " + llList2String(llGetParcelDetails(llGetPos(),[PARCEL_DETAILS_NAME]),0));
        
        llSay(0, "Chat Repeater at " + (string)REPEATER_POSITION);
        
        for (i = 0; i < llGetListLength(people_scan); i++)
        {
            person_id = llList2Key(people_scan, i);
            person_name = llKey2Name(llList2String(people_scan, i));
            person_pos=llList2Vector(llGetObjectDetails(person_id,[OBJECT_POS]),0); 
            person_language = llGetAgentLanguage(person_id);
            
            llSay(0, person_name + " in position " + (string)person_pos + " speaks " 
            + person_language);            
        }
    }
}

