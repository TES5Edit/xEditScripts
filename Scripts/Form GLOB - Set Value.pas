{
	Purpose: Set FLTV value
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

function Process(e: IInterface): integer;
	begin
		Result := 0;

		if GetElementNativeValues(e, 'FLTV') > 1 then
			SetElementNativeValues(e, 'FLTV', 1);
		
	end;

function Finalize: integer;
	begin
		Result := 1;
	end;

end.
