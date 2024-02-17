	game:GetService("StarterGui"):SetCore("SendNotification",{
		Title = "Discontinued (Leave the game now!)",
		Text = "'Meow' -Hosvile",
		Duration = 2.5
	})
	
	task.wait(2.5)
	
	game:Shutdown()
