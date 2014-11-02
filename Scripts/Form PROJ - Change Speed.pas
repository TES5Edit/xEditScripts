{
	Purpose: Change CNAM to Bone Meal
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
		SetElementEditValues(e, 'DATA\Gravity', '0.2');
		SetElementEditValues(e, 'DATA\Speed', '7200');
		
	end;

function Finalize: integer;
	begin
		Result := 1;
	end;

end.
