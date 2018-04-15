# GetMouseOver
A lightweight mouseover addon with some target choosing logics

All it does is add the function GetMouseOver(type) which returns the unit you mouseover(frames or 3d).
"type" is used to tell the function which kind of target you want to have returned, use 1 for searching friendly targets, 0 for hostile ones, 2 for both.
Since the unit is returned, you can use it for further macro logic, like an innervate macro which checks class/mana level of the mouseover target before casting it

examples:

Target friendly mouseover target and cast a heal
/run local t=GetMouseOver(1) TargetUnit(t) CastSpellByName("Greater Heal")

Target friend or foe to Dispel
/run local t=GetMouseOver(2) TargetUnit(t) CastSpellByName("Dispel Magic(Rank 2)") 

Target enemy to dot
/run local t=GetMouseOver(0) TargetUnit(t) CastSpellByName("Shadow Word:Pain")

Innervate macro, checking mana before casting
/run local t=GetMouseOver(1) if UnitMana(t)/UnitManaMax(t) < 0.5 then  TargetUnit(t) CastSpellByName("Innervate") end

Installing: Make sure you only have one folder and remove the -master from it, so that you get the following structure:
/Interface/Addons/GetMouseOver/GetMouseOver.toc
