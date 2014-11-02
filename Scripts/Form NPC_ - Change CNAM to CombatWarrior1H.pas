{
	Purpose: Change NPC Class to CombatWarrior1H
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

function Process(e: IInterface): integer;
	begin
		Result := 0;

		AddMessage('Processing: ' + FullPath(e));

		//SetElementEditValues(e, 'CNAM', 'CombatRanger "Ranger" [CLAS:00013181]');
		//SetElementEditValues(e, 'CNAM', 'CombatWarrior1H "Warrior" [CLAS:00013176]');
		//SetElementEditValues(e, 'CNAM', 'CombatWarrior2H "Warrior" [CLAS:0001CE15]');
		SetElementEditValues(e, 'CNAM', 'GuardImperial "Guard" [CLAS:000253F2]');
		//SetElementEditValues(e, 'CNAM', 'GuardSonsSkyrim "Guard" [CLAS:000253F3]');
		
	end;

function Finalize: integer;
	begin
		Result := 1;
	end;

end.
