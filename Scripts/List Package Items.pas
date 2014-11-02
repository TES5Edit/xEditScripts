{
	Purpose: List Package Items
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	slResults: TStringList;
	i: integer;

function Initialize: integer;
begin

	Result := 0;
	
	slResults := TStringList.Create;
	slResults.Sorted := True;
	slResults.Duplicates := dupIgnore;
	
	AddMessage('-------------------------------------------------------------------------------');
	
end;

function Process(e: IInterface): integer;
var
	list, listitem: IInterface;
begin
	Result := 0;
		
	if Signature(e) = 'NPC_' then
		list := ElementByName(e, 'Packages');

	for i := 0 to ElementCount(list) - 1 do begin
		listitem := GetEditValue(ElementByIndex(list, i));
		slResults.Add(listitem);
	end;

end;

function Finalize: integer;
begin
	
	slResults.Sort();
	
	for i := 0 to slResults.Count - 1 do begin
	
		AddMessage(slResults[i]);
	
	end;
	
	slResults.Clear;
	
	AddMessage('-------------------------------------------------------------------------------');
	Result := 1;
	
end;

end.
