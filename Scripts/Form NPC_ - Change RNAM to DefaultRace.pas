{
	Purpose: Change NPC_ to DefaultRace
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

function Process(e: IInterface): integer;
	begin
		Result := 0;

		// comment this out if you don't want those messages
		AddMessage('Processing: ' + FullPath(e));

		// processing code goes here
		//SetElementEditValues(e, 'RNAM', 'DefaultRace "Default Race" [RACE:00000019]');
		//SetElementEditValues(e, 'RNAM', 'ImperialRace "Imperial" [RACE:00013744]');
		//SetElementEditValues(e, 'RNAM', 'NordRace "Nord" [RACE:00013746]');
		//SetElementEditValues(e, 'RNAM', 'BretonRace "Breton" [RACE:00013741]');
		SetElementEditValues(e, 'RNAM', 'HighElfRace "High Elf" [RACE:00013743]');
		
	end;

function Finalize: integer;
	begin
		Result := 1;
	end;

end.
