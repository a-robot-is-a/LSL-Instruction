showTheList(list result){
    
    integer i;
    integer value;
    string type;
    // get the list length
    integer length = llGetListLength(result);
    
   for(i = 0; i < length; i++)
   {
       value = llList2Integer(result, i);
       if(value > 0){
           
           type = llList2String(result, i-1);           
           llOwnerSay(type + ": " + (string)value);
        }
    }  
}


count(){
    // reset the list
    list stridedTYPES = 
    ["Texture",0, "Sound",0, "",0, "Landmark",0, "",0, "Clothing",0, "Object",0, "Notecard",0, "",0, "",0,
    "Script",0, "",0, "",0, "Bodypart",0, "",0, "",0, "",0, "",0, "",0, "",0, "Animation",0, "Gesture",0];

    integer totalItems;
    integer i;
    string itemName;
    integer index;
    
    integer currentValue;
    integer newValue;
    
    totalItems=llGetInventoryNumber(INVENTORY_ALL);
    
    for (i = 0; i < totalItems; i++)
    {
        itemName=llGetInventoryName(INVENTORY_ALL, i);
        
        index=llGetInventoryType(itemName);
        
        // add one to the index        
        index += index+1;
        
        // get the value at the index
        currentValue = llList2Integer(stridedTYPES, index);
        
        // add one 
        newValue = currentValue + 1;
        
        // update the list value 
        stridedTYPES = llListReplaceList(stridedTYPES, [newValue], index, index);
    }

        // call showTheList()
        showTheList(stridedTYPES);
}


default
{
    touch_start(integer total_number)
    {
        count();
    }
}
