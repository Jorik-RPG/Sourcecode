local Frame = {
    name = "Frame";
	tag = "Frame";
	effects = {}
}

function Frame:render(e)
    e("ScreenGui", {}, {
        Label = self.Fabric.createElement("TextLabel", {
            Text = "Hello, world!",
            Size = UDim2.new(1, 0, 1, 0),
        })
    })
end

return Frame