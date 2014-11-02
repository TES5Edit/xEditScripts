{
	Purpose: List Tab-Delimited Data for AMMO, ARMO, COBJ, MISC, and WEAP Records
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1

	HOW TO USE:
	1. In Excel, create four worksheets named: Main, Keywords, Flags, and Components.
	2. Select any number of records of A SINGLE TYPE (e.g., AMMO, ARMO, COBJ) and apply the script.
	3. In the Messages tab, copy the respective datasets in reverse order (i.e., Components, Flags, Keywords, Main) to the respective worksheets.
	   NOTE: Reverse order is important because the Main worksheet will contain hyperlinks to the other worksheets and Excel is stupid.
	4. The Keywords, Flags, and Components links may not be formatted correctly but they will still work. To update the formatting:
		4a. Use the arrow keys to highlight the topmost links cell.
		4b. Press F2.
		4c. Press Enter.
		4d. Repeat until you're finished.
	5. Tell fireundubh how much you love and adore him for making you this script. Kneeling is optional but encouraged.
}

unit UserScript;

var
	slMaterials, slMaterialsAll, slKeywords, slKeywordsAll, slFlags, slFlagsAll, slRows: TStringList;
	i, x, z: integer;
	header: string;

function CountOccurences( const SubText: string; const Text: string): Integer;
begin
	Result := Pos(SubText, Text);
		if Result > 0 then
			Result := (Length(Text) - Length(StringReplace(Text, SubText, '', [rfReplaceAll]))) div  Length(subtext);
end;

function Initialize: integer;
begin

	Result := 0;

	slMaterials := TStringList.Create;
	slMaterials.Sorted := True;
	slMaterials.StrictDelimiter := False;

	slMaterialsAll := TStringList.Create;
	slMaterialsAll.Sorted := True;
	slMaterialsAll.StrictDelimiter := False;

	slKeywords := TStringList.Create;
	slKeywords.Sorted := True;
	slKeywords.StrictDelimiter := False;

	slKeywordsAll := TStringList.Create;
	slKeywordsAll.Sorted := True;
	slKeywordsAll.StrictDelimiter := False;

	slFlags := TStringList.Create;
	slFlags.Sorted := True;
	slFlags.StrictDelimiter := False;

	slFlagsAll := TStringList.Create;
	slFlagsAll.Sorted := True;
	slFlagsAll.StrictDelimiter := False;

	slRows := TStringList.Create;
	slRows.Sorted := True;
	slRows.StrictDelimiter := False;

	x := 0;
	z := 0;

	ClearMessages();

end;

function Process(e: IInterface): integer;
var
	list, listitem, item: IInterface;
	rec, formid, edid, bnam, cnam, nam1, full, weight, value, rating, eitm, damage, speed, reach, keywords, keyword, materials, material, flags, flag, count: string;
	linkMaterials, linkKeywords, linkFlags: string;
	row: string;
	ammo, armo, cobj, misc, weap: boolean;

begin

	Result := 0;

	rec := Signature(e);

	// Check record signature
	if (rec <> 'AMMO') and (rec <> 'ARMO') and (rec <> 'COBJ') and (rec <> 'MISC') and (rec <> 'WEAP') then begin
		AddMessage(#13#10 + '--------------------------------------------------------------------------------');
		AddMessage('One or more selected records was not a valid type. Terminating.');
		AddMessage('This script can be run on only AMMO, ARMO, COBJ, MISC, and WEAP records.');
		AddMessage('--------------------------------------------------------------------------------');
		exit;
	end;

	// Common elements
	formid	:= '0x' + IntToHex(FixedFormID(e),8);
	edid	:= GetEditValue(ElementBySignature(e, 'EDID'));

	if (rec = 'AMMO') then
		header	:= 'FormID	EDID	FULL	Damage	Value	Keywords	Flags';

	if (rec = 'ARMO') then
		header	:= 'FormID	EDID	FULL	Rating	Value	Weight	Object Effect	Keywords	Flags';

	if (rec = 'COBJ') then
		header	:= 'FormID	EDID	BNAM	NAM1	CNAM	Components';

	if (rec = 'MISC') then
		header	:= 'FormID	EDID	FULL	Value	Weight	Keywords	Flags';

	if (rec = 'WEAP') then
		header	:= 'FormID	EDID	FULL	Damage	Value	Weight	Speed	Reach	Object Effect	Keywords	Flags';

	// Other common elements
	if (rec = 'AMMO') or (rec = 'ARMO') or (rec = 'MISC') or (rec = 'WEAP') then begin
		full	:= GetElementEditValues(e, 'FULL');
		weight	:= GetElementEditValues(e, 'DATA\Weight');
		value	:= GetElementEditValues(e, 'DATA\Value');
	end;

	if (rec = 'ARMO') or (rec = 'WEAP') then
		eitm	:= GetElementEditValues(LinksTo(ElementBySignature(e, 'EITM')), 'EDID - Editor ID');

	// AMMO
	if (rec = 'AMMO') or (rec = 'WEAP') then
		damage := GetElementEditValues(e, 'DATA\Damage');

	// ARMO
	if (rec = 'ARMO') then
		rating	:= GetElementEditValues(e, 'DNAM');

	// COBJ
	if (rec = 'COBJ') then begin
		bnam	:= GetElementEditValues(LinksTo(ElementBySignature(e, 'BNAM')), 'EDID - Editor ID');
		nam1	:= GetElementEditValues(e, 'NAM1');
		cnam	:= GetElementEditValues(LinksTo(ElementBySignature(e, 'CNAM')), 'EDID - Editor ID');
	end;

	// WEAP
	if (rec = 'WEAP') then begin
		speed := GetElementEditValues(e, 'DNAM\Speed');
		reach := GetElementEditValues(e, 'DNAM\Reach');
	end;

	// Constructible Object Requirements
	if (rec = 'COBJ') then begin

		list	:= ElementByName(e, 'Items');
		if ElementCount(list) > 0 then begin

			for i := 0 to ElementCount(list) - 1 do begin

				listitem	:= ElementByIndex(list, i);
				count		:= GetEditValue(ElementByPath(listitem, 'CNTO\Count'));
				listitem	:= LinksTo(ElementByPath(listitem, 'CNTO\Item'));
				material	:= GetElementEditValues(listitem, 'EDID');
				slMaterials.Add(count + '	' + material);

			end;

			// Save materials as a comma-delimited list
			materials := slMaterials.CommaText;

			// Convert commas to tabs
			materials := StringReplace(materials, ',', '	', [rfReplaceAll, rfIgnoreCase]);

			// Strip quotation marks from strings
			materials := StringReplace(materials, '"', '', [rfReplaceAll, rfIgnoreCase]);

			// Add each record's materials to slMaterialsAll
			slMaterialsAll.Add(formid + '	' + materials);

		end;

		// Create link for Excel
		linkMaterials := '=HYPERLINK("#''Components''!"&ADDRESS(MATCH(INDIRECT(ADDRESS(ROW(), COLUMN()-5,4)), Components!$A:$A, 0), 1), "Link")';

	end;

	// Keywords and Record Flags
	if (rec = 'AMMO') or (rec = 'ARMO') or (rec = 'MISC') or (rec = 'WEAP') then begin

		// Get a list of keywords
		list	:= ElementByName(e, 'KWDA - Keywords');
		if ElementCount(list) > 0 then begin

			for i := 0 to ElementCount(list) - 1 do begin

				listitem 	:= LinksTo(ElementByIndex(list, i));
				keyword 	:= GetEditValue(ElementBySignature(listitem, 'EDID'));
				slKeywords.Add(keyword);

			end;

			// Save keywords as a comma-delimited list
			keywords := slKeywords.CommaText;

			// Convert commas to tabs
			keywords := StringReplace(keywords, ',', '	', [rfReplaceAll, rfIgnoreCase]);

			// Add each record's keywords to slKeywordsAll
			slKeywordsAll.Add(formid + '	' + keywords);

		end;

		// Create link for Excel
		if (rec = 'AMMO') or (rec = 'MISC') then
			linkKeywords := '=HYPERLINK("#''Keywords''!"&ADDRESS(MATCH(INDIRECT(ADDRESS(ROW(), COLUMN()-5,4)), Keywords!$A:$A, 0), 1), "Link")';

		if (rec = 'ARMO') then
			linkKeywords := '=HYPERLINK("#''Keywords''!"&ADDRESS(MATCH(INDIRECT(ADDRESS(ROW(), COLUMN()-7,4)), Keywords!$A:$A, 0), 1), "Link")';

		if (rec = 'WEAP') then
			linkKeywords := '=HYPERLINK("#''Keywords''!"&ADDRESS(MATCH(INDIRECT(ADDRESS(ROW(), COLUMN()-9,4)), Keywords!$A:$A, 0), 1), "Link")';

		// Get a list of record flags
		list	:= ElementByPath(e, 'Record Header\Record Flags');
		if ElementCount(list) > 0 then begin

			for i := 0 to ElementCount(list) - 1 do begin
				listitem 	:= ElementByIndex(list, i);
				flag 		:= Name(listitem);
				slFlags.Add(flag);
			end;

			// Save flags as a comma-delimited list
			flags := slFlags.CommaText;

			// Convert commas to tabs
			flags := StringReplace(flags, ',', '	', [rfReplaceAll, rfIgnoreCase]);

			// Strip quotation marks from strings
			flags := StringReplace(flags, '"', '', [rfReplaceAll, rfIgnoreCase]);

			// Add each record's flags to slFlagsAll
			slFlagsAll.Add(formid + '	' + flags);

		end;

		// Create link for Excel
		if (rec = 'AMMO') or (rec = 'MISC') then
			linkFlags := '=HYPERLINK("#''Flags''!"&ADDRESS(MATCH(INDIRECT(ADDRESS(ROW(), COLUMN()-6,4)), Flags!$A:$A, 0), 1), "Link")';

		if (rec = 'ARMO') then
			linkFlags := '=HYPERLINK("#''Flags''!"&ADDRESS(MATCH(INDIRECT(ADDRESS(ROW(), COLUMN()-8,4)), Flags!$A:$A, 0), 1), "Link")';

		if (rec = 'WEAP') then
			linkFlags := '=HYPERLINK("#''Flags''!"&ADDRESS(MATCH(INDIRECT(ADDRESS(ROW(), COLUMN()-10,4)), Flags!$A:$A, 0), 1), "Link")';

	end;

	// Concatenate data
	if (rec = 'AMMO') then
		row := formid + #9 + edid + #9 + full + '	' + damage + '	' + value;

	if (rec = 'ARMO') then
		row := formid + #9 + edid + #9 + full + '	' + rating + '	' + value + '	' + weight + '	' + eitm;

	if (rec = 'COBJ') then
		row := formid + #9 + edid + #9 + bnam + '	' + nam1 + '	' + cnam;

	if (rec = 'MISC') then
		row := formid + #9 + edid + #9 + full + '	' + value + '	' + weight;

	if (rec = 'WEAP') then
		row := formid + #9 + edid + #9 + full + '	' + damage + '	' + value + '	' + weight + '	' + speed + '	' + reach + '	' + eitm;

	// Materials
	if slMaterials.Count > 0 then
		row := row + #9 + linkMaterials
	else
		row := row + #9 + '';

	// Keywords
	if slKeywords.Count > 0 then
		row := row + #9 + linkKeywords
	else
		row := row + #9 + '';

	// Flags
	if slFlags.Count > 0 then
		row := row + #9 + linkFlags
	else
		row := row + #9 + '';

	// Remove leading and trailing whitespace
	row := Trim(row);

	// Add rows to slRows
	slRows.Add(row);

	// Clear slMaterials to prevent duplication
	slMaterials.Clear;

	// Clear slKeywords to prevent duplication
	slKeywords.Clear;

	// Clear slFlags to prevent duplication
	slFlags.Clear;

end;

function Finalize: integer;
begin

	// Output main rows
	if slRows.Count > 0 then begin

		AddMessage(#13#10 + '---------------------------------- MAIN ------------------------------------');
		AddMessage(header);

		for i := 0 to slRows.Count - 1 do begin

			AddMessage(slRows[i]);

		end;

	end;

	// Output material rows
	if slMaterialsAll.Count > 0 then begin

		header := 'FormID	';
		x := 0;
		z := 0;

		AddMessage(#13#10 + '------------------------------- COMPONENTS ---------------------------------');

		for i := 0 to slMaterialsAll.Count - 1 do begin

			x := CountOccurences(#9, slMaterialsAll[i]) / 2;
			if x > z then
				z := x;

		end;

		for i := 0 to z - 1 do begin

			header := header + 'Qty	Component	';

		end;

		AddMessage(header);

		for i := 0 to slMaterialsAll.Count - 1 do begin

			AddMessage(slMaterialsAll[i]);

		end;

	end;

	// Output keyword rows
	if slKeywordsAll.Count > 0 then begin

		header := 'FormID	';
		x := 0;
		z := 0;

		AddMessage(#13#10 + '-------------------------------- KEYWORDS ----------------------------------');

		for i := 0 to slKeywordsAll.Count - 1 do begin

			x := CountOccurences(#9, slKeywordsAll[i]);
			if x > z then
				z := x;

		end;

		for i := 0 to z - 1 do begin

			header := header + 'Keyword	';

		end;

		AddMessage(header);

		for i := 0 to slKeywordsAll.Count - 1 do begin

			AddMessage(slKeywordsAll[i]);

		end;

	end;

	// Output flag rows
	if slFlagsAll.Count > 0 then begin

		header := 'FormID	';
		x := 0;
		z := 0;

		AddMessage(#13#10 + '---------------------------------- FLAGS -----------------------------------');

		for i := 0 to slFlagsAll.Count - 1 do begin

			x := CountOccurences(#9, slFlagsAll[i]);
			if x > z then
				z := x;

		end;

		for i := 0 to z - 1 do begin

			header := header + 'Flag	';

		end;

		AddMessage(header);

		for i := 0 to slFlagsAll.Count - 1 do begin

			AddMessage(slFlagsAll[i]);

		end;

	end;

	AddMessage(#13#10 + '================================================================================');
	AddMessage('Report bugs to: fireundubh@gmail.com');
	AddMessage('================================================================================' + #13#10);

	// Release TStringLists from memory
	slMaterials.Free;
	slMaterialsAll.Free;
	slKeywords.Free;
	slKeywordsAll.Free;
	slFlags.Free;
	slFlagsAll.Free;

	// Exit
	Result := 1;

end;

end.
