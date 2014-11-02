{
	Purpose: List model paths
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

// Called before processing
// You can remove it if script doesn't require initialization code
function Initialize: integer;
begin
  Result := 0;
end;

// called for every record selected in xEdit
function Process(e: IInterface): integer;
var
	rec: IInterface;
	query, edid, full, modl: string;
begin
  Result := 0;

	query := '';
	edid := GetEditValue(ElementByPath(e, 'EDID'));
	full := GetEditValue(ElementByPath(e, 'FULL'));
	modl := GetEditValue(ElementByPath(e, 'Model\MODL'));
	AddMessage(IntToHex(FormID(e), 8) + '	' + edid + '	' + full + '	' + modl);
	//if (pos(lowercase(query), lowercase(full)) > 0) or (pos(lowercase(query), lowercase(modl)) > 0) then
	//	AddMessage(IntToHex(FormID(e), 8) + '	' + edid + '	' + full + '	' + modl);

end;

// Called after processing
// You can remove it if script doesn't require finalization code
function Finalize: integer;
begin
  Result := 0;
end;

end.
