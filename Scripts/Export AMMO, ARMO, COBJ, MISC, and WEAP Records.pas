{
	Purpose: Export AMMO, ARMO, COBJ, MISC, and WEAP Records
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1

	HOW TO USE:
	1. In Excel, create four worksheets named: Main, Keywords, Flags, and Components.
	2. Select any number of records of A SINGLE TYPE (e.g., AMMO, ARMO, COBJ) and apply the script.
	3. Import each CSV in reverse order into the respective Excel worksheets.
	   NOTE: Reverse order is important because the Main worksheet will contain hyperlinks to the other worksheets and Excel is stupid.
	4. The Keywords, Flags, and Components links may not be formatted correctly but they will still work. To update the formatting:
		4a. Use the arrow keys to highlight the topmost unformatted links cell.
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

	ClearMessages(); // TES5Edit v3.0.33
	
	slMaterials := TStringList.Create;
	slMaterials.Delimiter := ';';
	slMaterials.StrictDelimiter := True;

	slMaterialsAll := TStringList.Create;
	slMaterialsAll.Delimiter := ';';
	slMaterialsAll.StrictDelimiter := True;

	slKeywords := TStringList.Create;
	slKeywords.Delimiter := ';';
	slKeywords.StrictDelimiter := True;

	slKeywordsAll := TStringList.Create;
	slKeywordsAll.Delimiter := ';';
	slKeywordsAll.StrictDelimiter := True;

	slFlags := TStringList.Create;
	slFlags.Delimiter := ';';
	slFlags.StrictDelimiter := True;

	slFlagsAll := TStringList.Create;
	slFlagsAll.Delimiter := ';';
	slFlagsAll.StrictDelimiter := True;

	slRows := TStringList.Create;
	slRows.Delimiter := ';';
	slRows.StrictDelimiter := True;

	x := 0;
	z := 0;

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
		header	:= 'FormID;EDID;FULL;Damage;Value;Keywords;Flags';
		
	if (rec = 'ARMO') then
		header	:= 'FormID;EDID;FULL;Rating;Value;Weight;Object Effect;Keywords;Flags';

	if (rec = 'COBJ') then
		header	:= 'FormID;EDID;BNAM;NAM1;CNAM;Components';

	if (rec = 'MISC') then
		header	:= 'FormID;EDID;FULL;Value;Weight;Keywords;Flags';

	if (rec = 'WEAP') then
		header	:= 'FormID;EDID;FULL;Damage;Value;Weight;Speed;Reach;Object Effect;Keywords;Flags';
	
	header := StringReplace(header, ';', #9, [rfReplaceAll, rfIgnoreCase]);
	
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
		//cnam	:= GetElementEditValues(LinksTo(ElementBySignature(e, 'CNAM')), 'EDID - Editor ID');
		cnam	:= GetElementEditValues(LinksTo(ElementBySignature(e, 'CNAM')), 'FULL');
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
				material	:= GetElementEditValues(listitem, 'FULL'); // default: EDID
				slMaterials.Add(count + ';' + material);

			end;

			// Save materials as a delimited list
			materials := slMaterials.DelimitedText;

			// Strip quotation marks from strings
			materials := StringReplace(materials, '"', '', [rfReplaceAll, rfIgnoreCase]);
			
			// Replace semicolons with tabs
			materials := StringReplace(materials, ';', #9, [rfReplaceAll, rfIgnoreCase]);

			// Add each record's materials to slMaterialsAll
			slMaterialsAll.Add(formid + #9 + materials);

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

			// Save keywords as a delimited list
			keywords := slKeywords.DelimitedText;
			
			// Replace semicolons with tabs
			keywords := StringReplace(keywords, ';', #9, [rfReplaceAll, rfIgnoreCase]);

			// Add each record's keywords to slKeywordsAll
			slKeywordsAll.Add(formid + #9 + keywords);

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

			// Save flags as a delimited list
			flags := slFlags.DelimitedText;

			// Strip quotation marks from strings
			flags := StringReplace(flags, '"', '', [rfReplaceAll, rfIgnoreCase]);
			
			// Replace semicolons with tabs
			flags := StringReplace(flags, ';', #9, [rfReplaceAll, rfIgnoreCase]);

			// Add each record's flags to slFlagsAll
			slFlagsAll.Add(formid + #9 + flags);

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
		row := formid + ';' + edid + ';' + full + ';' + damage + ';' + value;

	if (rec = 'ARMO') then
		row := formid + ';' + edid + ';' + full + ';' + rating + ';' + value + ';' + weight + ';' + eitm;

	if (rec = 'COBJ') then
		row := formid + ';' + edid + ';' + bnam + ';' + nam1 + ';' + cnam;

	if (rec = 'MISC') then
		row := formid + ';' + edid + ';' + full + ';' + value + ';' + weight;

	if (rec = 'WEAP') then
		row := formid + ';' + edid + ';' + full + ';' + damage + ';' + value + ';' + weight + ';' + speed + ';' + reach + ';' + eitm;

	// Materials
	if slMaterials.Count > 0 then
		row := row + ';' + linkMaterials
	else
		row := row + ';';

	// Keywords
	if slKeywords.Count > 0 then
		row := row + linkKeywords
	else
		row := row + ';';

	// Flags
	if slFlags.Count > 0 then
		row := row + ';' + linkFlags
	else
		row := row + ';';

	// Replace semicolons with tabs
	row := StringReplace(row, ';', #9, [rfReplaceAll, rfIgnoreCase]);
		
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
var
	s: string;
	dlgSave: TSaveDialog;
	slImportRows, slImportMaterials, slImportKeywords, slImportFlags: IInterface;
begin

	// Output main rows
	if (slRows.Count > 0) then begin

		slRows.Insert(0, header);
	
		// ask for file to export to
		dlgSave := TSaveDialog.Create(nil);
		dlgSave.Options := dlgSave.Options + [ofOverwritePrompt];
		dlgSave.Filter := 'Spreadsheet files (*.csv)|*.csv';
		dlgSave.InitialDir := ProgramPath;
		dlgSave.FileName := 'fireundubh\dubhMain.csv';
		if dlgSave.Execute then
			slRows.SaveToFile(dlgSave.FileName);
		dlgSave.Free;

	end;

	// Output material rows
	if (slMaterialsAll.Count > 0) then begin

		header := 'FormID';
		x := 0;
		z := 0;

		for i := 0 to slMaterialsAll.Count - 1 do begin

			x := CountOccurences(#9, slMaterialsAll[i]) / 2;
			if x > z then
				z := x;

		end;

		for i := 0 to z - 1 do begin

			header := header + #9 + 'Qty' + #9 + 'Component';

		end;
		
		slMaterialsAll.Insert(0, header);

		// ask for file to export to
		dlgSave := TSaveDialog.Create(nil);
		dlgSave.Options := dlgSave.Options + [ofOverwritePrompt];
		dlgSave.Filter := 'Spreadsheet files (*.csv)|*.csv';
		dlgSave.InitialDir := ProgramPath;
		dlgSave.FileName := 'fireundubh\dubhComponents.csv';
		if dlgSave.Execute then
			slMaterialsAll.SaveToFile(dlgSave.FileName);
		dlgSave.Free;

	end;

	// Output keyword rows
	if (slKeywordsAll.Count > 0) then begin

		x := 0;
		z := 0;

		for i := 0 to slKeywordsAll.Count - 1 do begin

			x := CountOccurences(#9, slKeywordsAll[i]);
			if x > z then
				z := x;

		end;

		header := 'FormID';
		for i := 0 to z - 1 do begin

			header := header + #9 + 'Keyword';

		end;
		
		slKeywordsAll.Insert(0, header);

		// ask for file to export to
		dlgSave := TSaveDialog.Create(nil);
		dlgSave.Options := dlgSave.Options + [ofOverwritePrompt];
		dlgSave.Filter := 'Spreadsheet files (*.csv)|*.csv';
		dlgSave.InitialDir := ProgramPath;
		dlgSave.FileName := 'fireundubh\dubhKeywords.csv';
		if dlgSave.Execute then
			slKeywordsAll.SaveToFile(dlgSave.FileName);
		dlgSave.Free;

	end;

	// Output flag rows
	if (slFlagsAll.Count > 0) then begin

		x := 0;
		z := 0;

		for i := 0 to slFlagsAll.Count - 1 do begin

			x := CountOccurences(#9, slFlagsAll[i]);
			if x > z then
				z := x;

		end;

		header := 'FormID';
		for i := 0 to z - 1 do begin

			header := header + #9 + 'Flag';

		end;
		
		slFlagsAll.Insert(0, header);

		// ask for file to export to
		dlgSave := TSaveDialog.Create(nil);
		dlgSave.Options := dlgSave.Options + [ofOverwritePrompt];
		dlgSave.Filter := 'Spreadsheet files (*.csv)|*.csv';
		dlgSave.InitialDir := ProgramPath;
		dlgSave.FileName := 'fireundubh\dubhFlags.csv';
		if dlgSave.Execute then
			slFlagsAll.SaveToFile(dlgSave.FileName);
		dlgSave.Free;

	end;

	// Exit
	Result := 1;

end;

end.
