{
	Purpose: List LNAM subrecords
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

function Initialize: integer;
begin
  Result := 0;
  ClearMessages();
end;

function Process(e: IInterface): integer;
var
	rec, list, listitem: IInterface;
	lnam, formid: string;
	i: integer;
begin
  Result := 0;

	list := ElementByName(e, 'FormIDs');

	for i := 0 to ElementCount(list) - 1 do begin
		//lnam := GetEditValue(ElementByIndex(list, i));
		listitem := ElementByIndex(list, i);
		formid := IntToHex(FixedFormID(LinksTo(listitem)), 8);
		AddMessage(GetElementEditValues(LinksTo(listitem), 'Record Header\FormID'));
	end;

end;

function Finalize: integer;
begin
  Result := 0;
end;

end.
