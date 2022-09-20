
local throw = function(itemstack, user, pointed_thing)
		itemstack:take_item()
		local pos = user:getpos()
		local dir = user:get_look_dir()
		local yaw = user:get_look_yaw()
		if pos and dir then
			pos.y = pos.y + 1.5
			local obj = minetest.add_entity(pos, "floppy:floppy_red")
			if obj then
				obj:setvelocity({x=dir.x * 25, y=dir.y * 25, z=dir.z * 25})
				obj:setacceleration({x=dir.x * -3, y=-25, z=dir.z * -3})
			end
		end
		return itemstack
	end

minetest.register_craftitem("floppy:floppy_red", {
	description = "Red Floppy",
	stack_max = 64,
	inventory_image = "floppy_red.png",
	on_place = throw,
	on_secondary_use = throw
})

minetest.register_entity("floppy:floppy_red", {
	visual = "item",
	visual_size = {x=1, y=1, z=1.5},
	textures = {'floppy:floppy_red'},
	physical = true,
	on_step = function(self, dtime, collision)
		local pos = self.object:getpos()
		local node = minetest.get_node(pos)
	
		local rot = self.object:get_rotation()
		if rot then
			--rot.x = math.pi/2
			rot.x = rot.x + 0.2
			rot.y = rot.y + 0.2
			self.object:set_rotation(rot)
		end
	end
})
