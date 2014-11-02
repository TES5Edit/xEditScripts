{
	Purpose: Add Factions from Formlist
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	slFactionsToAdd, slFactionsToFilter, slFactionsToDelete: TStringList;
	formlist: IInterface;
	fileFormList: iwbFile;
	h, i, j, k, l, m, n, o: integer;

function Initialize: integer;
	var
		s: string;
	begin
		Result := 0;

		if not InputQuery('Enter', 'Formlist Form ID', s) then begin
			Result := 1;
			exit;
		end;
		
		AddMessage('');

		fileFormList := FileByLoadOrder(StrToInt('$' + Copy(s, 1, 2)));
		formlist   := RecordByFormID(fileFormList, StrToInt('$' + s), true);

		slFactionsToAdd := TStringList.Create;
		slFactionsToFilter := TStringList.Create;
		slFactionsToDelete := TStringList.Create;

	end;

function Process(e: IInterface): integer;
	var
		factionsToAdd, factionsToFilter, factions, faction, listitem: IInterface;

	begin
		Result := 0;
		
		AddMessage('Processing:' + FullPath(e));

		factions := ElementByPath(e, 'Factions');
		
		if ElementCount(factions) = 0 then
			Remove(factions);

		// add factions to add from formlist to a formlist
		factionsToAdd := ElementByPath(formlist, 'FormIDs');
		
		for i := 0 to ElementCount(factionsToAdd) - 1 do begin
		
			if Signature(LinksTo(ElementByIndex(factionsToAdd, i))) <> 'FACT' then begin
				AddMessage(#13#10 + '-------------------------------------------------------------------------------');
				AddMessage('Error: ' + Name(formlist) + ' must contain only FACT references!');
				AddMessage('-------------------------------------------------------------------------------' + #13#10);
				exit;
			end;
		
			slFactionsToAdd.Add( GetEditValue(ElementByIndex(factionsToAdd, i)) );
			
		end;

		// filter existing factions from a formlist
		factionsToFilter := ElementByPath(e, 'Factions');

		if ElementCount(factionsToFilter) > 0 then begin

			for j := 0 to ElementCount(factionsToFilter) - 1 do
				slFactionsToFilter.Add( GetEditValue(ElementByPath(ElementByIndex(factionsToFilter, j), 'Faction')) );

			for k := slFactionsToAdd.Count - 1 downto 0 do begin

				for l := slFactionsToFilter.Count - 1 downto 0 do begin

					if CompareStr(slFactionsToFilter[l], slFactionsToAdd[k]) = 0 then
						slFactionsToDelete.Add(IntToStr(k));

				end;

			end;
			
			for o := 0 to slFactionsToDelete.Count - 1 do begin

				slFactionsToAdd.Delete(StrToInt(slFactionsToDelete[o]));

			end;

		end;

		// add filtered list of factions to record
		factions := ElementByPath(e, 'Factions');
		
		if not Assigned(factions) then
			factions := Add(e, 'Factions', true);
			
		if slFactionsToAdd.Count > 0 then begin

			for m := 0 to slFactionsToAdd.Count - 1 do begin

				faction := ElementAssign(factions, HighInteger, ElementByPath(factions, 'SNAM'), false);

				SetEditValue(ElementByPath(faction, 'Faction'), slFactionsToAdd[m]);

				AddMessage('Added faction: ' + GetEditValue(ElementByPath(faction, 'Faction')));

			end;

		end;

		// remove null references
		factions := ElementByPath(e, 'Factions');
		for n := 0 to ElementCount(factions) - 1 do begin

			if CompareStr('NULL - Null Reference [00000000]', GetEditValue(ElementByPath(ElementByIndex(factions, n), 'Faction'))) = 0 then
				Remove(ElementByIndex(factions, n));

		end;

		AddMessage('');
			
		slFactionsToAdd.Clear;
		slFactionsToFilter.Clear;
		slFactionsToDelete.Clear;

	end;

function Finalize: integer;

	begin

		Result := 1;

	end;

end.