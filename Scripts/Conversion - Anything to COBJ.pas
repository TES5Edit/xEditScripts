{
	Purpose: Convert STAT to MISC
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
	baserecord, formlist, items: IInterface;
	sPrefix, sSuffix: string;
	destination, fileBaseRecord, fileFormList: iwbFile;
	fileLoadOrder1, fileLoadOrder2: string;
  
//============================================================================
function Initialize: integer;

	begin

		// base record is the template to copy?
		// BasicKnife01 [MISC:00104B40]
		fileLoadOrder1 := '$09'; // Hunterborn.esp
		fileLoadOrder2 := '$0A'; // Target
		
		fileBaseRecord := FileByLoadOrder(StrToInt(fileLoadOrder1));
		fileFormList   := FileByLoadOrder(StrToInt(fileLoadOrder2));
		
		baserecord := RecordByFormID(fileBaseRecord, StrToInt(fileLoadOrder1 + '015D8E'), true);
		formlist   := RecordByFormID(fileFormList,   StrToInt(fileLoadOrder2 + 'FF0800'), true);

		sPrefix := '_DS_Recipe_Bone_Bits_';
		sSuffix := '';
		
		destination := FileByLoadOrder(StrToInt(fileLoadOrder2));
		
		if not Assigned(baserecord) then begin
			AddMessage('Cannot find base record');
			Result := 1;
			Exit;
		end;

	end;

//============================================================================
function Process(e: IInterface): integer;

	var
		r, origin, conditions, condition2: IInterface;
		formid: cardinal;
		i: integer;

	begin

		AddRequiredElementMasters(GetFile(e), destination, false);
		
		// Copy base record to file
		r := wbCopyElementToFile(baserecord, destination, true, true);
		
		if not Assigned(r) then begin
			AddMessage('Cannot copy base record as new');
			exit;
		end;
		
		SetElementEditValues(r, 'EDID', sPrefix + GetElementEditValues(e, 'EDID') + sSuffix);
		
		items := ElementByName(formlist, 'FormIDs');
		
		for i := 0 to ElementCount(items) - 1 do begin
		
			origin := ElementByIndex(items, i);
			
			if pos( GetElementEditValues(LinksTo(origin), 'EDID'), GetElementEditValues(r, 'EDID') ) > 0 then begin

				SetElementEditValues(r, 'Items\Item\CNTO\Item', GetElementEditValues(LinksTo(origin), 'Record Header\FormID'));
				
				condition2 := ElementByIndex(ElementByPath(r, 'Conditions'), 1);
				
				SetElementEditValues(condition2, 'CTDA\Inventory Object', GetElementEditValues(LinksTo(origin), 'Record Header\FormID'));
			
			end;
		
		end;
		
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
