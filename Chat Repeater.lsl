-- size of the area : 48 x 48 = 2.304

function state_entry()

end

function listen(channel, name, id, message)
    {
        ll.Say(0, "Empfangen: " + message);
    }
end


function touch_start(total_number)
   ll.Say(0, "Touched.")
end

-- Simulate the state_entry event
state_entry()
