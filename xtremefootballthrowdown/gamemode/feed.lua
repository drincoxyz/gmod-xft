--
-- Panels
--

local meta = {}

function meta:Init()
	self:SetSize(ScrW() / 3, ScrH() / 2)
	self:AlignRight()
	self.Feed = {}
end

function meta:Paint(w, h)
end

--
-- Name: PANEL:AddFeed
--
--
function meta:AddFeed()
	
end

vgui.Register("XFTFeed", meta, "DPanel")

--
-- Functions
--

--
-- Name: GM:ShowFeed
-- Desc: Shows the feed panel.
--
function GM:ShowFeed()
	if IsValid(self.FeedPanel) then
		self.FeedPanel:Remove()
	end

	self.FeedPanel = vgui.Create "XFTFeed"
end

--
-- Name: GM:HideFeed
-- Desc: Hides the feed panel.
--
function GM:HideFeed()
	if IsValid(self.FeedPanel) then
		self.FeedPanel:Remove()
	end
end