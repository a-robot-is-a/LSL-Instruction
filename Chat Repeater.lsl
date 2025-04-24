-- size of the area : 48 x 48 = 2.304

peopleScan = {}

function state_entry() end

function touch_start(total_number)
        peopleScan = ll.GetAgentList(AGENT_LIST_PARCEL,{})
        ll.Say(0, ll.List2String(ll.GetParcelDetails(ll.GetPos(),{PARCEL_DETAILS_NAME}),0))

        for i = 1, #peopleScan, 1 do

            ll.Say(0, ll.Key2Name(ll.List2String(peopleScan, i)))        
        end 
end

-- Simulate the state_entry event
state_entry()
