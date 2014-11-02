{
	Purpose: Find and Replace References (FLST)
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	slRefsOrigin, slRefsDestination: TStringList;

	flstRefsRecOrigin, flstRefsOrigin: IInterface;
	flstRefsRecDestination, flstRefsDestination: IInterface;

	loadorder, patchmode: integer;
	f: IInterface;

function Initialize: integer;
	var
		s: string;

	begin
		Result := 0;

		// ------------------------------------------------------------

		slRefsOrigin := TStringList.Create;
		slRefsDestination := TStringList.Create;

		flstRefsRecOrigin 		:= RecordByFormID(FileByLoadOrder(04), $04000800, true);

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

			AddMessage('-------------------------------------------------------------------------------');
			AddMessage( 'Processing: ' + GetFileName(FileByLoadOrder(loadorder)));
			AddMessage('-------------------------------------------------------------------------------');

		end;

		if patchmode = 1 then begin

			f := AddNewFile;
			if not Assigned(f) then begin
				Result := 1;
				exit;
			end;

			loadorder := GetLoadOrder(f);

			AddMessage('-------------------------------------------------------------------------------');
			AddMessage( 'Processing: ' + GetFileName(f));
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

		// Get cell or worldspace data
		formid := GetEditValue(ElementByPath(e, 'Record Header\FormID'));
		
		//if Signature(e) == 'ACHR' or Signature(e) == 'REFR' then
		//	name   := GetEditValue(ElementByPath(e, 'NAME - Base'));
		
		//if Signature(e) <> 'ACHR' and Signature(e) <> 'REFR' then
			name   := formid;

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

		// Replace origin references with destination references from lists
		for j := 0 to slRefsOrigin.Count - 1 do begin

			//AddMessage('Record 1: ' + slRefsOrigin[j] );
			//AddMessage('Record 2: ' + name );
		
			if (pos(slRefsOrigin[j], name) > 0) then begin

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
		slRefsOrigin.Clear;
		slRefsDestination.Clear;
		Result := 1;
	end;

end.
