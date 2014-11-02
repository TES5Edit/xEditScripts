{
	Purpose: Add LNAM to FLST
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	slFormlist: TStringList;
	loadorder, patchmode: integer;
	f: IInterface;

function Initialize: integer;
var
	s: string;
begin
	Result := 0;

	slFormlist := TStringList.Create;

	slFormlist.Add('[REFR:000ECF49] (places MapMarker [STAT:00000010] in GRUP Cell Persistent Children of [CELL:00000D74] (in Tamriel "Skyrim" [WRLD:0000003C] at 0,0))');
	slFormlist.Add('[REFR:000ECF49] (places MapMarker [STAT:00000010] in GRUP Cell Persistent Children of [CELL:00000D74] (in Tamriel "Skyrim" [WRLD:0000003C] at 0,0))');

end;

function Process(e: IInterface): integer;
var
	rec, formlist, lnam, item, lastlnam: IInterface;
	i, iLastIndex, iResults: integer;
	sItem, sInputItem: string;
	bAssigned: boolean;
begin
	Result := 0;

	rec := Signature(e);

	if rec <> 'FLST' then
		exit;

	formlist := ElementByName(e, 'FormIDs');

	if Assigned(formlist) then begin
	
		for i := 0 to slFormlist.Count - 1 do begin
	
			formlist := ElementAssign(formlist, HighInteger, nil, true);
			formlist := ElementByName(e, 'FormIDs');
			iLastIndex := ElementCount(formlist) - 1;
			lastlnam := ElementByIndex(formlist, iLastIndex);

			sInputItem := slFormlist[i];

			SetEditValue(lastlnam, sInputItem);
			AddMessage('Added: ' + sInputItem);
		
		end;

	end;
	

end;

function Finalize: integer;
begin
	Result := 0;
end;

end.
