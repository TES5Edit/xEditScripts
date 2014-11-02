{
	Purpose: Create matching MISC from MSTT
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
	
	1. Create a new plugin
	2. Copy MSTT records to new plugin AS NEW RECORDS
	3. Select MSTT records in new plugin
	4. Apply script
}

unit UserScript;

var
	baserecord: IInterface;
  
//============================================================================
function Initialize: integer;
begin
	// base record is the template to copy?
	// BasicKnife01 [MISC:00104B40]
	baserecord := RecordByFormID(FileByIndex(0), $00104B40, true); // FileByIndex(0) = Skyrim.esm
	if not Assigned(baserecord) then begin
		AddMessage('Cannot find base record');
		Result := 1;
		Exit;
	end;
end;

//============================================================================
function Process(e: IInterface): integer;
var
	r: IInterface;
	formid: cardinal;
	i: integer;

begin
	if Signature(e) <> 'MSTT' then
		Exit;

	r := wbCopyElementToFile(baserecord, GetFile(e), true, true);
	if not Assigned(r) then begin
		AddMessage('Can''t copy base record as new');
		Result := 1;
		Exit;
	end;
	
	SetElementEditValues(r, 'EDID - Editor ID', GetElementEditValues(e, 'EDID - Editor ID') + 'MISC');
	SetElementEditValues(r, 'OBND - Object Bounds\X1', GetElementEditValues(e, 'OBND - Object Bounds\X1'));
	SetElementEditValues(r, 'OBND - Object Bounds\Y1', GetElementEditValues(e, 'OBND - Object Bounds\Y1'));
	SetElementEditValues(r, 'OBND - Object Bounds\Z1', GetElementEditValues(e, 'OBND - Object Bounds\Z1'));
	SetElementEditValues(r, 'OBND - Object Bounds\X2', GetElementEditValues(e, 'OBND - Object Bounds\X2'));
	SetElementEditValues(r, 'OBND - Object Bounds\Y2', GetElementEditValues(e, 'OBND - Object Bounds\Y2'));
	SetElementEditValues(r, 'OBND - Object Bounds\Z2', GetElementEditValues(e, 'OBND - Object Bounds\Z2'));
	SetElementEditValues(r, 'FULL - Name', GetElementEditValues(e, 'FULL - Name'));
	SetElementEditValues(r, 'Model\MODL - Model Filename', GetElementEditValues(e, 'Model\MODL - Model Filename')); // issue: why are the Model\MODS alternate texture subrecords obliterated?
	SetElementEditValues(r, 'DATA - Data\Value', '1');
    SetElementEditValues(r, 'DATA - Data\Weight', '1');
	
	// todo: create new formid instead of using the current formid and removing the node
	// 			 for now, manually change the formid of the new record
	formid := GetLoadOrderFormID(e);
	//RemoveNode(e);
	SetLoadOrderFormID(r, formid);
end;
	
function Finalize: integer;
begin
Result := 1;
	exit;
end;

end.
