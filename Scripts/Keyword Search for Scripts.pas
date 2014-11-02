{
	Purpose: Keyword Search for Scripts
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	a, b, c: integer;
	sQuery, sCaseSensitive: string;
	bCaseSensitive: boolean;

// Called before processing
function Initialize: integer;
	begin

		sQuery := (InputBox('Adaptive Query', 'Query:', 'Script'));
		if sQuery = lowercase(sQuery) then begin
			bCaseSensitive := false;
			sCaseSensitive := '(case insensitive)';
		end;
		if sQuery <> lowercase(sQuery) then begin
			bCaseSensitive := true;
			sCaseSensitive := '(case sensitive)';
		end;
		AddMessage('--------------------------------------------------------------------------------');
		AddMessage('QUERY ' + sCaseSensitive + ': "' + sQuery + '"');
		AddMessage('--------------------------------------------------------------------------------');
	
	end;

function Process(e: IInterface): integer;
	var
		rec, vmad: IInterface;
		sPath: string;
		
		// SCRIPTS
		scripts, script: IInterface;
		sPathScripts, sPathScriptName, sScriptName, sMatchFoundScript: string;
		iScripts: integer;
		
		// QUEST FRAGMENT SCRIPTS
		fragments, fragment: IInterface;
		sPathFragments, sPathFragmentName, sFragmentName, sMatchFoundFragment: string;
		iFragments: integer;
		
		// ALIAS SCRIPTS
		aliases, alias: IInterface;
		sPathAliases, sPathAliasName, sAliasName, sMatchFoundAlias: string;
		iAliases: integer;

	begin

		Result := 0;

		rec := Signature(e);
		sPath := Name(e);
		
		if (rec = 'ACTI') or (rec = 'APPA') or (rec = 'ARMO') or (rec = 'BOOK') or (rec = 'CONT')
			or (rec = 'INFO') or (rec = 'DOOR') or (rec = 'FLOR') or (rec = 'FURN') or (rec = 'INGR')
			or (rec = 'KEYM') or (rec = 'LIGH') or (rec = 'MGEF') or (rec = 'MISC') or (rec = 'NPC_')
			or (rec = 'PACK') or (rec = 'PERK') or (rec = 'QUST') or (rec = 'SCEN') or (rec = 'TACT')
			or (rec = 'WEAP') or (rec = 'REFR') then begin
		
			sPathScripts := 'VMAD - Virtual Machine Adapter\Data\Scripts';
			sPathScriptName := 'VMAD - Virtual Machine Adapter\Data\Scripts\script\scriptName';
			
			if (rec = 'QUST') then begin
			
				sPathScripts 			:= 'VMAD - Virtual Machine Adapter\Data\Quest VMAD\Scripts';
				sPathScriptName 	:= 'VMAD - Virtual Machine Adapter\Data\Quest VMAD\Scripts\script\scriptName';
				sPathFragments 		:= 'VMAD - Virtual Machine Adapter\Data\Quest VMAD\Script Fragments Quest\Quest Fragments';
				sPathFragmentName := 'VMAD - Virtual Machine Adapter\Data\Quest VMAD\Script Fragments Quest\Quest Fragments\Quest Fragment\scriptName';
				sPathAliases 			:= 'VMAD - Virtual Machine Adapter\Data\Quest VMAD\Script Fragments Quest\Aliases';
				sPathAliasName 		:= 'VMAD - Virtual Machine Adapter\Data\Quest VMAD\Script Fragments Quest\Aliases\Alias\Alias Scripts\Script\scriptName';

			end;
			
			vmad := ElementBySignature(e, 'VMAD');
			if Assigned(vmad) then begin
			
				// ================================================================================
				// SCRIPTS
				// ================================================================================
				scripts := ElementByPath(e, sPathScripts);
				iScripts := ElementCount(scripts);
				
				if iScripts = 1 then begin
				
					sScriptName := GetElementEditValues(e, sPathScriptName);
					sMatchFoundScript 	:= '[MATCH FOUND] ' + GetFileName(e) + ': "' + sScriptName + '" is a script attached to "' + GetElementEditValues(e, 'EDID') + '" [ ' + rec + ': ' + IntToHex(FormID(e), 8) + ' ]';
					
					if bCaseSensitive = FALSE then begin
						if pos(lowercase(sQuery), lowercase(sScriptName)) > 0 then begin
							AddMessage(sMatchFoundScript);
						end;
					end;
					
					if bCaseSensitive = TRUE then begin
						if pos(sQuery, sScriptName) > 0 then begin
							AddMessage(sMatchFoundScript);
						end;
					end;
				
				end;
				
				if iScripts > 1 then begin
					
					for a := 0 to iScripts - 1 do begin
					
						script := ElementByIndex(scripts, a);
						sScriptName := GetElementEditValues(script, 'scriptName');
						sMatchFoundScript 	:= '[MATCH FOUND] ' + GetFileName(e) + ': "' + sScriptName + '" is a script attached to "' + GetElementEditValues(e, 'EDID') + '" [ ' + rec + ': ' + IntToHex(FormID(e), 8) + ' ]';
						
						if bCaseSensitive = FALSE then begin
							if pos(lowercase(sQuery), lowercase(sScriptName)) > 0 then begin
								AddMessage(sMatchFoundScript);
							end;
						end;
						
						if bCaseSensitive = TRUE then begin
							if pos(sQuery, sScriptName) > 0 then begin
								AddMessage(sMatchFoundScript);
							end;
						end;
					
					end;
					
				end; // end search through multiple scripts
				
				// ================================================================================
				// SCRIPT FRAGMENTS QUEST
				// ================================================================================
				
				if (rec = 'QUST') then begin
				
					fragments := ElementByPath(e, sPathFragments);
					iFragments := ElementCount(fragments);
					
					if iFragments = 1 then begin
						
						sFragmentName := GetElementEditValues(e, sPathFragmentName);
						sMatchFoundFragment := '[MATCH FOUND] ' + GetFileName(e) + ': "' + sFragmentName + '" is a quest fragment script attached to "' + GetElementEditValues(e, 'EDID') + '" [ ' + rec + ': ' + IntToHex(FormID(e), 8) + ' ]';
						
						if bCaseSensitive = FALSE then begin
							if pos(lowercase(sQuery), lowercase(sFragmentName)) > 0 then begin
								AddMessage(sMatchFoundFragment);
							end;
						end;
						
						if bCaseSensitive = TRUE then begin
							if pos(sQuery, sFragmentName) > 0 then begin
								AddMessage(sMatchFoundFragment);
							end;
						end;
					
					end;
					
					if iFragments > 1 then begin
					
						for a := 0 to iFragments - 1 do begin
						
							fragment := ElementByIndex(fragments, a);
							sFragmentName := GetElementEditValues(fragment, 'scriptName');
							sMatchFoundFragment := '[MATCH FOUND] ' + GetFileName(e) + ': "' + sFragmentName + '" is a quest fragment script attached to "' + GetElementEditValues(e, 'EDID') + '" [ ' + rec + ': ' + IntToHex(FormID(e), 8) + ' ]';
							
							if bCaseSensitive = FALSE then begin
								if pos(lowercase(sQuery), lowercase(sFragmentName)) > 0 then begin
									AddMessage(sMatchFoundFragment);
								end;
							end;
							
							if bCaseSensitive = TRUE then begin
								if pos(sQuery, sFragmentName) > 0 then begin
									AddMessage(sMatchFoundFragment);
								end;
							end;
						
						end;
					
					end;
				
				end; // end quest condition for script fragments search
				
				// ================================================================================
				// ALIASES
				// ================================================================================
				
				//AddMessage('DEBUG: Checking if record type is QUST for alias script search');
				if (rec = 'QUST') then begin
				
					aliases := ElementByPath(e, sPathAliases);
					iAliases := ElementCount(aliases);
					
					if iAliases = 1 then begin
						
						sAliasName := GetElementEditValues(e, sPathAliasName);
						sMatchFoundAlias 		:= '[MATCH FOUND] ' + GetFileName(e) + ': "' + sAliasName + '" is an alias script attached to "' + GetElementEditValues(e, 'EDID') + '" [ ' + rec + ': ' + IntToHex(FormID(e), 8) + ' ]';
						
						if bCaseSensitive = FALSE then begin
							if pos(lowercase(sQuery), lowercase(sAliasName)) > 0 then begin
									AddMessage(sMatchFoundAlias);
							end;
						end;
						
						if bCaseSensitive = TRUE then begin
							if pos(sQuery, sAliasName) > 0 then begin
									AddMessage(sMatchFoundAlias);
							end;
						end;
					
					end;
					
					if iAliases > 1 then begin
					
						for a := 0 to iAliases - 1 do begin
						
							alias := ElementByIndex(aliases, a);
							sAliasName := GetElementEditValues(alias, 'Alias Scripts\Script\scriptName');
						sMatchFoundAlias 		:= '[MATCH FOUND] ' + GetFileName(e) + ': "' + sAliasName + '" is an alias script attached to "' + GetElementEditValues(e, 'EDID') + '" [ ' + rec + ': ' + IntToHex(FormID(e), 8) + ' ]';
							
							if bCaseSensitive = FALSE then begin
								if pos(lowercase(sQuery), lowercase(sAliasName)) > 0 then begin
									AddMessage(sMatchFoundAlias);
								end;
							end;
							
							if bCaseSensitive = TRUE then begin
								if pos(sQuery, sAliasName) > 0 then begin
									AddMessage(sMatchFoundAlias);
								end;
							end;
						
						end;
					
					end;
				
				end; // end quest condition for alias script search
				
			end; // end check for existing element (slight performance boost!)
			
		end; // end main condition

	end; // end process

// Cleanup
function Finalize: integer;
	begin
	
		AddMessage('--------------------------------------------------------------------------------');
	
		Result := 1;

	end; // end function

end. // end script