{
	Purpose: Reference - Change Lock Level
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	slResults: TStringList;
	sQuery: string;

function Initialize: integer;
	begin

		Result := 0;
		
		slResults := TStringList.Create;
		slResults.Sorted := True;
		slResults.Duplicates := dupIgnore;
		
		if not InputQuery('Enter', 'Lock Level:', sQuery) then begin
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
		FORMID, NAME, GROUP, LOCKLEVEL, KEY: IInterface;
		sFormID, sName, sGroupFormID, sGroupEditorID, sGroupName: string;
		sPosX, sPosY, sPosZ, sRotX, sRotY, sRotZ: string;
		s: string;
		runOnce: integer;

	begin
		Result := 0;

		s := Signature(e);

		if (s <> 'ACHR') and (s <> 'REFR') then
			exit;

		if not (ElementExists(e, 'XLOC - Lock Data')) then
			exit;

		FORMID    := FixedFormID(e);
		LOCKLEVEL := ElementByPath(e, 'XLOC - Lock Data\Level');
		KEY       := ElementByPath(e, 'XLOC - Lock Data\Key');
		
		if not (ElementExists(e, 'XLOC - Lock Data\Key')) or (pos('NULL', GetEditValue(KEY)) > 0) then begin
			SetEditValue(LOCKLEVEL, sQuery);
			AddMessage('Modified: ' + IntToHex(FORMID, 8) + '	' + GetEditValue(LOCKLEVEL));
		end;

	end;

function Finalize: integer;
	begin
		AddMessage('-------------------------------------------------------------------------------');
		Result := 1;
	end;

end.
