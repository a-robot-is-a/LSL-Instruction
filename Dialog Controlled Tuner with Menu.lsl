integer menuChannel;
integer handle;

string card;
integer line;
key query;

list stationnames = [];
list stationlist = [];

// make the menu buttons
list makeButtons(list stationNames) {
    
    list orderedButtons;
    list sublist;
    integer i;
    integer pageCounter;

    // check the input
    if (llGetListLength(stationNames) > 12)
    {
        // make a sublist with 10 stations
        for(i = 0; i < 10; i++)
        {
            sublist += llList2List(stationNames, i, i);
        }
        // check if we are on page 0
        if (pageCounter == 0)
        {
            // add station 11
            sublist += llList2List(stationNames, 10, 10);
            // add Next button
            sublist = sublist + "Next Page";
            // increase the page counter
            pageCounter++;
        }
        else {
            // add Next and Back button
            sublist = sublist + "Next Page";
            sublist = sublist + "Page Back";
            pageCounter++;
        }
    }
    else {
        // if there are only stations for one page
        sublist = stationNames;
    }

    // anyway, order them
    orderedButtons = llList2List(sublist,-3,-1)+llList2List(sublist,-6,-4)+llList2List(sublist,-9,-7)+llList2List(sublist,-12,-10);
    
    // throw the result in the world
    return orderedButtons;
}

menu(key id)
{

    list buttons = makeButtons(stationnames);    

    llDialog(id, "Choose a station:", buttons, menuChannel);
}

default
{
    state_entry()
    {
        if (llGetInventoryNumber(INVENTORY_NOTECARD) == 0)
        {
            llOwnerSay("Please drop a notecard with station URLs");
        }
        else
        {
            card = llGetInventoryName(INVENTORY_NOTECARD, 0);
            query = llGetNotecardLine(card, line = 0);
        }
    }
    
    dataserver(key id, string data)
    {
        if (query != id) return;
        if (data == EOF) return;
        integer i = llSubStringIndex(data, "=");
        if (i >= 0) {
            stationnames += [llGetSubString(data, 0, i - 1)];
            stationlist += [llDeleteSubString(data, 0, i)];
        }
        query = llGetNotecardLine(card, ++line);
    }

    touch_start(integer total_number)
    {
        key id = llDetectedKey(0);

        llListenRemove(handle);

        menuChannel=0x80000000 | (integer)("0x"+llGetSubString((string)llGetKey(),-8,-1));
        handle = llListen(menuChannel, "", id, "");
        
        menu(id);
        llSetTimerEvent(30.0);
    }
     
    listen(integer channel, string name, key id, string message)
    {
        integer index = llListFindList(stationnames, [message]);
        if (index < 0) return;
        //llSetParcelMusicURL(llList2String(stationlist, index));
        llSetText((llList2String(stationnames, index)), < 1.0,0.0,0.0 >, 1.0);
        llListenRemove(handle);
        llSetTimerEvent(0.0);
    }        
    
    timer()
    {
        llListenRemove(handle);
        llSetTimerEvent(0.0);
    }
    
    // let the user change the notecard
    changed(integer change)
    {
        if(change & (CHANGED_OWNER | CHANGED_INVENTORY))
        {    
            llResetScript();
        }
    }
}
