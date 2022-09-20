
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
		if collision.touching_ground then
			for _,coll in pairs(collision.collisions) do
				if coll.type == "node" and coll.axis == "y" then
					local pos = coll.node_pos
					pos.y = pos.y + 1
					minetest.set_node(pos, {name="floppy:floppy_red_lying"})
					self.object:remove()
				end
			end
		else 
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
	end
})

minetest.register_node("floppy:floppy_red_lying", {
	description = "Red Floppy (Lying)",
	tiles = { "floppy_red.png" },
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.4375, 0.4375, -0.4375, 0.4375}
		}
	},
	drop = "floppy:floppy_red",
	groups = { snappy=3, cracky=3, oddly_breakable_by_hand=3, crumbly=3, not_in_creative_inventory=1 }
})
