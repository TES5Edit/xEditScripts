{
	Purpose: Resolve Errors
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	slParentElements: TStringList;
	sOldIndex, sNewIndex, sFormID: string;
	fileFixed: iwbFile;
	bDebug: bool;

//============================================================================
function Initialize: integer;

	begin

		ClearMessages();
		
		bDebug := false;

		slParentElements := TStringList.Create;

		if not InputQuery('Enter', 'Old Index:', sOldIndex) then begin
			Result := 1;
			exit;
		end;

		if not InputQuery('Enter', 'New Index:', sNewIndex) then begin
			Result := 1;
			exit;
		end;

		fileFixed := FileByLoadOrder(StrToInt('$' + sNewIndex));

		AddMessage(GetFileName(fileFixed));

	end;

//============================================================================
function Process(e: IInterface): integer;

	var
		h, i, j, k, l: integer;
		baseRecord, L0, L1, L2, L3, L4, L5, L6, L7, L8, L9: IInterface;
		s, sCorrection: string;

	begin

		slParentElements.Clear;

		if Signature(e) = 'NPC_' then
			slParentElements.Add('VMAD - Virtual Machine Adapter');
				
		if Signature(e) = 'COBJ' then begin
			slParentElements.Add('Items');
			slParentElements.Add('Conditions');
			slParentElements.Add('CNAM');
			slParentElements.Add('BNAM');
		end;

		if Signature(e) = 'FLST' then
			slParentElements.Add('FormIDs');

		if Signature(e) = 'LVLI' then
			slParentElements.Add('Leveled List Entries');

		if Signature(e) = 'REFR' then
			slParentElements.Add('NAME');

		// -------------------------------------------------------------------------------
		for h := 0 to slParentElements.Count - 1 do begin

			// Level 0
			L0 := ElementByPath(e, slParentElements[h]);

			// If there is an error to be corrected
			if pos('Error:', GetEditValue(L0)) > 0 then begin

				s := IntToHex(GetNativeValue(L0), 8);

				// If this error should be corrected
				if CompareStr(sOldIndex, Copy(s, 1, 2)) = 0 then begin

					sCorrection := Delete(s, 1, 2);

					sCorrection := Insert(sNewIndex, sCorrection, 0);

					AddMessage('Error (' + Name(L0) + '): ' + GetEditValue(L0));

					AddMessage('Correcting to: ' + sCorrection);

					baseRecord := RecordByFormID(FileByLoadOrder(StrToInt('$' + sNewIndex)), StrToInt('$' + sCorrection), true);

					AddMessage( 'Form ID: ' + GetElementEditValues(baseRecord, 'Record Header\FormID') );
					
					if not bDebug then
						SetEditValue(L0, GetElementEditValues(baseRecord, 'Record Header\FormID'));

					AddMessage('Resolved to: ' + GetEditValue(L0) + #13#10);

				end;

			end; // end if - error check

			// -------------------------------------------------------------------------------
			for i := 0 to ElementCount(L0) - 1 do begin

				// Level 1
				L1 := ElementByIndex(L0, i);

				// If there is an error to be corrected
				if pos('Error:', GetEditValue(L1)) > 0 then begin

					s := IntToHex(GetNativeValue(L1), 8);

					// If this error should be corrected
					if CompareStr(sOldIndex, Copy(s, 1, 2)) = 0 then begin

						sCorrection := Delete(s, 1, 2);

						sCorrection := Insert(sNewIndex, sCorrection, 0);

						AddMessage('Error (' + Name(L1) + '): ' + GetEditValue(L1));

						AddMessage('Correcting to: ' + sCorrection);

						baseRecord := RecordByFormID(FileByLoadOrder(StrToInt('$' + sNewIndex)), StrToInt('$' + sCorrection), true);

						AddMessage( 'Form ID: ' + GetElementEditValues(baseRecord, 'Record Header\FormID') );
						
						if not bDebug then
							SetEditValue(L1, GetElementEditValues(baseRecord, 'Record Header\FormID'));

						AddMessage('Resolved to: ' + GetEditValue(L1) + #13#10);

					end;

				end; // end if - error check

				// -------------------------------------------------------------------------------
				for j := 0 to ElementCount(L1) - 1 do begin

					// Level 2
					L2 := ElementByIndex(L1, j);

					// If there is an error to be corrected
					if pos('Error:', GetEditValue(L2)) > 0 then begin

						s := IntToHex(GetNativeValue(L2), 8);

						// If this error should be corrected
						if CompareStr(sOldIndex, Copy(s, 1, 2)) = 0 then begin

							sCorrection := Delete(s, 1, 2);

							sCorrection := Insert(sNewIndex, sCorrection, 0);

							AddMessage('Error (' + Name(L2) + '): ' + GetEditValue(L2));

							AddMessage('Correcting to: ' + sCorrection);

							baseRecord := RecordByFormID(FileByLoadOrder(StrToInt('$' + sNewIndex)), StrToInt('$' + sCorrection), true);

							AddMessage( 'Form ID: ' + GetElementEditValues(baseRecord, 'Record Header\FormID') );
							
							if not bDebug then
								SetEditValue(L2, GetElementEditValues(baseRecord, 'Record Header\FormID'));

							AddMessage('Resolved to: ' + GetEditValue(L2) + #13#10);

						end;

					end; // end if - error check

					// -------------------------------------------------------------------------------
					for k := 0 to ElementCount(L2) - 1 do begin

						// Level 3
						L3 := ElementByIndex(L2, k);

						// If there is an error to be corrected
						if pos('Error:', GetEditValue(L3)) > 0 then begin

							s := IntToHex(GetNativeValue(L3), 8);

							// If this error should be corrected
							if CompareStr(sOldIndex, Copy(s, 1, 2)) = 0 then begin

								sCorrection := Delete(s, 1, 2);

								sCorrection := Insert(sNewIndex, sCorrection, 0);

								AddMessage('Error (' + Name(L3) + '): ' + GetEditValue(L3));

								AddMessage('Correcting to: ' + sCorrection);

								baseRecord := RecordByFormID(FileByLoadOrder(StrToInt('$' + sNewIndex)), StrToInt('$' + sCorrection), true);

								AddMessage( 'Form ID: ' + GetElementEditValues(baseRecord, 'Record Header\FormID') );
							
								if not bDebug then
									SetEditValue(L3, GetElementEditValues(baseRecord, 'Record Header\FormID'));

								AddMessage('Resolved to: ' + GetEditValue(L3) + #13#10);

							end;

						end; // end if - error check
						
						// -------------------------------------------------------------------------------
						for l := 0 to ElementCount(L3) - 1 do begin

							// Level 3
							L4 := ElementByIndex(L3, l);

							// If there is an error to be corrected
							if pos('Error:', GetEditValue(L4)) > 0 then begin

								s := IntToHex(GetNativeValue(L4), 8);

								// If this error should be corrected
								if CompareStr(sOldIndex, Copy(s, 1, 2)) = 0 then begin

									sCorrection := Delete(s, 1, 2);

									sCorrection := Insert(sNewIndex, sCorrection, 0);

									AddMessage('Error (' + Name(L4) + '): ' + GetEditValue(L4));

									AddMessage('Correcting to: ' + sCorrection);

									baseRecord := RecordByFormID(FileByLoadOrder(StrToInt('$' + sNewIndex)), StrToInt('$' + sCorrection), true);

									AddMessage( 'Form ID: ' + GetElementEditValues(baseRecord, 'Record Header\FormID') );
								
									if not bDebug then
										SetEditValue(L4, GetElementEditValues(baseRecord, 'Record Header\FormID'));

									AddMessage('Resolved to: ' + GetEditValue(L4) + #13#10);

								end;

							end; // end if - error check
							
							// -------------------------------------------------------------------------------
							for l := 0 to ElementCount(L4) - 1 do begin

								// Level 3
								L5 := ElementByIndex(L4, l);

								// If there is an error to be corrected
								if pos('Error:', GetEditValue(L5)) > 0 then begin

									s := IntToHex(GetNativeValue(L5), 8);

									// If this error should be corrected
									if CompareStr(sOldIndex, Copy(s, 1, 2)) = 0 then begin

										sCorrection := Delete(s, 1, 2);

										sCorrection := Insert(sNewIndex, sCorrection, 0);

										AddMessage('Error (' + Name(L5) + '): ' + GetEditValue(L5));

										AddMessage('Correcting to: ' + sCorrection);

										baseRecord := RecordByFormID(FileByLoadOrder(StrToInt('$' + sNewIndex)), StrToInt('$' + sCorrection), true);

										AddMessage( 'Form ID: ' + GetElementEditValues(baseRecord, 'Record Header\FormID') );
									
										if not bDebug then
											SetEditValue(L5, GetElementEditValues(baseRecord, 'Record Header\FormID'));

										AddMessage('Resolved to: ' + GetEditValue(L5) + #13#10);

									end;

								end; // end if - error check
								
								// -------------------------------------------------------------------------------
								for l := 0 to ElementCount(L5) - 1 do begin

									// Level 3
									L6 := ElementByIndex(L5, l);

									// If there is an error to be corrected
									if pos('Error:', GetEditValue(L6)) > 0 then begin

										s := IntToHex(GetNativeValue(L6), 8);

										// If this error should be corrected
										if CompareStr(sOldIndex, Copy(s, 1, 2)) = 0 then begin

											sCorrection := Delete(s, 1, 2);

											sCorrection := Insert(sNewIndex, sCorrection, 0);

											AddMessage('Error (' + Name(L6) + '): ' + GetEditValue(L6));

											AddMessage('Correcting to: ' + sCorrection);

											baseRecord := RecordByFormID(FileByLoadOrder(StrToInt('$' + sNewIndex)), StrToInt('$' + sCorrection), true);

											AddMessage( 'Form ID: ' + GetElementEditValues(baseRecord, 'Record Header\FormID') );
										
											if not bDebug then
												SetEditValue(L6, GetElementEditValues(baseRecord, 'Record Header\FormID'));

											AddMessage('Resolved to: ' + GetEditValue(L6) + #13#10);

										end;

									end; // end if - error check
									
									// -------------------------------------------------------------------------------
									for l := 0 to ElementCount(L6) - 1 do begin

										// Level 3
										L7 := ElementByIndex(L6, l);

										// If there is an error to be corrected
										if pos('Error:', GetEditValue(L7)) > 0 then begin

											s := IntToHex(GetNativeValue(L7), 8);

											// If this error should be corrected
											if CompareStr(sOldIndex, Copy(s, 1, 2)) = 0 then begin

												sCorrection := Delete(s, 1, 2);

												sCorrection := Insert(sNewIndex, sCorrection, 0);

												AddMessage('Error (' + Name(L7) + '): ' + GetEditValue(L7));

												AddMessage('Correcting to: ' + sCorrection);

												baseRecord := RecordByFormID(FileByLoadOrder(StrToInt('$' + sNewIndex)), StrToInt('$' + sCorrection), true);

												AddMessage( 'Form ID: ' + GetElementEditValues(baseRecord, 'Record Header\FormID') );
											
												if not bDebug then
													SetEditValue(L7, GetElementEditValues(baseRecord, 'Record Header\FormID'));

												AddMessage('Resolved to: ' + GetEditValue(L7) + #13#10);

											end;

										end; // end if - error check
										
										// -------------------------------------------------------------------------------
										for l := 0 to ElementCount(L7) - 1 do begin

											// Level 3
											L8 := ElementByIndex(L7, l);

											// If there is an error to be corrected
											if pos('Error:', GetEditValue(L8)) > 0 then begin

												s := IntToHex(GetNativeValue(L8), 8);

												// If this error should be corrected
												if CompareStr(sOldIndex, Copy(s, 1, 2)) = 0 then begin

													sCorrection := Delete(s, 1, 2);

													sCorrection := Insert(sNewIndex, sCorrection, 0);

													AddMessage('Error (' + Name(L8) + '): ' + GetEditValue(L8));

													AddMessage('Correcting to: ' + sCorrection);

													baseRecord := RecordByFormID(FileByLoadOrder(StrToInt('$' + sNewIndex)), StrToInt('$' + sCorrection), true);

													AddMessage( 'Form ID: ' + GetElementEditValues(baseRecord, 'Record Header\FormID') );
												
													if not bDebug then
														SetEditValue(L8, GetElementEditValues(baseRecord, 'Record Header\FormID'));

													AddMessage('Resolved to: ' + GetEditValue(L8) + #13#10);

												end;

											end; // end if - error check
											
											// -------------------------------------------------------------------------------
											for l := 0 to ElementCount(L8) - 1 do begin

												// Level 3
												L9 := ElementByIndex(L8, l);

												// If there is an error to be corrected
												if pos('Error:', GetEditValue(L9)) > 0 then begin

													s := IntToHex(GetNativeValue(L9), 8);

													// If this error should be corrected
													if CompareStr(sOldIndex, Copy(s, 1, 2)) = 0 then begin

														sCorrection := Delete(s, 1, 2);

														sCorrection := Insert(sNewIndex, sCorrection, 0);

														AddMessage('Error (' + Name(L9) + '): ' + GetEditValue(L9));

														AddMessage('Correcting to: ' + sCorrection);

														baseRecord := RecordByFormID(FileByLoadOrder(StrToInt('$' + sNewIndex)), StrToInt('$' + sCorrection), true);

														AddMessage( 'Form ID: ' + GetElementEditValues(baseRecord, 'Record Header\FormID') );
													
														if not bDebug then
															SetEditValue(L9, GetElementEditValues(baseRecord, 'Record Header\FormID'));

														AddMessage('Resolved to: ' + GetEditValue(L9) + #13#10);

													end;

												end; // end if - error check
												
											end; // end for - level 9
										
										end; // end for - level 8
									
									end; // end for - level 7
								
								end; // end for - level 6
							
							end; // end for - level 5
						
						end; // end for - level 4

					end; // end for - level 3

				end; // end for - level 2

			end; // end for - level 1

		end; // end for - list

		slParentElements.Clear;

	end;

function Finalize: integer;

	begin

		Result := 1;
		exit;

	end;

end.
