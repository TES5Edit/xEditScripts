{
	Purpose: Keyword Search - Dialog Topic - NAM1
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	slResultsForms, slResultsModels: TStringList;
	sQuery: string;

function Initialize: integer;
	begin

		Result := 0;
		
		slResultsForms  := TStringList.Create;
		slResultsModels := TStringList.Create;
		slResultsModels.Sorted := True;
		slResultsModels.Duplicates := dupIgnore;
		
		if not InputQuery('Enter', 'Search Query:', sQuery) then begin
			Result := 1;
			exit;
		end; // end if
		
		if sQuery = '' then begin
			Result := 1;
			exit;
		end; // end if
		
		AddMessage('-------------------------------------------------------------------------------');
		
	end; // end begin

function Process(e: IInterface): integer;
	var
		RECORD_FORMID, MODEL_FILENAME: IInterface;
		sRecordFormID, sModelFilename: string;

	begin
		Result := 0;

		//if Signature(e) <> 'STAT' then
		//	exit;

		RECORD_FORMID  := ElementByPath(e, 'Record Header\FormID');
		MODEL_FILENAME := ElementByPath(e, 'Responses\Response\NAM1');

		sRecordFormID  := GetEditValue(RECORD_FORMID);
		sModelFilename := GetEditValue(MODEL_FILENAME);
			
		if pos(lowercase(sQuery), lowercase(sModelFilename)) > 0 then begin
			//AddMessage('Match: ' + sRecordFormID + '	' + sModelFilename);
			slResultsModels.Add(sRecordFormID);
		end;

	end;

function Finalize: integer;
	var
		i: integer;
	begin
	
		slResultsModels.Sort();
		
		//AddMessage('-------------------------------------------------------------------------------');
		
		for i := 0 to slResultsModels.Count - 1 do begin
		
			AddMessage(slResultsModels[i]);
		
		end;
		
		slResultsModels.Clear;
	
		AddMessage('-------------------------------------------------------------------------------');
		Result := 1;
	end;

end.
