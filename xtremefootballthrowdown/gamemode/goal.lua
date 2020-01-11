---------------
-- Variables --
---------------

GM.Goals = GM.Goals or {}

---------------
-- Functions --
---------------

function GM:AddGoal(ent)
	table.insert(self.Goals, ent)
end

function GM:RemoveGoal(ent)
	table.RemoveByValue(self.Goals, ent)
end

function GM:GetGoals()
	return self.Goals
end