{
	Purpose: Find Keyless Locked Doors (FLST)
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}
unit UserScript;

var
	slRefsDoors: TStringList;
	flstFile: iwbFile;
	rec, flstRefsDoors, flstRefsDoorsFormIDs: IInterface;
	i: integer;

function Initialize: integer;

	begin
		Result := 0;
		
		ClearMessages();
		
		slRefsDoors 	:= TStringList.Create;
		
		flstFile		:= FileByLoadOrder(StrToInt('$09'));
		flstRefsDoors 	:= RecordByFormID(flstFile, $09000800, false);
		
		flstRefsDoorsFormIDs := ElementByName(flstRefsDoors, 'FormIDs');

		if slRefsDoors.Count = 0 then begin

			if Assigned(flstRefsDoorsFormIDs) then begin

				for i := 0 to ElementCount(flstRefsDoorsFormIDs) - 1 do begin

					rec := LinksTo(ElementByIndex(flstRefsDoorsFormIDs, i));
					slRefsDoors.Add(GetElementEditValues(rec, 'EDID'));

				end;

			end;

		end;
		
		AddMessage(#13#10);
		
	end;

function Process(e: IInterface): integer;

	var
	
		name, key: string;

	begin
		Result := 0;	

		if Signature(e) <> 'REFR' then
			exit;
			
		name := GetElementEditValues(LinksTo(ElementByPath(e, 'NAME')), 'EDID');
		
		//AddMessage(name);
		
		for i := 0 to slRefsDoors.Count - 1 do begin
		
			if pos(slRefsDoors[i], name) > 0 then begin
			
				if Assigned(ElementByPath(e, 'XLOC')) then begin
				
					key := GetElementEditValues(e, 'XLOC\Key');
					
					if CompareStr(key, 'NULL - Null Reference [00000000]') = 0 then
						AddMessage('Locked/No Key:	' + GetElementEditValues(e, 'Record Header\FormID'));
				
				end;
			
			end;
		
		end;

	end;

function Finalize: integer;

	begin
		AddMessage(#13#10);
		Result := 1;
	end;

end.
