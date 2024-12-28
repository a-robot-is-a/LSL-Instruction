/*
    This script reads station URLs from a notecard,
    makes a menu and let the user enter them in the
    land settings.

    author: TheResistor
    date: 27.12.2024
*/

string card;
integer line;

list stationName = [];
list stationURL = [];
integer i;

integer currentPage;

key id;
integer menuChannel;
integer handle;

list orderButtons(list buttons)
{
    return llList2List(buttons, -3, -1) + llList2List(buttons, -6, -4)
         + llList2List(buttons, -9, -7) + llList2List(buttons, -12, -10);
}

list buttons(list stationName)
{
    integer totalButtons = llGetListLength(stationName); 
    list sublist;
    integer index;
    
    if (totalButtons <= 12)
    {
        // we need only one page
        sublist = stationName;
    }
    else
    {
        if (currentPage == 0)
        {
            // we add the 'Next Page' button
            sublist = llList2List(stationName, index, index + 10);
            sublist += ["Next Page"];
        }
        else    // all following pages need at least the Previous buttons
        {
            index = currentPage * 11;
            // get the rest of the list length
            if (totalButtons - (index + 1) <= 11)
            {
                // we add the 'Previous Page' button
                sublist = llList2List(stationName, index, index + 10);
                sublist += ["Previous Page"];
            }
            else    // we need the Next Page Button also
            {
                sublist = llList2List(stationName, index, index + 9);
                sublist += ["Next Page"];
                sublist += ["Previous Page"];
            }
        }
    }
    
    // throw it in the world
    return orderButtons(sublist);
}

menu(key id)
{
    list buttons = buttons(stationName); 
    
    llDialog(id, "Choose a station:", buttons, menuChannel);
    
    llSetTimerEvent(30.0);
}

default
{
    state_entry()
    {
        // Lets read the notecard first
        if (llGetInventoryNumber(INVENTORY_NOTECARD) == 0)
        {
            llOwnerSay("Please drop a notecard with station URLs");
        }
        else
        {
            card = llGetInventoryName(INVENTORY_NOTECARD, 0);
            llGetNotecardLine(card, line = 0);
        }
    }
    
    dataserver(key queryID, string data)
    {
        // Note, we don't use queryID
        if (data != EOF)
        {
            i = llSubStringIndex(data, "=");
            if (i >= 0)
            {
                stationName += [llGetSubString(data, 0, i - 1)];
                stationURL += [llDeleteSubString(data, 0, i)];
            }
                
            llGetNotecardLine(card, ++line);
        }
    }

    touch_start(integer total_number)
    {
        id = llDetectedKey(0);

        llListenRemove(handle);

        menuChannel=0x80000000 | (integer)("0x"+llGetSubString((string)llGetKey(),-8,-1));
        handle = llListen(menuChannel, "", id, "");
        
        menu(id);
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message == "Next Page")
        {
            currentPage++;
            
            menu(id);
        }
        else if (message == "Previous Page")
        {
            currentPage--;
            
            menu(id);
        }
        else
        {
            integer index = llListFindList(stationName, [message]);
            if (index < 0) return;
            llSetParcelMusicURL(llList2String(stationURL, index));
            llSetText((llList2String(stationName, index)), < 1.0,0.0,0.0 >, 1.0);
            llListenRemove(handle);
            llSetTimerEvent(0.0);
        }
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
