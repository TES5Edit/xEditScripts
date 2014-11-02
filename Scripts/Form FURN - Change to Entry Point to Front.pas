{
	Purpose: Change FNPR Entry Points to Front
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
		SetElementNativeValues(e, 'Marker Entry Points\FNPR\Entry Points', 1);

	end;

function Finalize: integer;
	begin
		Result := 1;
	end;

end.
