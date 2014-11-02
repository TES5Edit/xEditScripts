{
	Purpose: Find and Replace References (FLST)
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1

	1. Create a plugin.
	2. In that plugin, create an Origin References formlist. These references are what will be replaced.
	3. In that plugin, create a Destination References formlist. These references are what will be saved.
	4. Change the indices and formlist Form IDs in the Initialize function as appropriate.
	5. Select an external Cell or Worldspace.
	6. Apply the script.
}

unit UserScript;

var
	f, flstFile, flstRefsRecOrigin, flstRefsOrigin, flstRefsRecDestination, flstRefsDestination: IInterface;
	slRefsOrigin, slRefsDestination, slRefsUpdated, slRefsFailed: TStringList;
	filename, filenameProcessing: string;
	loadorder, patchmode: integer;

function Initialize: integer;
	var
		s: string;

	begin
		Result := 0;

		ClearMessages();

		slRefsOrigin := TStringList.Create;
		slRefsDestination := TStringList.Create;
		slRefsUpdated := TStringList.Create;
		slRefsFailed := TStringList.Create;

		// ------------------------------------------------------------
		// FORMLIST DATA
		// ------------------------------------------------------------

		flstFile				:= FileByLoadOrder(StrToInt('$0A'));
		flstRefsRecOrigin 		:= RecordByFormID(flstFile, $0A000908, false);
		flstRefsRecDestination  := RecordByFormID(flstFile, $0A000909, false);

		// ------------------------------------------------------------

		if MessageDlg('Create a new patch file [YES] or modify an existing plugin [NO]?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
			PatchMode := 1
		else
			PatchMode := 0;

		if patchmode = 0 then begin

			if not InputQuery('Enter', 'Process File at Load Order', s) then begin
				Result := 1;
				exit;
			end;

			loadorder := StrToInt('$' + s);

			filenameProcessing := GetFileName(FileByLoadOrder(loadorder));

			AddMessage('-------------------------------------------------------------------------------');
			AddMessage('Processing:	' + filenameProcessing);
			AddMessage('-- Using:		' + GetElementEditValues(flstRefsRecOrigin, 'Record Header\FormID'));
			AddMessage('-- Using:		' + GetElementEditValues(flstRefsRecDestination, 'Record Header\FormID') + #13#10);

			if length(GetElementEditValues(flstRefsRecOrigin, 'Record Header\FormID')) = 0 then
				exit;

			if length(GetElementEditValues(flstRefsRecDestination, 'Record Header\FormID')) = 0 then
				exit;

		end;

		if patchmode = 1 then begin

			f := AddNewFile;
			if not Assigned(f) then begin
				Result := 1;
				exit;
			end;

			loadorder := GetLoadOrder(f);

			filenameProcessing := GetFileName(f);

			AddMessage('-------------------------------------------------------------------------------');
			AddMessage('Processing:	' + filenameProcessing);
			AddMessage('-------------------------------------------------------------------------------');

		end;

	end;

function Process(e: IInterface): integer;
	var
		r, origin, dest: IInterface;
		query, formid, name, checkname, flags: string;
		i, j, refcount: integer;
		destination: iwbFile;

	begin
		Result := 0;

		// Exit if cell or worldspace is not selected
		if Signature(e) <> 'COBJ' then
			exit;

		filename := GetFileName(GetFile(e));

		// Get cell or worldspace data
		formid := GetEditValue(ElementByPath(e, 'Record Header\FormID'));
		//name   := GetElementEditValues(LinksTo(ElementByPath(e, 'Items\Item\CNTO\Item')), 'EDID');
		name   := GetElementEditValues(LinksTo(ElementByPath(e, 'Conditions\Condition\CTDA\Inventory Object')), 'EDID');
		AddMessage(name);

		destination := FileByLoadOrder(loadorder);
		flags		:= 'Record Header\Record Flags';

		// Add origin references to list
		flstRefsOrigin := ElementByName(flstRefsRecOrigin, 'FormIDs');

		if slRefsOrigin.Count = 0 then begin

			if Assigned(flstRefsOrigin) then begin

				for i := 0 to ElementCount(flstRefsOrigin) - 1 do begin

					origin := LinksTo(ElementByIndex(flstRefsOrigin, i));
					slRefsOrigin.Add(GetElementEditValues(origin, 'EDID'));

				end;

			end;

		end;

		// Add destination references to list
		flstRefsDestination := ElementByName(flstRefsRecDestination, 'FormIDs');

		if slRefsDestination.Count = 0 then begin

			if Assigned(flstRefsDestination) then begin

				for i := 0 to ElementCount(flstRefsOrigin) - 1 do begin

					dest := ElementByIndex(flstRefsDestination, i);
					slRefsDestination.Add(GetEditValue(dest));

				end;

			end;

		end;

		// Exit if the origin and destination reference counts do not match
		// Important: Every origin reference must have a destination reference!
		if slRefsOrigin.Count <> slRefsDestination.Count then begin

			AddMessage('Error: Origin and Destination reference counts do not match! Exiting.');
			exit;

		end;

		// Replace origin references with destination references from lists
		for j := 0 to slRefsOrigin.Count - 1 do begin

			if CompareStr(slRefsOrigin[j], name) = 0 then begin

				// If origin and destination files do not match
				if CompareStr(filenameProcessing, filename) <> 0 then begin

					try

						//if patchmode = 1 then
						//	AddRequiredElementMasters(GetFile(e), destination, false);

						r := wbCopyElementToFile(e, destination, true, true);

						// Cannot copy record as new
						if not Assigned(r) then begin
							slRefsFailed.Add('Cannot copy: ' + formid);
							continue;
						end;

						// Change reference name
						if CompareStr(slRefsOrigin[j], name) = 0 then begin
							SetElementEditValues(r, 'Conditions\Condition\CTDA\Inventory Object', slRefsDestination[j]);
							slRefsUpdated.Add('Success: ' + formid);
						end;

						SetLoadOrderFormID(r, GetLoadOrderFormID(e)); // copies load order for overrides

					except

						// Failure

					end; // end try

				end; // end if

				// If origin and destination files match
				if CompareStr(filenameProcessing, filename) = 0 then begin

					try

						// Change reference name
						if CompareStr(slRefsOrigin[j], name) = 0 then begin
							SetElementEditValues(e, 'Conditions\Condition\CTDA\Inventory Object', slRefsDestination[j]);
							slRefsUpdated.Add('Success: ' + formid);
						end;

					except

						// Failure

					end; // end try

				end; //end if

			end; // end if

		end; // end for

	end; // end function

function Finalize: integer;
	var
		i, limit: integer;
		dlgSave: TSaveDialog;
		flstFileName: string;
		flstFileNameLength: integer;

	begin

		flstFileName		:= GetFileName(flstFile);
		flstFileNameLength	:= Length(flstFileName) - 3;

		limit := 100;

		AddMessage('-------------------------------------------------------------------------------');
		AddMessage('REFERENCES UPDATED');
		AddMessage('-------------------------------------------------------------------------------' + #13#10);

		if slRefsUpdated.Count > limit then begin

			AddMessage(IntToStr(slRefsUpdated.Count) + ' records were updated. Saving log to file...' + #13#10);
			AddMessage('-------------------------------------------------------------------------------');

			dlgSave := TSaveDialog.Create(nil);
			dlgSave.Options := dlgSave.Options + [ofOverwritePrompt];
			dlgSave.Filter := 'Text files (*.txt)|*.txt';
			dlgSave.InitialDir := ProgramPath;
			dlgSave.FileName := 'fireundubh\[' + Delete(flstFileName, flstFileNameLength, 4) + '] ' + filename + ' - Find and Replace COBJ References (Successes).txt';
			if dlgSave.Execute then
				slRefsUpdated.SaveToFile(dlgSave.FileName);
			dlgSave.Free;

		end;

		if slRefsUpdated.Count <= limit then begin

			if slRefsUpdated.Count <> 0 then begin

				for i := 0 to slRefsUpdated.Count - 1 do
					AddMessage(slRefsUpdated[i]);

			end;

			if slRefsUpdated.Count = 0 then begin

				AddMessage(IntToStr(slRefsUpdated.Count) + ' records were updated.');

			end;

		end;

		slRefsUpdated.Clear;

		AddMessage(#13#10 + '-------------------------------------------------------------------------------');
		AddMessage('REFERENCES NOT UPDATED');
		AddMessage('-------------------------------------------------------------------------------' + #13#10);

		if slRefsFailed.Count > limit then begin

			AddMessage(IntToStr(slRefsFailed.Count) + ' records were not updated. Saving log to file...' + #13#10);
			AddMessage('-------------------------------------------------------------------------------');

			dlgSave := TSaveDialog.Create(nil);
			dlgSave.Options := dlgSave.Options + [ofOverwritePrompt];
			dlgSave.Filter := 'Text files (*.txt)|*.txt';
			dlgSave.InitialDir := ProgramPath;
			dlgSave.FileName := 'fireundubh\[' + Delete(flstFileName, flstFileNameLength, 4) + '] ' + filename + ' - Find and Replace COBJ References (Failures).txt';
			if dlgSave.Execute then
				slRefsFailed.SaveToFile(dlgSave.FileName);
			dlgSave.Free;

		end;

		if slRefsFailed.Count <= limit then begin

			if slRefsFailed.Count <> 0 then begin

				for i := 0 to slRefsFailed.Count - 1 do
					AddMessage(slRefsFailed[i]);

				AddMessage('-------------------------------------------------------------------------------');

			end;

			if slRefsFailed.Count = 0 then begin

				AddMessage(IntToStr(slRefsFailed.Count) + ' records were updated.' + #13#10);

				AddMessage('-------------------------------------------------------------------------------');

			end;

		end;

		slRefsFailed.Clear;

		slRefsOrigin.Clear;
		slRefsDestination.Clear;

		Result := 1;
	end;

end.
