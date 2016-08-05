local coroner = require ("coroner")

local frame_cnt, ipframe_cnt = 0

local hooks = {
	-- Run for each input file.
	["@"] = function (filename, linktype)
		print (("Reading a file '%s' (%s)"):format (filename, linktype))
		frame_cnt = 0
		ipframe_cnt = 0
	end,

	-- Match a beginning of a frame.
	["^"] = function (ts, num)
		frame_cnt = frame_cnt + 1
	end,

	-- Match only IP packets.
	["ip"] = function (packet, ts, num)
		print (("[%05d] IP : %s -> %s"):format (num, packet:get_saddr ():color ("green"), packet:get_daddr ():color ("green")))
		ipframe_cnt = ipframe_cnt + 1
	end,

	-- Run after all data in a file were processed.
	["."] = function ()
		print (("%d IP packets out of %d."):format (ipframe_cnt, frame_cnt))
	end
}

local app = coroner.new_app (coroner.app.type.DISSECTOR)

if not app:set_hooks (hooks) then
	error (app:get_error ())
end

return app:run ()

