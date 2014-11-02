{
	Purpose: Copy, Edit, and Flag References (Cobwebs)
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1

	Instructions:
	1. Add origin references to slRefMatchAgainst (e.g., MSTT.)
	2. Add destination references to SetElementEditValues (e.g, ACTI.)
	3. Change the load order to the destination file. (Line 53)
	4. Apply Script on Cell or Worldspace.
}

unit UserScript;

var
	slRefMatchAgainst, slRefReplaceWith: TStringList;
	loadorder, patchmode: integer;
	f: IInterface;

function Initialize: integer;
	var
		s: string;

	begin
		Result := 0;

		slRefMatchAgainst	:= TStringList.Create;
		slRefReplaceWith	:= TStringList.Create;

		// ------------------------------------------------------------
		// ORIGIN REFERENCES
		// Reminder: Use only the FormID.
		// ------------------------------------------------------------
		
		// [0]
		slRefMatchAgainst.Add('FXcobwebCorner01 [STAT:0002F5A0]');
		 slRefReplaceWith.Add('dubhFXcobwebCorner01 [ACTI:07000800]');
		// [1]
		slRefMatchAgainst.Add('FXcobwebCorner02 [STAT:0002F5A6]');
		 slRefReplaceWith.Add('dubhFXcobwebCorner02 [ACTI:07000801]');
		// [2]
		slRefMatchAgainst.Add('FXcobwebDoorOpen [STAT:0002F5A8]');
		 slRefReplaceWith.Add('dubhFXcobwebDoorOpen [ACTI:07000804]');
		// [3]
		slRefMatchAgainst.Add('FXcobwebWall01 [STAT:0002F59A]');
		 slRefReplaceWith.Add('dubhFXcobwebWall01 [ACTI:07000806]');
		// [4]
		slRefMatchAgainst.Add('FXcobwebDangle01 [MSTT:0002F5B2]');
		 slRefReplaceWith.Add('dubhFXcobwebDangle01 [ACTI:07000802]');
		// [5]
		slRefMatchAgainst.Add('FXcobwebDangle02 [MSTT:0002F5B1]');
		 slRefReplaceWith.Add('dubhFXcobwebDangle02 [ACTI:07000803]');
		// [6]
		slRefMatchAgainst.Add('FXCobWebDAngle01MovableStatic [MSTT:0005DD38]');
		 slRefReplaceWith.Add('dubhFXcobwebDangle01MSTT [ACTI:07000805]');
		
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
		j, refcount: integer;
		destination: iwbFile;

	begin
		Result := 0;

		if Signature(e) <> 'REFR' then
			exit;

		formid := GetEditValue(ElementByPath(e, 'Record Header\FormID'));
		name := GetEditValue(ElementByPath(e, 'NAME'));
		refcount := slRefMatchAgainst.Count - 1;

		destination := FileByLoadOrder(loadorder);
		flags := 'Record Header\Record Flags';

		for j := 0 to refcount do begin

			if (pos(slRefMatchAgainst[j], name) > 0) then begin

				try
					
					if patchmode = 1 then
						AddRequiredElementMasters(GetFile(e), destination, false);
					
					AddMessage('Copying: ' + formid);
					r := wbCopyElementToFile(e, destination, true, true);

					if not Assigned(r) then begin
						AddMessage('Cannot copy record as new');
						Result := 1;
						Exit;
					end;

					// ------------------------------------------------------------
					// DESTINATION REFERENCES
					// Reminder: Increment slRefMatchAgainst[0...99] index.
					// ------------------------------------------------------------

					//if (pos(slRefMatchAgainst[0], name) > 0) then
					//	SetElementNativeValues(r, flags, GetElementNativeValues(r, flags) or 1024); // Flag: PersistentReference QuestItem DisplaysInMainMenu
	
					for i := 0 to slRefMatchAgainst.Count - 1 do begin
					
						// Replace REFR
						if (pos(slRefMatchAgainst[i], name) > 0) then
							SetElementEditValues(r, 'NAME', slRefReplaceWith[i]);
							
						// Flag REFR
						if (pos(slRefMatchAgainst[i], name) > 0) then
							SetElementNativeValues(r, flags, GetElementNativeValues(r, flags) or 1024); // Flag: PersistentReference QuestItem DisplaysInMainMenu
						
					end;

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
