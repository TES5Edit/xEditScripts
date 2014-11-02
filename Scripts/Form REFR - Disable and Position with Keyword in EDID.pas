{
	Purpose: Disable and Position with Keyword in EDID
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
		FORMID, NAME, GROUP, xesp: IInterface;
		sFormID, sName, sGroupFormID, sGroupEditorID, sGroupName: string;
		sPosX, sPosY, sPosZ, sRotX, sRotY, sRotZ: string;
		s: string;
		runOnce: integer;

	begin
		Result := 0;

		s := Signature(e);
		
		if (s <> 'ACHR') or (s <> 'REFR') then
			exit;

		FORMID  := FixedFormID(e);
		NAME	:= ElementByPath(e, 'EDID - Editor ID');

		sFormID := IntToHex(FORMID, 8);
		sName	:= GetEditValue(NAME);
		
		if pos(lowercase(sQuery), lowercase(sName)) > 0 then begin
			SetElementNativeValues(e, 'DATA\Position\Z', -30000);
			RemoveElement(e, 'Enable Parent');
			RemoveElement(e, 'XTEL');
			SetIsInitiallyDisabled(e, true);
			xesp := Add(e, 'XESP', true);
			if Assigned(xesp) then begin
				SetElementNativeValues(xesp, 'Reference', $14); // Player ref
				SetElementNativeValues(xesp, 'Flags', 1);  // opposite of parent flag
			end;
			//SetElementNativeValues(e, 'Record Header\Record Flags', GetElementNativeValues(e, 'Record Header\Record Flags') or 2048); // Flag: InitiallyDisabled
			
		end;

	end;

function Finalize: integer;
	begin
		AddMessage('-------------------------------------------------------------------------------');
		Result := 1;
	end;

end.
