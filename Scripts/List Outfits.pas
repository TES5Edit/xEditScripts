{
	Purpose: List value and weight
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;


function Initialize: integer;
begin
  Result := 0;
	
	AddMessage('Form ID' + '	' + 'Name' + '	' + 'Editor ID' + '	' + 'Outfit');
	
end;

function Process(e: IInterface): integer;
var
  rec: IInterface;
  sFormID, sName, sEditorID, sOutfit: string;

begin
  Result := 0;

  sFormID	:= IntToHex(FormID(e),8);
  sName		:= GetEditValue(ElementByPath(e, 'FULL'));
  sEditorID	:= GetEditValue(ElementByPath(e, 'EDID'));
  sOutfit	:= GetEditValue(ElementByPath(e, 'DOFT'));
  AddMessage(sFormID + '	' + sName + '	' + sEditorID + '	' + sOutfit);

end;

function Finalize: integer;
begin
  Result := 0;
end;

end.
