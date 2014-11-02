{
	Purpose: Copy, Edit, and Flag References (Dynamic Torches)
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1

	Instructions:
	1. Add origin references to slReferences (e.g., MSTT.)
	2. Add destination references to SetElementEditValues (e.g, ACTI.)
	3. Change the load order to the destination file. (Line 53)
	4. Apply Script on Cell or Worldspace.
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
		FORMID, NAME, GROUP: IInterface;
		sFormID, sName, sGroupFormID, sGroupEditorID, sGroupName: string;
		sPosX, sPosY, sPosZ, sRotX, sRotY, sRotZ: string;
		s: string;
		runOnce: integer;

	begin
		Result := 0;

		s := Signature(e);
		
		if (s <> 'ACHR') and (s <> 'REFR') then
			exit;

		FORMID  := FixedFormID(e);
		NAME	:= ElementByPath(e, 'NAME - Base');

		sFormID 		:= IntToHex(FORMID, 8);
		sName			:= GetEditValue(NAME);
		
		if pos(lowercase(sQuery), lowercase(sName)) > 0 then begin
			AddMessage('Removed: ' + sFormID + '	' + sName);
			RemoveNode(e);
		end;

	end;

function Finalize: integer;
	begin
		AddMessage('-------------------------------------------------------------------------------');
		Result := 1;
	end;

end.
