{
	Purpose: Convert STAT to CONT
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
	
	1. Create a new plugin
	2. Copy STAT records to new plugin AS NEW RECORDS
	3. Select STAT records in new plugin
	4. Apply script
}

unit UserScript;

var
	baserecord: IInterface;
  
//============================================================================
function Initialize: integer;
begin

	// base record is the template to copy?
	// BarrelIngredientCommon01 "Barrel" [CONT:00092B10]
	baserecord := RecordByFormID(FileByIndex(0), $00092B10, true); // FileByIndex(0) = Skyrim.esm
	
	if not Assigned(baserecord) then begin
		AddMessage('Cannot find base record');
		Result := 1;
		Exit;
	end;

end;

//============================================================================
function Process(e: IInterface): integer;
var
	r, items: IInterface;
	formid: cardinal;
	i: integer;

begin

	if Signature(e) <> 'STAT' then
		Exit;

	r := wbCopyElementToFile(baserecord, GetFile(e), true, true);

	if not Assigned(r) then begin
		AddMessage('Can''t copy base record as new');
		Result := 1;
		Exit;
	end;
	
	// Editor ID
	SetElementEditValues(r, 'EDID', GetElementEditValues(e, 'EDID') + 'CONT');
	
	// Object Bounds
	SetElementEditValues(r, 'OBND\X1', GetElementEditValues(e, 'OBND\X1'));
	SetElementEditValues(r, 'OBND\Y1', GetElementEditValues(e, 'OBND\Y1'));
	SetElementEditValues(r, 'OBND\Z1', GetElementEditValues(e, 'OBND\Z1'));
	SetElementEditValues(r, 'OBND\X2', GetElementEditValues(e, 'OBND\X2'));
	SetElementEditValues(r, 'OBND\Y2', GetElementEditValues(e, 'OBND\Y2'));
	SetElementEditValues(r, 'OBND\Z2', GetElementEditValues(e, 'OBND\Z2'));
	
	// Name
	SetElementEditValues(r, 'FULL', GetElementEditValues(e, 'EDID') + 'CONT');
	
	// Model
	SetElementEditValues(r, 'Model\MODL', GetElementEditValues(e, 'Model\MODL')); // issue: why are the Model\MODS alternate texture subrecords obliterated?
	
	// Items
	//items := ElementByName(e, 'Items');
	//SetElementEditValues(items, 'Item\CNTO\Item', '');
	
	// Data
	SetElementEditValues(r, 'DATA\Value', '1');
    SetElementEditValues(r, 'DATA\Weight', '1');
	
	// todo: create new formid instead of using the current formid and removing the node
	// 			 for now, manually change the formid of the new record
	formid := GetLoadOrderFormID(e);
	RemoveNode(e);
	SetLoadOrderFormID(r, formid);

end;
	
function Finalize: integer;
begin

	Result := 1;
	exit;

end;

end.
