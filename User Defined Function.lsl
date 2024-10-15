string get_name(key uuid)
{
    string text = "Hello " +  llKey2Name(uuid);
     
    return text;
}

default
{
    touch_start(integer total_number)
    {
        key toucherId = llDetectedKey(0);
        
        llSay(0, get_name(toucherId));
    }
}
