return {
	name = "Door";
	tag = "Door";

	units = {
		Replicated = {};
	};

	defaults = {
        transparency = 0;
        open = false;
        running = false;
	};

	onInitialize = function(self)

	end;

	setCFrame = function(self, _player, cf)
        self:addLayer(self, {
            CFrame = cf
        })
	end;

	onUpdated = function(self)
		print(self.ref.Name, "updated")
	end;
}