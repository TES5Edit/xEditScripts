{
	Purpose: List FormIDs with EDID Query
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

function Initialize: integer;
	begin
		Result := 0;
	end;

function Process(e: IInterface): integer;
	var
		rec: IInterface;
		formid, name, full: string;
	begin
		Result := 0;
		
		formid := IntToHex(FixedFormID(e),8);
		name := GetEditValue(ElementByPath(e, 'EDID'));
		full := GetEditValue(ElementByPath(e, 'FULL'));
		AddMessage(formid + '	' + name + '	' + full);

	end;

function Finalize: integer;
	begin
		Result := 0;
	end;

end.
