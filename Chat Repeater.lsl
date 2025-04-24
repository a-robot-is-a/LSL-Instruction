function state_entry()
   ll.Say(0, "Hello, Avatar!")
end

function touch_start(total_number)
   ll.Say(0, "Touched.")
end

-- Simulate the state_entry event
state_entry()
