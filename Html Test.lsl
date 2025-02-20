// 16:9

string EMAIL="the.resistor.sl@gmail.com";

integer SEND_MAIL=900513001;  // code 90-"E"-"M"-001
string url;

string htmlVisitorsList="
<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.1//EN' 'http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd'>
<html xmlns='http://www.w3.org/1999/xhtml' lang='en' xml:lang='en'>
<head>
    <meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />
    <title>Table of Visitors</title>
    
    <style type='text/css'>
        body {
            overflow-y: scroll;
            font-family: Arial, sans-serif;
            font-size: 24px;
            background-color: antiquewhite;
            margin: 0;
            padding: 55px;
            text-align: center;
        }

        h1 {
            color: #333;
            font-size: 48px;
            margin-bottom: 20px;
        }

        table {
            width: 80%;
            margin: 0 auto;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #4CAF50;
            color: white;
            text-transform: uppercase;
            letter-spacing: 0.1em;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        tfoot td {
            font-weight: bold;
            background-color: #f9f9f9;
        }

        tfoot td:first-child {
            text-align: right;
        }

    </style>
</head>
<body>
    <h1>Table of Visitors</h1>
    <table border='1'>
        <thead>
            <tr>
                <th>Name</th>
                <th>Username</th>
            </tr>
        </thead>
        <tfoot>
            <tr>
                <td colspan='2'>Total Visitors: @TOTAL_VISITORS@</td>
            </tr>
        </tfoot>
        <tbody>
            @TABLE@
        </tbody>
    </table>
</body>
</html>
";

string htmlVisitorsListTable="
            <tr>
                <td>@NAME@</td>
                <td>@USERNAME@</td>
            </tr>
";

show(string url) {
    llSetPrimMediaParams(4,[
                        PRIM_MEDIA_CURRENT_URL, url,
                        PRIM_MEDIA_HOME_URL, url,
                        PRIM_MEDIA_WIDTH_PIXELS, 1024,
                        PRIM_MEDIA_HEIGHT_PIXELS, 512,//653
                        PRIM_MEDIA_PERMS_INTERACT, PRIM_MEDIA_PERM_ANYONE,
                        PRIM_MEDIA_PERMS_CONTROL, PRIM_MEDIA_PERM_NONE,
                        PRIM_MEDIA_AUTO_PLAY, TRUE
                        ]);
}

sayUrl(string url) {
    list mailing;
    llOwnerSay(url);
    if (EMAIL!="") {
        mailing=["address",EMAIL,"subject","New url","message",url];
        llMessageLinked(LINK_THIS,SEND_MAIL,llList2Json(JSON_OBJECT,mailing),"");
    }
}

string tableVisitors(string html) {
    string table="";
    string row;
    list visitors;
    integer totalVisitors;
    key visitor;
    integer i;
    visitors=llGetAgentList(AGENT_LIST_REGION,[]);
    totalVisitors=llGetListLength(visitors);
    for (i=0;i<totalVisitors;i++) {
        visitor=llList2Key(visitors,i);
        row=htmlVisitorsListTable;
        row=llReplaceSubString(row,"@NAME@",llGetDisplayName(visitor),0);
        row=llReplaceSubString(row,"@USERNAME@",llGetUsername(visitor),0);
        table+=row;
    }
    html=llReplaceSubString(html,"@TOTAL_VISITORS@",(string)totalVisitors,0);
    html=llReplaceSubString(html,"@TABLE@",table,0);
    return html;
}

default
{
    state_entry()
    {
        llRequestURL();
    }

    http_request(key id, string method, string body)
    {
        if (method == URL_REQUEST_GRANTED)
        {
            url=body;
            sayUrl(url);
            show(url);
        }
        else if (method == URL_REQUEST_DENIED)
        {
            llOwnerSay("Unable to get URL!");
        }
        else if (method == "GET")
        {
            string html;
            html=tableVisitors(htmlVisitorsList);
            html=llReplaceSubString(html,"'","\"",0);
            llSetContentType(id,CONTENT_TYPE_XHTML);
            llHTTPResponse(id,200,html);
        }
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }

    changed(integer change)
    {
        if (change & CHANGED_REGION_START) {
            llResetScript();
        }
        if (change & (CHANGED_OWNER|CHANGED_INVENTORY)) {
            llResetScript();
        }
    }

}