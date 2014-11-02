{
	Purpose: List value and weight
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
	
	AddMessage('Form ID' + '	' + 'Name' + '	' + 'Editor ID' + '	' + 'Model Filename' + '	' + 'Value' + '	' + 'Weight');
	
end;

// called for every record selected in xEdit
function Process(e: IInterface): integer;
var
	rec: IInterface;
	sFormID, sName, sEditorID, sModel: string;
	sValue: integer;
	sWeight: float;
begin
  Result := 0;

  // processing code goes here
	sFormID		:= IntToHex(FormID(e),8);
	sName			:= GetEditValue(ElementByPath(e, 'FULL'));
	sEditorID := GetEditValue(ElementByPath(e, 'EDID'));
	sModel		:= GetEditValue(ElementByPath(e, 'Model\MODL'));
	sValue		:= GetEditValue(ElementByPath(e, 'DATA\Value'));
	sWeight		:= GetEditValue(ElementByPath(e, 'DATA\Weight'));
	AddMessage(sFormID + '	' + sName + '	' + sEditorID + '	' + sModel + '	' + IntToStr(sValue) + '	' + FloatToStr(sWeight));

end;

// Called after processing
// You can remove it if script doesn't require finalization code
function Finalize: integer;
begin
  Result := 0;
end;

end.
