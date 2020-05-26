local meta = FindMetaTable "Player"

function meta:GetItem()
	return self:GetNW2Entity "m_eItem"
end

function meta:SetItem(item)
	return self:SetNW2Entity("m_eItem", item)
end

function meta:GetNextItemPickup()
	return self:GetNW2Float "m_fNextItemPickup"
end

function meta:SetNextItemPickup(time)
	return self:SetNW2Float("m_fNextItemPickup", time)
end

function meta:GetNextItemDrop()
	return self:GetNW2Float "m_fNextItemDrop"
end

function meta:SetNextItemDrop(time)
	return self:SetNW2Float("m_fNextItemDrop", time)
end
