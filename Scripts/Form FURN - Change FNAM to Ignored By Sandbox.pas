{
	Purpose: Change FNAM to Ignored By Sandbox
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
		SetElementEditValues(e, 'FNAM', '01');

	end;

function Finalize: integer;
	begin
		Result := 1;
	end;

end.
