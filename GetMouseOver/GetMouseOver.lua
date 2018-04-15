
SLASH_GETMOUSEOVER1,SLASH_GETMOUSEOVER2,SLASH_GETMOUSEOVER3,SLASH_GETMOUSEOVER4 = '/GetMouseOver','/getmouseover','/Getmouseover','/GetmouseOver';
function SlashCmdList.GETMOUSEOVER(cmd)
DEFAULT_CHAT_FRAME:AddMessage("Using the GetMouseOver(x) command:\n x indicates what kind of target you're looking for,\n 0 - Hostile 1 - Friendly 2 - both. \n Example usage: /run a=GetMouseOver(1) TargetUnit(a) CastSpellByName(\"Healing Touch\") ") 
end

function GetMouseOver(friendly)
	-- friendly use 1 for searching friendly targets, 0 for hostile ones, 2 For Both

	-- Save Frame
	mframe = GetMouseFocus()
	frameName = mframe:GetName()

	--No Frame(worldframe)
	if frameName == "WorldFrame" or frameName == nil then 

	-- Check Mouseover unit
	m = "mouseover"
		
		-- Return Unit if searching for both
		if friendly == 2 then
			if UnitExists(m) then 
					return m 
				else
					return "target"
				end			
		end
		
		-- Return only friendly Units(healspells,buffs)
		if friendly == 1 then 
			if UnitExists(m) and UnitIsFriend("player",m) then 
				return m			
			else
				-- Mouseover target wrong, choose target on HP percentage
				playerdiff = (UnitHealthMax("player") - UnitHealth("player"))/(UnitHealthMax("player")+1)
				targetdiff = (UnitHealthMax("target") - UnitHealth("target"))/(UnitHealthMax("target")+1)
			
				if playerdiff >= targetdiff then 
					return "player"
				else 
					return "target" 
				end
			
			end
		
		-- Hostile Targets
		else
			if UnitExists(m) and UnitIsEnemy("player",m) then 
				return m
			else
			
				if UnitExists("target") then 
				
					-- Mouseover Target Wrong, returning targets
					if UnitIsEnemy("player","target") then
						return "target" 
					else
						if UnitExists("targettarget") and UnitIsEnemy("player","targettarget") then
							return "targettarget"
						else 
							if UnitExists("targettargettarget") and UnitIsEnemy("player","targettargettarget") then 
								return "targettargettarget" 
							else
								return "target"
							end
						end
					end
				else
					-- No Hostile Unit found
					return "player"
				end
			end  
			
		end


	--MouseoverFrame Section
	else
	
		-- Check if the Unit has been saved before
		if UnitExists(mframe.unit) then return mframe.unit end
	
		unit = parseFrameToTarget(frameName)
		
		if unit ~= nil then
			-- Set unit to the Frame
			mframe.unit = unit
	
			-- Only return friendly
			if friendly == 1 then 
				if UnitIsEnemy("player",unit) then return "player" end
			end
			
			-- Only return enemy
			if friendly == 0 then
				if UnitIsFriend("player",unit) then return "target" end
			end
			
			return unit
		end
		
		-- Error Case when no Unit could be parsed from the Frame name
		if friendly == 1 then
			return "player"
		else
			return "target"
		end
	end


end 


function parseFrameToTarget(a)
-- String Parsing(no target set for the frame yet)
local parsedTarget=nil
a = string.lower(a)

-- Player
if string.find(a,"player") ~=nil then
	
	-- Exlude Pet
	if string.find(a,"pet")==nil then 
	
		-- Check Playertarget(most likely unused)
		if string.find(a,"target") ~= nil then 
			parsedTarget = "player"
			
			-- Count Target Amount
			local _, count = string.gsub(a, "target", "")
			for i = 1,count do
				parsedTarget = parsedTarget.."target"
			end
		else
			parsedTarget = "player"
		end 
		
		return parsedTarget
		
	end
end

-- Check for Player Pet
 if string.find(a,"pet") ~=nil then 
	
	-- Exclude party/raid pets here
	if string.find(a,"raid")== nil and string.find(a,"party") == nil then 
	
		-- Check for Pet Target
		if string.find(a,"target") ~=nil then 
			parsedTarget="pet"
			
			-- Count Target Amount
			local _, count = string.gsub(a, "target", "")
			for i = 1,count do
				parsedTarget = parsedTarget.."target"
			end
			
		else
			parsedTarget="pet"
		end
		
		return parsedTarget
		
	end
end

-- Party
if string.find(a,"party") ~= nil then 
	-- Read number %d
	num=string.sub(a,string.find(a,"%d"))
	-- Error Case, no number found
	if num == nil then return nil end
	
	-- Check for PartyPet
	if string.find(a,"pet") ~= nil then
	
		-- Check for Party pet target
		if string.find(a,"target") ~= nil then 
			parsedTarget="partypet"..num
			
			-- Count Target Amount
			local _, count = string.gsub(a, "target", "")
			for i = 1,count do
				parsedTarget = parsedTarget.."target"
			end
			
		else
			parsedTarget="partypet"..num
		end
			
		return parsedTarget
		
	else
	
		-- Normal Party Member
		if string.find(a,"target") ~=nil then
			parsedTarget = "party"..num
			
			-- Count Target Amount
			local _, count = string.gsub(a, "target", "")
			for i = 1,count do
				parsedTarget = parsedTarget.."target"
			end
			
		else
			parsedTarget="party"..num
		end
			
		return parsedTarget
		
	end
end

-- Raid
if string.find(a,"raid") ~= nil then 

	-- Read Raid number
	if string.find(a,"raidpullout") ~= nil then 
		-- Default Blizz UI
		num=string.sub(a,string.find(a,"button%d+"))
		num=string.sub(num,string.find(num,"%d+"))
	else	
		-- Read number %d+ (one or more numbers)
		num=string.sub(a,string.find(a,"%d+"))
	end

	
	-- Error Case, no number found
	if num == nil then return nil end
	
	-- Check for RaidPet
	if string.find(a,"pet") ~= nil then
	
		-- Check for Raid pet target
		if string.find(a,"target") ~= nil then 
			parsedTarget="raidpet"..num
						
			-- Count Target Amount
			local _, count = string.gsub(a, "target", "")
			for i = 1,count do
				parsedTarget = parsedTarget.."target"
			end
			
		else
			parsedTarget="raidpet"..num
		end
			
		return parsedTarget
		
	else
	
		-- Normal Raid Member
		if string.find(a,"target") ~=nil then
			parsedTarget = "raid"..num
			
			-- Count Target Amount
			local _, count = string.gsub(a, "target", "")
			for i = 1,count do
				parsedTarget = parsedTarget.."target"
			end
			
		else
			parsedTarget="raid"..num
		end
			
		return parsedTarget
		
	end
end

--Target(raid/party/playertargets were done above)
if string.find(a,"target") ~= nil then 
		
	parsedTarget = ""	
	-- Count Target Amount
	local _, count = string.gsub(a, "target", "")
	for i = 1,count do
		parsedTarget = parsedTarget.."target"
	end
	
	return parsedTarget
end



end