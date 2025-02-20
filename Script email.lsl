integer SEND_MAIL=900513001;  // code 90-"E"-"M"-001

default {

    link_message(integer sender_num,integer num,string str,key id) {
        if (num==SEND_MAIL) {
            llEmail(llJsonGetValue(str,["address"]),
                    llJsonGetValue(str,["subject"]),
                    llJsonGetValue(str,["message"]));
        }
    }

    on_rez(integer start_param) {
        llResetScript();
    }
 
    changed(integer change) {
        if (change & (CHANGED_OWNER|CHANGED_INVENTORY)) {
            llResetScript();
        }
    }
}