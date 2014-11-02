{
	Purpose: Sort FLST alphabetically
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	listUnsorted, listSorted: TStringList;
	i: integer;

// Called before processing
function Initialize: integer;
	begin
		listUnsorted := TStringList.Create;
		listSorted := TStringList.Create;
		listUnsorted.Sorted := True;
		listUnsorted.Duplicates := dupIgnore;
		listSorted.Sorted := True;
		listSorted.Duplicates := dupIgnore;
	end;

// called for every record selected in xEdit
function Process(e: IInterface): integer;
	var
		items, item, rec: IInterface;
		itemCount, itemCountNew: integer;

	begin
		Result := 0;

		rec := Signature(e);

		AddMessage('--------------------------------------------------------------------------------');
		AddMessage('Processing: ' + FullPath(e));
		AddMessage('--------------------------------------------------------------------------------');

		// Process FLST record
		if (rec = 'FLST') then begin

			items := ElementByName(e, 'FormIDs');
			itemCount := ElementCount(items);

			AddMessage('Items: ' + IntToStr(itemCount));

			// Create list of unsorted items
			for i := itemCount - 1 downto 0 do begin

				// Add items to TFormList
				item := GetEditValue(ElementByIndex(items, i));
				listUnsorted.Add(item);
				
				// Sort
				listUnsorted.Sort;
				
				// Remove items from FLST
				RemoveByIndex(items, i, true);

			end;

			// Create new list of sorted items
			for i := 0 to listUnsorted.Count - 1 do begin

				// Add items to TFormList
				listSorted.Add(listUnsorted[i]);

				// Add items to FLST
				items := ElementByPath(e, 'FormIDs');
				item := ElementAssign(items, HighInteger, nil, false);
				SetEditValue(item, listSorted[i]);

			end;
			
			listUnsorted.Clear;
			listSorted.Clear;
			
			// How many duplicates were removed?
			itemCountNew := ElementCount(items);
			if itemCountNew < itemCount then begin
				AddMessage('Duplicates Removed: ' + IntToStr(itemCount - itemCountNew));
			end;
			if itemCountNew > itemCount then begin
				AddMessage('Duplicates Removed: ' + IntToStr(itemCountNew - itemCount));
			end;
			if itemCountNew = itemCount then begin
				AddMessage('No duplicates found.');
			end;

		end;

	end;

// Cleanup
function Finalize: integer;
	begin
		AddMessage('--------------------------------------------------------------------------------');

		listUnsorted.Free;
		listSorted.Free;

		Result := 1;
	end;

end.
