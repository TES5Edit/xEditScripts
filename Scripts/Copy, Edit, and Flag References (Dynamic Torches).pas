{
	Purpose: Copy, Edit, and Flag References (Dynamic Torches)
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1

	Instructions:
	1. Add origin references to slReferences (e.g., MSTT.)
	2. Add destination references to SetElementEditValues (e.g, ACTI.)
	3. Change the load order to the destination file. (Line 53)
	4. Apply Script on Cell or Worldspace.
}

unit UserScript;

var
	slReferences: TStringList;
	loadorder, patchmode: integer;
	f: IInterface;

function Initialize: integer;
	var
		s: string;

	begin
		Result := 0;

		slReferences := TStringList.Create;

		// ------------------------------------------------------------
		// ORIGIN REFERENCES
		// Reminder: Use only the FormID.
		// ------------------------------------------------------------

		//slReferences.Add('000BCC9D'); // DefaultTorch01NS_Fast [LIGH:000BCC9D]
		//slReferences.Add('00101592'); // TorchPermanantOn [MSTT:00101592]
		slReferences.Add('00088242');
		slReferences.Add('00088250');
		slReferences.Add('0008824E');
		slReferences.Add('00088251');
		slReferences.Add('00088243');
		slReferences.Add('00088252');
		slReferences.Add('000BCC9D');
		slReferences.Add('00038A77');
		slReferences.Add('000CB3B0');
		slReferences.Add('0003559C');
		slReferences.Add('0005EAD6');
		slReferences.Add('000C1D01');
		slReferences.Add('000BCC9F');
		slReferences.Add('00088244');
		slReferences.Add('00088253');
		slReferences.Add('00036464');
		slReferences.Add('000346CF');
		slReferences.Add('00036B0D');
		slReferences.Add('0010092A');

		// ------------------------------------------------------------

		if MessageDlg('Create a new patch file [YES] or modify existing plugins [NO]?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
			PatchMode := 1
		else
			PatchMode := 0;
		
		if patchmode = 0 then begin	
		
			if not InputQuery('Enter', 'Load Order', s) then begin
				Result := 1;
				exit;
			end;
			
			loadorder := StrToInt(s);
		
		end;
		
		if patchmode = 1 then begin

			f := AddNewFile;
			if not Assigned(f) then begin
				Result := 1;
				exit;
			end;
			
			loadorder := GetLoadOrder(f);
			
			AddMessage('-------------------------------------------------------------------------------');
			AddMessage( 'Working ' + GetFileName(f) + ' ...' );
			AddMessage('-------------------------------------------------------------------------------');
		
		end;

	end;

function Process(e: IInterface): integer;
	var
		r, rec: IInterface;
		query, formid, name, checkname, flags: string;
		j, k, refcount: integer;
		destination: iwbFile;

	begin
		Result := 0;

		if Signature(e) <> 'REFR' then
			exit;

		formid := GetEditValue(ElementByPath(e, 'Record Header\FormID'));
		name := GetEditValue(ElementByPath(e, 'NAME'));
		refcount := slReferences.Count - 1;

		destination := FileByLoadOrder(loadorder);
		flags := 'Record Header\Record Flags';

		for j := 0 to refcount do begin

			if (pos(slReferences[j], name) > 0) then begin

				try
					
					if (patchmode = 1) and (GetFilename(e) <> 'Skyrim.esm') then
						AddRequiredElementMasters(GetFile(e), destination, false);
					
					if (patchmode = 1) and (GetFilename(e) = 'Skyrim.esm') then
						AddMasterIfMissing(destination, 'Skyrim.esm');
					
					AddMessage('Copying: ' + formid);
					r := wbCopyElementToFile(e, destination, true, true);

					if not Assigned(r) then begin
						AddMessage('Cannot copy record as new');
						Result := 1;
						Exit;
					end;

					// ------------------------------------------------------------
					// DESTINATION REFERENCES
					// Reminder: Increment slReferences[0...99] index.
					// ------------------------------------------------------------

					//if (pos(slReferences[0], name) > 0) then
					//	SetElementNativeValues(r, flags, GetElementNativeValues(r, flags) or 2048); // Flag: InitiallyDisabled
					//	
					//if (pos(slReferences[1], name) > 0) then
					//	SetElementNativeValues(r, flags, GetElementNativeValues(r, flags) or 2048); // Flag: InitiallyDisabled
					//	
					//if (pos(slReferences[2], name) > 0) then
					//	SetElementNativeValues(r, flags, GetElementNativeValues(r, flags) or 2048); // Flag: InitiallyDisabled
					//	
					//if (pos(slReferences[3], name) > 0) then
					//	SetElementNativeValues(r, flags, GetElementNativeValues(r, flags) or 2048); // Flag: InitiallyDisabled
					//	
					//if (pos(slReferences[4], name) > 0) then
					//	SetElementNativeValues(r, flags, GetElementNativeValues(r, flags) or 2048); // Flag: InitiallyDisabled
					//	
					//if (pos(slReferences[5], name) > 0) then
					//	SetElementNativeValues(r, flags, GetElementNativeValues(r, flags) or 2048); // Flag: InitiallyDisabled
					//	
					//if (pos(slReferences[6], name) > 0) then
					//	SetElementNativeValues(r, flags, GetElementNativeValues(r, flags) or 2048); // Flag: InitiallyDisabled
					//	
					//if (pos(slReferences[7], name) > 0) then
					//	SetElementNativeValues(r, flags, GetElementNativeValues(r, flags) or 2048); // Flag: InitiallyDisabled
					//	
					//if (pos(slReferences[8], name) > 0) then
					//	SetElementNativeValues(r, flags, GetElementNativeValues(r, flags) or 2048); // Flag: InitiallyDisabled
					//	
					//if (pos(slReferences[9], name) > 0) then
					//	SetElementNativeValues(r, flags, GetElementNativeValues(r, flags) or 2048); // Flag: InitiallyDisabled
					//	
					//if (pos(slReferences[10], name) > 0) then
					//	SetElementNativeValues(r, flags, GetElementNativeValues(r, flags) or 2048); // Flag: InitiallyDisabled
					//	
					//if (pos(slReferences[11], name) > 0) then
					//	SetElementNativeValues(r, flags, GetElementNativeValues(r, flags) or 2048); // Flag: InitiallyDisabled
					//	
					//if (pos(slReferences[12], name) > 0) then
					//	SetElementNativeValues(r, flags, GetElementNativeValues(r, flags) or 2048); // Flag: InitiallyDisabled
					//	
					//if (pos(slReferences[13], name) > 0) then
					//	SetElementNativeValues(r, flags, GetElementNativeValues(r, flags) or 2048); // Flag: InitiallyDisabled
					//	
					//if (pos(slReferences[14], name) > 0) then
					//	SetElementNativeValues(r, flags, GetElementNativeValues(r, flags) or 2048); // Flag: InitiallyDisabled
					//	
					//if (pos(slReferences[15], name) > 0) then
					//	SetElementNativeValues(r, flags, GetElementNativeValues(r, flags) or 2048); // Flag: InitiallyDisabled
					//	
					//if (pos(slReferences[16], name) > 0) then
					//	SetElementNativeValues(r, flags, GetElementNativeValues(r, flags) or 2048); // Flag: InitiallyDisabled
					//	
					//if (pos(slReferences[17], name) > 0) then
					//	SetElementNativeValues(r, flags, GetElementNativeValues(r, flags) or 2048); // Flag: InitiallyDisabled
					//	
					//if (pos(slReferences[18], name) > 0) then
					//	SetElementNativeValues(r, flags, GetElementNativeValues(r, flags) or 2048); // Flag: InitiallyDisabled
						
					//if (pos(slReferences[0], name) > 0) then
					//	SetElementNativeValues(r, flags, GetElementNativeValues(r, flags) or 1024); // Flag: PersistentReference QuestItem DisplaysInMainMenu

					//if (pos(slReferences[1], name) > 0) then
					//	SetElementEditValues(r, 'NAME', 'RemovableTorchSconce01 "Torch Sconce" [ACTI:0009151E]'); // RemovableTorchSconce01 "Torch Sconce" [ACTI:0009151E]

					// ------------------------------------------------------------

					SetLoadOrderFormID(r, GetLoadOrderFormID(e)); // copies load order for overrides

				except

					//AddMessage('Record exists. Skipping.');

				end; // end try

			end; // end if

		end; // end for

	end;

function Finalize: integer;
	begin
		AddMessage('-------------------------------------------------------------------------------');
		Result := 1;
	end;

end.
