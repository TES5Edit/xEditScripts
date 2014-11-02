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
	f, formlist: IInterface;
	fileFormList: iwbFile;

function Initialize: integer;
var
	s: string;
begin
	Result := 0;

	slFormlist := TStringList.Create;
	fileFormList := FileByLoadOrder(StrToInt('$06'));
	formlist   := RecordByFormID(fileFormList, $06FF0321, true);

end;

function Process(e: IInterface): integer;
begin
	Result := 0;
	
	//AddRequiredElementMasters(GetFile(e), fileFormList, false);

	slFormlist.Add(GetElementEditValues(e, 'Record Header\FormID'));

end;

function Finalize: integer;
var
	formids, lastlnam: IInterface;
	i, iLastIndex: integer;
	sItem, sInputItem: string;
begin
	
	formids := ElementByName(formlist, 'FormIDs');

	if not Assigned(formids) then
		formids := Add(formlist, 'FormIDs', true);
	
	if Assigned(formids) then begin
	
		for i := 0 to slFormlist.Count - 1 do begin
	
			formids := ElementAssign(formids, HighInteger, nil, true);
			formids := ElementByName(formlist, 'FormIDs');
			iLastIndex := ElementCount(formids) - 2;
			lastlnam := ElementByIndex(formids, iLastIndex);

			sInputItem := slFormlist[i];

			SetEditValue(lastlnam, sInputItem);
			AddMessage('Added: ' + sInputItem);
		
		end;

	end;

	Result := 1;
end;

end.
