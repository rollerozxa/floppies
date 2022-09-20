
local colours = {
	red = 'Red',
	green = 'Green',
	blue = 'Blue'
}

for colour, colourdesc in pairs(colours) do

local throw = function(itemstack, user, pointed_thing)
	itemstack:take_item()
	local pos = user:getpos()
	local dir = user:get_look_dir()
	local yaw = user:get_look_yaw()
	if pos and dir then
		pos.y = pos.y + 1.5
		local obj = minetest.add_entity(pos, "floppy:floppy_"..colour)
		if obj then
			obj:setvelocity({x=dir.x * 25, y=dir.y * 25, z=dir.z * 25})
			obj:setacceleration({x=dir.x * -3, y=-25, z=dir.z * -3})
		end
	end
	return itemstack
end

minetest.register_craftitem("floppy:floppy_"..colour, {
	description = colourdesc.." Floppy",
	inventory_image = "floppy_"..colour..".png",
	on_place = throw,
	on_secondary_use = throw
})

minetest.register_entity("floppy:floppy_"..colour, {
	visual = "item",
	visual_size = {x=1, y=1, z=1.5},
	textures = {'floppy:floppy_'..colour},
	physical = true,
	on_step = function(self, dtime, collision)
		if collision.touching_ground then
			for _,coll in pairs(collision.collisions) do
				if coll.type == "node" and coll.axis == "y" then
					local pos = coll.node_pos
					pos.y = pos.y + 1
					minetest.set_node(pos, {name="floppy:floppy_"..colour.."_lying"})
					self.object:remove()
				end
			end
		else
			local pos = self.object:getpos()
			local node = minetest.get_node(pos)

			local rot = self.object:get_rotation()
			if rot then
				rot.x = rot.x + 0.2
				rot.y = rot.y + 0.2
				self.object:set_rotation(rot)
			end
		end
	end
})

minetest.register_node("floppy:floppy_"..colour.."_lying", {
	description = colourdesc.." Floppy (Lying)",
	tiles = { "floppy_"..colour..".png", "floppy_"..colour..".png", "floppy_side.png" },
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.4375, 0.3125, -0.375, 0.3125},
			{0.375, -0.5, -0.4375, 0.4375, -0.375, 0.1875},
			{0.3125, -0.5, -0.4375, 0.375, -0.375, 0.25},
			{-0.4375, -0.5, 0.375, 0.1875, -0.375, 0.4375},
			{-0.4375, -0.5, 0.3125, 0.25, -0.375, 0.375},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.4375, 0.4375, -0.375, 0.4375}
		}
	},
	drop = "floppy:floppy_"..colour,
	groups = { snappy=3, cracky=3, oddly_breakable_by_hand=3, crumbly=3, not_in_creative_inventory=1 }
})

if minetest.get_modpath("default") then
	local wool = "wool:"..colour
	minetest.register_craft({
		output = "floppy:floppy_"..colour,
		recipe = {
			{wool, "default:steel_ingot", wool},
			{wool, wool, wool},
			{wool, "default:paper", wool},
		}
	})
end

end
