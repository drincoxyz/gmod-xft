GM.Goals = GM.Goals or {}

--
-- Adds a valid goal to the list of goals.
--
function GM:AddGoal(ent)
	table.insert(self.Goals, ent)
end

--
-- Removes a goal from the list of goal.
--
function GM:RemoveGoal(ent)
	table.RemoveByValue(self.Goals, ent)
end

--
-- Returns a list of all valid goals.
--
function GM:GetGoals()
	return self.Goals
end