{
	Purpose: Change FULL
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

function Process(e: IInterface): integer;
	var
		s, edid, this, that: string;
	begin
		Result := 0;

		edid := GetElementEditValues(e, 'FULL');
		
		this := 'Thirty-Six';
		that := '36';
		
		AddMessage('Processing: ' + FullPath(e));

		if pos(lowercase(this), lowercase(edid)) > 0 then begin
			s := StringReplace(edid, this, that, [rfReplaceAll, rfIgnoreCase]);
			SetElementEditValues(e, 'FULL', s);
		end;
		
	end;

function Finalize: integer;
	begin
		Result := 1;
	end;

end.
