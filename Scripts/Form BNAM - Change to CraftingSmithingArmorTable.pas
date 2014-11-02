{
	Purpose: Change BNAM to CraftingTanningRack
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

		if rec <> 'COBJ' then begin

			//SetElementEditValues(e, 'BNAM', 'CraftingCookpot [KYWD:000A5CB3]');
			//SetElementEditValues(e, 'BNAM', 'CraftingSmelter [KYWD:000A5CCE]');
			SetElementEditValues(e, 'BNAM', 'CraftingSmithingArmorTable [KYWD:000ADB78]');
			//SetElementEditValues(e, 'BNAM', 'CraftingSmithingForge [KYWD:00088105]');
			//SetElementEditValues(e, 'BNAM', 'CraftingSmithingSharpeningWheel [KYWD:00088108]');
			//SetElementEditValues(e, 'BNAM', 'CraftingSmithingSkyforge [KYWD:000F46CE]');
			//SetElementEditValues(e, 'BNAM', 'CraftingTanningRack [KYWD:0007866A]');

		end;

	end;

function Finalize: integer;
	begin
		AddMessage(' ');
		Result := 1;
	end;

end.
