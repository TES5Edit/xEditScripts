{
	Purpose: Recount KSIZ, COCT, LLCT, PKCU, PRKZ, SPCT, INAM, and QNAM subrecords
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	rec, temp: IInterface;
	plugin, sRecord, iOldValue, iNewValue, iDiff: string;
	sKSIZ, sCOCT, sLLCT, sPKCU, sPRKZ, sSPCT, sINAM, sQNAM: string;
	sKWDA, sList, sValues, sEffects: string;

function Process(e: IInterface): integer;
	begin
		Result := 0;

		plugin := Name(GetFile(e));
		
		sRecord := Signature(e);
		
		sKSIZ := 'KSIZ - Keyword Count';
			sKWDA := 'KWDA - Keywords';
		sCOCT := 'COCT - Count';
		sLLCT := 'LLCT - Count';
			sList := 'Leveled List Entries';
		sPKCU := 'PKCU - Counter\Data Input Count';
			sValues := 'Package Data\Data Input Values';
		sPRKZ := 'PRKZ - Perk Count';
		sSPCT := 'SPCT - Count';
			sEffects := 'Actor Effects';
		sINAM := 'INAM - Action Count';
		sQNAM := 'QNAM - Quest Count';
		
		// ----------------------------------------------------------------------------------
		// ALCH, ARMO, AMMO, BOOK, FURN, INGR, KEYM, LCTN, MGEF, MISC, RACE, SCRL, SLGM, WEAP
		// ----------------------------------------------------------------------------------
		if (sRecord = 'ALCH') or (sRecord = 'ARMO') or (sRecord = 'AMMO') or (sRecord = 'BOOK') or (sRecord = 'FURN') or (sRecord = 'INGR') or (sRecord = 'KEYM') or (sRecord = 'LCTN') or (sRecord = 'MGEF') or (sRecord = 'MISC') or (sRecord = 'RACE') or (sRecord = 'SCRL') or (sRecord = 'SLGM') or (sRecord = 'WEAP') then begin
			
			if IsEditable(e) and not GetIsDeleted(e) then begin
			
				// Check if the element exists and add if necessary
				if ElementCount(ElementByName(e, sKWDA)) > 0 then begin
					if not Assigned(ElementByName(e, sKSIZ)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (' + sKSIZ + ') does not exist. Adding...');
						Add(e, 'KSIZ', true);
					end;
				end;
				
				// Update element
				if (GetElementNativeValues(e, sKSIZ) <> ElementCount(ElementByName(e, sKWDA))) then begin
					iOldValue := GetElementNativeValues(e, sKSIZ);
					iNewValue := ElementCount(ElementByName(e, sKWDA));
					iDiff := (iNewValue - iOldValue);
					SetElementNativeValues(e, sKSIZ, ElementCount(ElementByName(e, sKWDA)));
					AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] Updated (' + sKSIZ + ') from ' + iOldValue + ' to ' + iNewValue + ' (Diff: ' + iDiff + ')');
				end;
				
				// Check if the element exists and remove if necessary
				if ElementCount(ElementByName(e, sKWDA)) = 0 then begin
					if Assigned(ElementByName(e, sKSIZ)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (' + sKSIZ + ') should be cleansed. Removing...');
						RemoveElement(e, 'KSIZ');
					end;
					if Assigned(ElementByName(e, sKWDA)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (' + sKWDA + ') should be cleansed. Removing...');
						RemoveElement(e, 'KWDA');
					end;
				end;
			
			end;
			
		end;
		
		// ----------------------------------------------------------------------------------
		// COBJ, CONT
		// ----------------------------------------------------------------------------------
		if (sRecord = 'COBJ') or (sRecord = 'CONT') then begin
			
			if IsEditable(e) and not GetIsDeleted(e) then begin
			
				// Check if the element exists and add if necessary
				if ElementCount(ElementByName(e, 'Items')) > 0 then begin
					if not Assigned(ElementByName(e, sCOCT)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (' + sCOCT + ') does not exist. Adding...');
						Add(e, 'COCT', true);
					end;
				end;
				
				// Update element
				if (GetElementNativeValues(e, sCOCT) <> ElementCount(ElementByName(e, 'Items'))) then begin
					iOldValue := GetElementNativeValues(e, sCOCT);
					iNewValue := ElementCount(ElementByName(e, 'Items'));
					iDiff := (iNewValue - iOldValue);
					SetElementNativeValues(e, sCOCT, ElementCount(ElementByName(e, 'Items')));
					AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] Updated (' + sCOCT + ') from ' + iOldValue + ' to ' + iNewValue + ' (Diff: ' + iDiff + ')');
				end;
				
				// Check if the element exists and add if necessary
				if ElementCount(ElementByName(e, 'Items')) = 0 then begin
					if Assigned(ElementByName(e, sCOCT)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (' + sCOCT + ') should be cleansed. Removing...');
						RemoveElement(e, 'COCT');
					end;
					if Assigned(ElementByName(e, 'Items')) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (Items) should be cleansed. Removing...');
						RemoveElement(e, 'Items');
					end;
				end;
			
			end;

		end;
		
		// ----------------------------------------------------------------------------------
		// LVLI, LVLN, LVSP
		// ----------------------------------------------------------------------------------
		if (sRecord = 'LVLI') or (sRecord = 'LVLN') or (sRecord = 'LVSP') then begin
		
			if IsEditable(e) and not GetIsDeleted(e) then begin
			
				// Check if the element exists and add if necessary
				if ElementCount(ElementByName(e, sList)) > 0 then begin
					if not Assigned(ElementByName(e, sLLCT)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (' + sLLCT + ') does not exist. Adding...');
						Add(e, 'LLCT', true);
					end;
				end;
				
				// Update element
				if (GetElementNativeValues(e, sLLCT) <> ElementCount(ElementByName(e, sList))) then begin
					iOldValue := GetElementNativeValues(e, sLLCT);
					iNewValue := ElementCount(ElementByName(e, sList));
					iDiff := (iNewValue - iOldValue);
					SetElementNativeValues(e, sLLCT, ElementCount(ElementByName(e, sList)));
					AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] Updated (' + sLLCT + ') from ' + iOldValue + ' to ' + iNewValue + ' (Diff: ' + iDiff + ')');
				end;
				
				// Check if the element exists and remove if necessary
				if ElementCount(ElementByName(e, sList)) = 0 then begin
					if Assigned(ElementByName(e, sLLCT)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (' + sLLCT + ') should be cleansed. Removing...');
						RemoveElement(e, 'LLCT');
					end;
					if Assigned(ElementByName(e, sList)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (' + sList + ') should be cleansed. Removing...');
						RemoveElement(e, sList);
					end;
				end;
			
			end;
			
		end;
		
		// ----------------------------------------------------------------------------------
		// NPC_
		// ----------------------------------------------------------------------------------
		if (sRecord = 'NPC_') then begin
			
			if IsEditable(e) and not GetIsDeleted(e) then begin
			
				// ----------------------------------------------------------------------------------
				// SPCT
				// ----------------------------------------------------------------------------------
				// Check if the element exists and add if necessary
				if ElementCount(ElementByName(e, sEffects)) > 0 then begin
					if not Assigned(ElementByName(e, 'SPCT - Count')) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (' + sSPCT + ') does not exist. Adding...');
						Add(e, 'SPCT', true);
					end;
				end;
				
				// Update element
				if (GetElementNativeValues(e, sSPCT) <> ElementCount(ElementByName(e, sEffects))) then begin
					iOldValue := GetElementNativeValues(e, sSPCT);
					iNewValue := ElementCount(ElementByName(e, sEffects));
					iDiff := (iNewValue - iOldValue);
					SetElementNativeValues(e, sSPCT, ElementCount(ElementByName(e, sEffects)));
					AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] Updated (' + sSPCT + ') from ' + iOldValue + ' to ' + iNewValue + ' (Diff: ' + iDiff + ')');
				end;
				
				// Check if the element exists and remove if necessary
				if ElementCount(ElementByName(e, sEffects)) = 0 then begin
					if Assigned(ElementByName(e, sSPCT)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (' + sSPCT + ') should be cleansed. Removing...');
						RemoveElement(e, 'SPCT');
					end;
					if Assigned(ElementByName(e, sEffects)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (' + sEffects + ') should be cleansed. Removing...');
						RemoveElement(e, sEffects);
					end;
				end;
				
				// ----------------------------------------------------------------------------------
				// PRKZ
				// ----------------------------------------------------------------------------------
				// Check if the element exists and add if necessary
				if ElementCount(ElementByName(e, 'Perks')) > 0 then begin
					if not Assigned(ElementByName(e, sPRKZ)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] ' + sPRKZ + ' does not exist. Adding...');
						Add(e, 'PRKZ', true);
					end;
				end;
				
				// Update element
				if (GetElementNativeValues(e, sPRKZ) <> ElementCount(ElementByName(e, 'Perks'))) then begin
					iOldValue := GetElementNativeValues(e, sPRKZ);
					iNewValue := ElementCount(ElementByName(e, 'Perks'));
					iDiff := (iNewValue - iOldValue);
					SetElementNativeValues(e, sPRKZ, ElementCount(ElementByName(e, 'Perks')));
					AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] Updated ' + sPRKZ + ' from ' + iOldValue + ' to ' + iNewValue + ' (Diff: ' + iDiff + ')');
				end;
				
				// Check if the element exists and remove if necessary
				if ElementCount(ElementByName(e, 'Perks')) = 0 then begin
					if Assigned(ElementByName(e, sPRKZ)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (' + sPRKZ + ') should be cleansed. Removing...');
						RemoveElement(e, 'PRKZ');
					end;
					if Assigned(ElementByName(e, 'Perks')) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (Perks) should be cleansed. Removing...');
						RemoveElement(e, 'Perks');
					end;
				end;
				
				// ----------------------------------------------------------------------------------
				// COCT
				// ----------------------------------------------------------------------------------
				// Check if the element exists and add if necessary
				if ElementCount(ElementByName(e, 'Items')) > 0 then begin
					if not Assigned(ElementByName(e, sCOCT)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] ' + sCOCT + ' does not exist. Adding...');
						Add(e, 'COCT', true);
					end;
				end;
				
				// Update element
				if (GetElementNativeValues(e, sCOCT) <> ElementCount(ElementByName(e, 'Items'))) then begin
					iOldValue := GetElementNativeValues(e, sCOCT);
					iNewValue := ElementCount(ElementByName(e, 'Items'));
					iDiff := (iNewValue - iOldValue);
					SetElementNativeValues(e, sCOCT, ElementCount(ElementByName(e, 'Items')));
					AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] Updated ' + sCOCT + ' from ' + iOldValue + ' to ' + iNewValue + ' (Diff: ' + iDiff + ')');
				end;
				
				// Check if the element exists and remove if necessary
				if ElementCount(ElementByName(e, 'Items')) = 0 then begin
					if Assigned(ElementByName(e, sCOCT)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (' + sCOCT + ') should be cleansed. Removing...');
						RemoveElement(e, 'COCT');
					end;
					if Assigned(ElementByName(e, 'Items')) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (Items) should be cleansed. Removing...');
						RemoveElement(e, 'Items');
					end;
				end;
				
				// ----------------------------------------------------------------------------------
				// KWDA
				// ----------------------------------------------------------------------------------
				// Check if the element exists and add if necessary
				if ElementCount(ElementByName(e, sKWDA)) > 0 then begin
					if not Assigned(ElementByName(e, sKSIZ)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] ' + sKSIZ + ' does not exist. Adding...');
						Add(e, 'KSIZ', true);
					end;
				end;
				
				// Update element
				if (GetElementNativeValues(e, sKSIZ) <> ElementCount(ElementByName(e, sKWDA))) then begin
					iOldValue := GetElementNativeValues(e, sKSIZ);
					iNewValue := ElementCount(ElementByName(e, sKWDA));
					iDiff := (iNewValue - iOldValue);
					SetElementNativeValues(e, sKSIZ, ElementCount(ElementByName(e, sKWDA)));
					AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] Updated ' + sKSIZ + ' from ' + iOldValue + ' to ' + iNewValue + ' (Diff: ' + iDiff + ')');
				end;
				
				// Check if the element exists and remove if necessary
				if ElementCount(ElementByName(e, sKWDA)) = 0 then begin
					if Assigned(ElementByName(e, sKSIZ)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (' + sKSIZ + ') should be cleansed. Removing...');
						RemoveElement(e, 'KSIZ');
					end;
					if Assigned(ElementByName(e, sKWDA)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (' + sKWDA + ') should be cleansed. Removing...');
						RemoveElement(e, 'KWDA');
					end;
				end;
			
			end;
			
		end;
		// ----------------------------------------------------------------------------------
		
		// ----------------------------------------------------------------------------------
		// PACK
		// ----------------------------------------------------------------------------------
		if (sRecord = 'PACK') then begin
			
			if IsEditable(e) and not GetIsDeleted(e) then begin
			
				// Check if the element exists and add if necessary
				if ElementCount(ElementByPath(e, sValues)) > 0 then begin
					if not Assigned(ElementByPath(e, sPKCU)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] ' + sPKCU + ' does not exist. Adding...');
						Add(e, sPKCU, true);
					end;
				end;
				
				// Update element
				if (GetElementNativeValues(e, sPKCU) <> ElementCount(ElementByPath(e, sValues))) then begin
					iOldValue := GetElementNativeValues(e, sPKCU);
					iNewValue := ElementCount(ElementByPath(e, sValues));
					iDiff := (iNewValue - iOldValue);
					SetElementNativeValues(e, sPKCU, ElementCount(ElementByPath(e, sValues)));
					AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] Updated ' + sPKCU + ' from ' + iOldValue + ' to ' + iNewValue + ' (Diff: ' + iDiff + ')');
				end;
				
				// Check if the element exists and remove if necessary
				if ElementCount(ElementByPath(e, sValues)) = 0 then begin
					if Assigned(ElementByPath(e, sPKCU)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (' + sPKCU + ') should be cleansed. Removing...');
						RemoveElement(e, 'PKCU');
					end;
					if Assigned(ElementByName(e, sValues)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (' + sValues + ') should be cleansed. Removing...');
						RemoveElement(e, sValues);
					end;
				end;
			
			end;
			
		end;
		// ----------------------------------------------------------------------------------
		
		// ----------------------------------------------------------------------------------
		// SCEN
		// ----------------------------------------------------------------------------------
		if (sRecord = 'SCEN') then begin
			
			if IsEditable(e) and not GetIsDeleted(e) then begin
			
				// Check if the element exists and add if necessary
				if ElementCount(ElementByName(e, 'Actions')) > 0 then begin
					if not Assigned(ElementByName(e, sINAM)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] INAM does not exist. Adding...');
						Add(e, 'INAM', true);
					end;
				end;
				
				// Update element
				if (GetElementNativeValues(e, 'INAM') <> ElementCount(ElementByName(e, 'Actions'))) then begin
					iOldValue := GetElementNativeValues(e, 'INAM');
					iNewValue := ElementCount(ElementByName(e, 'Actions'));
					iDiff := (iNewValue - iOldValue);
					SetElementNativeValues(e, 'INAM', ElementCount(ElementByName(e, 'Actions')));
					AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] Updated ' + sINAM + ' from ' + iOldValue + ' to ' + iNewValue + ' (Diff: ' + iDiff + ')');
				end;
				
				// Check if the element exists and remove if necessary
				if ElementCount(ElementByName(e, 'Actions')) = 0 then begin
					if Assigned(ElementByName(e, sINAM)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (' + sINAM + ') should be cleansed. Removing...');
						RemoveElement(e, 'INAM');
					end;
					if Assigned(ElementByName(e, 'Actions')) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (Actions) should be cleansed. Removing...');
						RemoveElement(e, 'Actions');
					end;
				end;
			
			end;

		end;
		// ----------------------------------------------------------------------------------
		
		// ----------------------------------------------------------------------------------
		// SMQN
		// ----------------------------------------------------------------------------------
		if (sRecord = 'SMQN') then begin
			
			if IsEditable(e) and not GetIsDeleted(e) then begin
			
				// Check if the element exists and add if necessary
				if ElementCount(ElementByName(e, 'Quests')) > 0 then begin
					if not Assigned(ElementByName(e, sQNAM)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] ' + sQNAM + ' does not exist. Adding...');
						Add(e, 'QNAM', true);
					end;
				end;
				
				// Update element
				if (GetElementNativeValues(e, sQNAM) <> ElementCount(ElementByName(e, 'Quests'))) then begin
					iOldValue := GetElementNativeValues(e, sQNAM);
					iNewValue := ElementCount(ElementByName(e, 'Quests'));
					iDiff := (iNewValue - iOldValue);
					SetElementNativeValues(e, sQNAM, ElementCount(ElementByName(e, 'Quests')));
					AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] Updated ' + sQNAM + ' from ' + iOldValue + ' to ' + iNewValue + ' (Diff: ' + iDiff + ')');
				end;
				
				// Check if the element exists and remove if necessary
				if ElementCount(ElementByName(e, 'Quests')) = 0 then begin
					if Assigned(ElementByName(e, sQNAM)) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (' + sQNAM + ') should be cleansed. Removing...');
						RemoveElement(e, 'QNAM');
					end;
					if Assigned(ElementByName(e, 'Quests')) then begin
						AddMessage(plugin + ' [' + Signature(e) + ':' + IntToHex(FixedFormID(e),8) + '] (Quests) should be cleansed. Removing...');
						RemoveElement(e, 'Quests');
					end;
				end;
			
			end;
			
		end;
		// ----------------------------------------------------------------------------------

	end; // function

end. // script
