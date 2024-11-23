/*
    script  Test for the new sync function
    author  TheResistor Resident
*/

string NOTECARD_NAME = "notecard";
key READ_KEY = NULL_KEY;

default
{
    touch_start(integer total_number)
    {
        READ_KEY = llGetNumberOfNotecardLines(NOTECARD_NAME);
    }
    
    dataserver(key request, string data)
    {
        if (request == READ_KEY)
        {
            integer count = (integer)data;
            integer index;            
            string line;
            
            while ( line != NAK && line != EOF) {
                
                for (index = 0; index < (count+1); ++index)
                {
                    line = llGetNotecardLineSync(NOTECARD_NAME, index);                
                
                    llOwnerSay(line);
                } 
            }
        }
    }
}