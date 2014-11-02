{
	Purpose: Change BNAM to _DS_CraftingScrimshaw
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

function Process(e: IInterface): integer;
	var
		rec: IInterface;

	begin
		Result := 0;

		rec := Signature(e);

		AddMessage('Processing: ' + FullPath(e));
		AddMessage('-------------------------------------------------------------------------------');
		AddMessage(' ');

		SetElementEditValues(e, 'BNAM', '_DS_CraftingScrimshaw [KYWD:04025C09]');

	end;

function Finalize: integer;
	begin
		AddMessage(' ');
		Result := 1;
	end;

end.
