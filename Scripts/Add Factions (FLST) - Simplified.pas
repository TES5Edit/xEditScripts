{
	Purpose: Add Factions from Formlist
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	formlist, item: IInterface;
	fileFormList: iwbFile;
	slFactions: TStringList;
	i: integer;

function Initialize: integer;
	var
		s: string;
	begin
		Result := 0;

		//if not InputQuery('Enter', 'Formlist Form ID', s) then begin
		//	Result := 1;
		//	exit;
		//end;

		s := '01000800';
		
		AddMessage('');

		fileFormList := FileByLoadOrder(StrToInt('$' + Copy(s, 1, 2)));
		formlist   := RecordByFormID(fileFormList, StrToInt('$' + s), true);

		slFactions := TStringList.Create;
		slFactions.Duplicates := dupIgnore;
		slFactions.Sorted := true;

	end;

function Process(e: IInterface): integer;
	var
		factions, faction: IInterface;

	begin

		AddMessage('Processing:' + FullPath(e));

		// remove 'Factions' group when incomplete
		factions := ElementByPath(e, 'Factions');
		if ElementCount(factions) = 0 then
			Remove(factions);

		// add preset factions from formlist to list
		factions := ElementByPath(formlist, 'FormIDs');

		for i := 0 to ElementCount(factions) - 1 do begin

			// check fo
			if Signature(LinksTo(ElementByIndex(factions, i))) <> 'FACT' then begin

				AddMessage(#13#10 + '-------------------------------------------------------------------------------');
				AddMessage('Error: ' + Name(formlist) + ' must contain only FACT references!');
				AddMessage('-------------------------------------------------------------------------------' + #13#10);

				exit;

			end;

			// add preset factions from formlist to list
			slFactions.Add(GetEditValue(ElementByIndex(factions, i)));

		end;

		// this could be simpler
		factions := ElementByPath(e, 'Factions');

		if ElementCount(factions) > 0 then begin

			// add existing factions to list
			for i := 0 to ElementCount(factions) - 1 do				
				slFactions.Add(GetEditValue(ElementByPath(ElementByIndex(factions, i), 'Faction')));
			
			// remove factions group to start fresh
			Remove(factions);
		
			// add factions group back
			factions := Add(e, 'Factions', true);
			
			// add some number of empty faction entries
			for i := 0 to slFactions.Count - 1 do
				faction := ElementAssign(factions, HighInteger, nil, false);
			
			// edit empty faction entries according to list
			factions := ElementByPath(e, 'Factions');
			
			for i := 0 to slFactions.Count - 1 do begin
			
				faction := ElementByIndex(factions, 0);
			
				SetEditValue( ElementByPath(faction, 'Faction'), slFactions[i] );
			
			end;
			
			// clear away null references
			factions := ElementByPath(e, 'Factions');
			
			for i := 0 to ElementCount(factions) - 1 do begin
			
				faction := ElementByIndex(factions, i);
			
				if CompareStr('NULL - Null Reference [00000000]', GetEditValue(ElementByPath(faction, 'Faction'))) = 0 then
					Remove(faction);
			
			end;
			
		end;

		// clear factions
		slFactions.Clear;

	end;

function Finalize: integer;
	begin
		Result := 1;
	end;

end.