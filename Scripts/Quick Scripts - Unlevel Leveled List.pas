{
	Purpose: Unlevel/Relevel Leveled Lists
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	slParentElements: TStringList;
	sTargetLevel: string;
	bDebug: bool;

//============================================================================
function Initialize: integer;

	begin

		bDebug := true;

		slParentElements := TStringList.Create;

		if not InputQuery('Enter', 'Target Level:', sTargetLevel) then begin
			Result := 1;
			exit;
		end;

		if bDebug then begin
			ClearMessages();
			AddMessage('Applying script...' + #13#10);
		end;

	end;

//============================================================================
function Process(e: IInterface): integer;

	var
		h, i, j, k: integer;
		L0, L1, L2, L3: IInterface;
		s: string;

	begin

		slParentElements.Clear;

		// signature check
		if (Signature(e) = 'LVLI') or (Signature(e) = 'LVLN') or (Signature(e) = 'LVSP') then
			slParentElements.Add('Leveled List Entries')
		else
			exit;

		// -------------------------------------------------------------------------------
		for h := 0 to slParentElements.Count - 1 do begin

			// level 1
			L0 := ElementByPath(e, slParentElements[h]);

			// -------------------------------------------------------------------------------
			for i := 0 to ElementCount(L0) - 1 do begin

				// level 2
				L1 := ElementByIndex(L0, i);

				// -------------------------------------------------------------------------------
				for j := 0 to ElementCount(L1) - 1 do begin

					// level 3
					L2 := ElementByIndex(L1, j);

					// -------------------------------------------------------------------------------
					for k := 0 to ElementCount(L2) - 1 do begin

						// level 4
						L3 := ElementByIndex(L2, k);

						if CompareStr(Name(L3), 'Level') = 0 then begin

							if GetEditValue(L3) <> sTargetLevel then begin

								if bDebug then
									s := GetEditValue(L3);

								SetEditValue(L3, sTargetLevel);

								if bDebug then
									AddMessage('Updated: ' + GetElementEditValues(L2, 'Reference') + #13#10 + 'New Level: ' + GetEditValue(L3) + ' (Old Level: ' + s + ')' + #13#10);

							end; // end if - level comparison

						end; // end if - path comparison

					end; // end for - level 4

				end; // end for - level 3

			end; // end for - level 2

		end; // end for - level 1

		slParentElements.Clear;

	end;

//============================================================================
function Finalize: integer;

	begin

		Result := 1;
		exit;

	end;

end.
