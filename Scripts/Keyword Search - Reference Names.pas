{
	Purpose: Keyword Search - Reference Names
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
		AddMessage('Form ID' + '	' + 'Group Editor ID' + '	' + 'Group Form ID' + '	' + 'Result' + '	' + 'Pos X' + '	' + 'Pos Y' + '	' + 'Pos Z' + '	' + 'Rot X' + '	' + 'Rot Y' + '	' + 'Rot Z');
		
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
		GROUP	:= GetContainer(e);
		while Assigned(GROUP) and (ElementType(GROUP) <> etGroupRecord) do
			GROUP := GetContainer(GROUP);
		
		if not Assigned(GROUP) then begin
			AddMessage('Group not assigned');
			exit;
		end;
			
		GROUP := ChildrenOf(GROUP);
		
		if not Assigned(GROUP) then begin
			AddMessage('Child group not assigned');
			exit;
		end;

		sFormID 		:= IntToHex(FORMID, 8);
		sName			:= GetEditValue(NAME);
		sPosX			:= IntToStr(GetNativeValue(ElementByPath(e, 'DATA\Position\X')));
		sPosY			:= IntToStr(GetNativeValue(ElementByPath(e, 'DATA\Position\Y')));
		sPosZ			:= IntToStr(GetNativeValue(ElementByPath(e, 'DATA\Position\Z')));
		sRotX			:= IntToStr(GetNativeValue(ElementByPath(e, 'DATA\Rotation\X')));
		sRotY			:= IntToStr(GetNativeValue(ElementByPath(e, 'DATA\Rotation\Y')));
		sRotZ			:= IntToStr(GetNativeValue(ElementByPath(e, 'DATA\Rotation\Z')));
		sGroupFormID	:= IntToHex(FixedFormID(GROUP), 8);
		sGroupEditorID	:= GetElementEditValues(GROUP, 'EDID');
		sGroupName		:= GetElementEditValues(GROUP, 'FULL');
		
		if pos(lowercase(sQuery), lowercase(sName)) > 0 then begin
			AddMessage('0x' + sFormID + '	' + sGroupEditorID + '	0x' + sGroupFormID + '	' + sName + '	' + sPosX + '	' + sPosY + '	' + sPosZ + '	' + sRotX + '	' + sRotY + '	' + sRotZ);
			slResults.Add(sName);
		end;

	end;

function Finalize: integer;
	var
		i: integer;
	begin
	
		slResults.Sort();
		
		AddMessage('-------------------------------------------------------------------------------');
		
		for i := 0 to slResults.Count - 1 do begin
		
			AddMessage(slResults[i]);
		
		end;
		
		slResults.Clear;
	
		AddMessage('-------------------------------------------------------------------------------');
		Result := 1;
	end;

end.
