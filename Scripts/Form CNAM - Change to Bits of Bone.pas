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
		SetElementEditValues(e, 'CNAM', '_DS_BoneBits "Bits of Bone" [MISC:04006953]');
		SetElementNativeValues(e, 'NAM1', 1);
		
	end;

function Finalize: integer;
	begin
		Result := 1;
	end;

end.
