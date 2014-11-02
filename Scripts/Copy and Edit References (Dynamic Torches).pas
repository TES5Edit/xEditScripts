{
	Purpose: Copy and Edit References (Dynamic Torches)
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
	
	Instructions:
	1. Add input references to slReferences (e.g., MSTT.)
	2. Add output references to SetElementEditValues (e.g, ACTI.)
	3. Change the load order to the file where you want the records copied.
	4. Apply Script on Cell or Worldspace.
}

unit UserScript;

var
  slReferences: TStringList;

function Initialize: integer;
	begin
		Result := 0;
		
		slReferences := TStringList.Create;
		
		// INPUT REFERENCES
		// Reminder: Use only the FormID.
		
		slReferences.Add('00101592'); // TorchPermanantOn [MSTT:00101592]
		// TorchPermanentOff [STAT:00090728]
	end;

function Process(e: IInterface): integer;
	var
		r, rec: IInterface;
		query, formid, name, checkname: string;
		j, refcount: integer;
	begin
		Result := 0;
	
		if Signature(e) <> 'REFR' then
			exit;
		
		formid := GetEditValue(ElementByPath(e, 'Record Header\FormID'));
		name := GetEditValue(ElementByPath(e, 'NAME'));
		refcount := slReferences.Count - 1;
		
		for j := 0 to refcount do begin
			
			if (pos(slReferences[j], name) > 0) then begin

				AddMessage('Copying: ' + formid);
				r := wbCopyElementToFile(e, FileByLoadOrder(09), true, true); // Change this to the right file
				
				if not Assigned(r) then begin
					AddMessage('Can''t copy record as new');
					Result := 1;
					Exit;
				end;
				
				// OUTPUT REFERENCES
				// REMINDER: Don't forget to increment the slReferences[0...99] index.
				
				if (pos(slReferences[0], name) > 0) then
					SetElementEditValues(r, 'NAME', 'RemovableTorchSconce01 "Torch Sconce" [ACTI:0009151E]'); // RemovableTorchSconce01 "Torch Sconce" [ACTI:0009151E]
					
				SetLoadOrderFormID(r, GetLoadOrderFormID(e)); // copies load order for overrides
					
			end;
		end;

	end;

function Finalize: integer;
	begin
		Result := 0;
	end;

end.
