local tag = "godmode"

if CLIENT then
	local convar = CreateClientConVar("cl_" .. tag, "1", true, true)

	cvars.AddChangeCallback("cl_" .. tag, function(_, old, new)
		if old == new then return end
		new = tonumber(new)
		if not new then return end

		convar:SetInt(new)
		net.Start(tag)
			net.WriteBool(new >= 1)
		net.SendToServer()
	end, tag)

end

if SERVER then

	util.AddNetworkString(tag)

	hook.Add("PlayerSpawn", tag, function(ply)
		local val = ply:GetInfoNum("cl_" .. tag, "1")
		if val >= 1 then
			ply:GodEnable()
			ply:SendLua([[LocalPlayer():AddFlags(FL_GODMODE)]])
		else
			ply:GodDisable()
			ply:SendLua([[LocalPlayer():RemoveFlags(FL_GODMODE)]])
		end
	end)

	net.Receive(tag, function(_, ply)
		local god = net.ReadBool()
		if god then
			ply:GodEnable()
			ply:SendLua([[LocalPlayer():AddFlags(FL_GODMODE)]])
		else
			ply:GodDisable()
			ply:SendLua([[LocalPlayer():RemoveFlags(FL_GODMODE)]])
		end
	end)

end