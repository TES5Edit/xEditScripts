{
	Purpose: Add Keywords from Formlist
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	slKeywordsToAdd, slKeywordsToFilter, slKeywordsToDelete: TStringList;
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
		formlist     := RecordByFormID(fileFormList, StrToInt('$' + s), true);

		slKeywordsToAdd := TStringList.Create;
		slKeywordsToFilter := TStringList.Create;
		slKeywordsToDelete := TStringList.Create;

	end;

function Process(e: IInterface): integer;
	var
		keywordsToAdd, keywordsToFilter, keywords, keyword, listitem: IInterface;

	begin
		Result := 0;

		AddMessage('Processing:' + FullPath(e));

		keywords := ElementByPath(e, 'KWDA');
		if ElementCount(keywords) = 0 then
			Remove(keywords);

		// add keywords to add from formlist to a formlist
		keywordsToAdd := ElementByPath(formlist, 'FormIDs');

		for i := 0 to ElementCount(keywordsToAdd) - 1 do begin

			if Signature(LinksTo(ElementByIndex(keywordsToAdd, i))) <> 'KYWD' then begin
				AddMessage(#13#10 + '-------------------------------------------------------------------------------');
				AddMessage('Error: ' + Name(formlist) + ' must contain only KYWD references!');
				AddMessage('-------------------------------------------------------------------------------' + #13#10);
				exit;
			end;

			slKeywordsToAdd.Add( GetEditValue(ElementByIndex(keywordsToAdd, i)) );

		end;

		// filter existing keywords from a formlist
		keywordsToFilter := ElementByPath(e, 'KWDA');

		if ElementCount(keywordsToFilter) > 0 then begin

			for j := 0 to ElementCount(keywordsToFilter) - 1 do
				slKeywordsToFilter.Add( GetEditValue(ElementByIndex(keywordsToFilter, j)) );

			for k := slKeywordsToAdd.Count - 1 downto 0 do begin

				for l := slKeywordsToFilter.Count - 1 downto 0 do begin

					if CompareStr(slKeywordsToFilter[l], slKeywordsToAdd[k]) = 0 then
						slKeywordsToDelete.Add(IntToStr(k));

				end;

			end;
			
			for o := 0 to slKeywordsToDelete.Count - 1 do begin

				slKeywordsToAdd.Delete(StrToInt(slKeywordsToDelete[o]));

			end;

		end;

		// add filtered list of keywords to record
		keywords := ElementByPath(e, 'KWDA');
		
		if not Assigned(ElementByPath(e, 'KWDA')) then
			keywords := Add(e, 'KWDA', true);			

		if slKeywordsToAdd.Count > 0 then begin

			for m := 0 to slKeywordsToAdd.Count - 1 do begin

				keyword := ElementAssign(keywords, 0, ElementByPath(keywords, 'Keyword'), false);

				SetEditValue(keyword, slKeywordsToAdd[m]);

				AddMessage('Added Keyword: ' + slKeywordsToAdd[m]);

			end;

		end;

		// remove null references
		keywords := ElementByPath(e, 'KWDA');
		for n := 0 to ElementCount(keywords) - 1 do begin

			if CompareStr('NULL - Null Reference [00000000]', GetEditValue(ElementByIndex(keywords, n))) = 0 then
				Remove(ElementByIndex(keywords, n));

		end;

		AddMessage('');
		
		slKeywordsToAdd.Clear;
		slKeywordsToFilter.Clear;
		slKeywordsToDelete.Clear;

	end;

function Finalize: integer;

	begin

		Result := 1;

	end;

end.
