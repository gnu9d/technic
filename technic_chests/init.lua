
local S = rawget(_G, "intllib") and intllib.Getter() or function(s) return s end
--local S = minetest.get_translator("technic_chests")

local modpath = minetest.get_modpath("technic_chests")

technic = rawget(_G, "technic") or {}
technic.chests = {}

technic.chests.colors = {
	{"black", S("Black")},
	{"blue", S("Blue")},
	{"brown", S("Brown")},
	{"cyan", S("Cyan")},
	{"dark_green", S("Dark Green")},
	{"dark_grey", S("Dark Grey")},
	{"green", S("Green")},
	{"grey", S("Grey")},
	{"magenta", S("Magenta")},
	{"orange", S("Orange")},
	{"pink", S("Pink")},
	{"red", S("Red")},
	{"violet", S("Violet")},
	{"white", S("White")},
	{"yellow", S("Yellow")},
}

function technic.chests.change_allowed(pos, player, owned, protected)
	if owned then
		if minetest.is_player(player) and not default.can_interact_with_node(player, pos) then
			return false
		end
	elseif protected then
		if minetest.is_protected(pos, player:get_player_name()) then
			return false
		end
	end
	return true
end

if minetest.get_modpath("digilines") then
	dofile(modpath.."/digilines.lua")
end

dofile(modpath.."/formspec.lua")
dofile(modpath.."/inventory.lua")
dofile(modpath.."/register.lua")
dofile(modpath.."/chests.lua")

-- Undo all of the locked wooden chest recipes, and just make them use a padlock.
minetest.register_on_mods_loaded(function()
	minetest.clear_craft({output = "default:chest_locked"})
	minetest.register_craft({
		output = "default:chest_locked",
		recipe = {
			{ "group:wood", "group:wood", "group:wood" },
			{ "group:wood", "basic_materials:padlock", "group:wood" },
			{ "group:wood", "group:wood", "group:wood" }
		}
	})
	minetest.register_craft({
		output = "default:chest_locked",
		type = "shapeless",
		recipe = {
			"default:chest",
			"basic_materials:padlock"
		}
	})
end)

-- FIXME: Why does this LBM exist?
minetest.register_lbm({
	name = "technic_chests:fix_wooden_chests",
	nodenames = {"default:chest"},
	action = function(pos, node)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", "")
	end
})
