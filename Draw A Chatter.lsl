/*
    script: Draw A Chatter
    author: TheResistor
*/

integer channel = 0;
float interval = 60;
list talker;
integer index;

// draw one
key draw(){
    
    integer listLength = llGetListLength(talker);
    integer winner = (integer)llFrand(listLength);
    key id = llList2Key(talker, winner);
    return id;
}

// check if an avi is on the sim
integer check(key id){

    if (llGetAgentSize(id)==ZERO_VECTOR)
    {
        // get it out of the list
        
        removeEntry(id);
        
        return -1;
    }
    else { return 0; }
}

// We need this , if the avi isn't on the sim anymore
removeEntry(key id) {
    
    integer ind = llListFindList(talker, [id]);
    
    if (index != -1)
    {
        talker = llDeleteSubList(talker, ind, ind);
    } 
}

default
{
    state_entry()
    {
        llListen(channel,"","","");
        llSetTimerEvent(interval);
    }

    listen(integer channel, string name, key id, string text)
    {
        // check the entrys to avoid redundant entries
        index = llListFindList(talker, [id]);
        
        if (index == -1)
        {
            talker += id;
        }
    }
    
    timer()
    {
        // draw and check if it is still on the sim
        key winner = NULL_KEY;
        
        // check if there is one to prevent the loop running forever
        integer listLength = llGetListLength(talker);
        
        if ( listLength > 0 )
        {
            while ( winner == NULL_KEY )
            {
                winner = draw();
            
                if (check(winner) != -1)
                {
                    llRegionSayTo(winner, 0, "Congratulations " + llGetUsername(winner));
                
                    // reset the list
                    talker = [];
                }
                else { winner = NULL_KEY; }                 
            }
        }       
    }
}
