--[[
	frames.lua
		Methods for managing frame creation and display
--]]

local ADDON, Addon = ...
Addon.frames = {}


--[[ Registry ]]--

function Addon:CreateFrame(id)
	if self:IsFrameEnabled(id) then
 		self.frames[id] = self.frames[id] or self[id:gsub('^.', id.upper) .. 'Frame']:New(id)
 		return self.frames[id]
 	end
end

function Addon:GetFrame(id)
	return self.frames[id]
end

function Addon:IterateFrames()
	return pairs(self.frames)
end

function Addon:AreBasicFramesEnabled()
	return self:IsFrameEnabled('inventory') and self:IsFrameEnabled('bank')
end

function Addon:IsFrameEnabled(id)
	return self.profile[id].enabled
end


--[[ Frame Control ]]--

function Addon:UpdateFrames()
	self:SendMessage('UPDATE_ALL')
end

function Addon:ToggleFrame(id)
	if self:IsFrameShown(id) then
		return self:HideFrame(id, true)
	else
		return self:ShowFrame(id)
	end
end

function Addon:ShowFrame(id)
	local frame = self:CreateFrame(id)
	if frame then
		frame.shownCount = (frame.shownCount or 0) + 1
		ShowUIPanel(frame)
	end
	return frame
end

function Addon:HideFrame(id, force)
	local frame = self:GetFrame(id)
	if frame then
		if force or frame.shownCount == 1 then
			frame.shownCount = 0
			HideUIPanel(frame)
		else
			frame.shownCount = (frame.shownCount or 0) - 1
		end
	end
	return frame
end

function Addon:IsFrameShown(id)
	local frame = self:GetFrame(id)
	return frame and (frame.shownCount or 0) > 0
end


--[[ Frame Control through Bags ]]--

function Addon:ToggleBag(frame, bag)
	if self:IsBagControlled(frame, bag) then
		return self:ToggleFrame(frame)
	end
end

function Addon:ShowBag(frame, bag)
	if self:IsBagControlled(frame, bag) then
		return self:ShowFrame(frame)
	end
end

function Addon:IsBagControlled(frame, bag)
	return not Addon.sets.displayBlizzard or self:IsFrameEnabled(frame) and not self.profile[frame].hiddenBags[bag]
end