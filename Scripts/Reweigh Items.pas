{
	Purpose: Reweigh Items
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}
unit UserScript;

var
  fConfirmation, fWeightless, fArmor, fBooks, fConsumables, fIngredients, fKeys, fMisc, fScrolls, fSoulGems, fWeapons: boolean;
  fArmorWeight, fBooksWeight, fConsumablesWeight, fIngredientsWeight, fKeysWeight, fMiscWeight, fScrollsWeight, fSoulGemsWeight, fWeaponsWeight: float;
  
function Initialize: integer;
begin
  Result := 0;
  
  fConfirmation := (MessageDlg('Are you sure you want to apply this script?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
  if (fConfirmation <> TRUE) then begin
    Exit;
  end;
  
  fWeightless := (MessageDlg('Do you want to reduce all item weights to zero?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
  if (fWeightless <> FALSE) then begin
    fArmor := TRUE;
    fBooks := TRUE;
    fConsumables := TRUE;
    fIngredients := TRUE;
    fKeys := TRUE;
    fMisc := TRUE;
    fScrolls := TRUE;
    fSoulGems := TRUE;
    fWeapons := TRUE;
    fArmorWeight := 0.000000;
    fBooksWeight := 0.000000;
    fConsumablesWeight := 0.000000;
    fIngredientsWeight := 0.000000;
    fKeysWeight := 0.000000;
    fMiscWeight := 0.000000;
    fScrollsWeight := 0.000000;
    fSoulGemsWeight := 0.000000;
    fWeaponsWeight := 0.000000;
  end;

  if (fWeightless <> TRUE) then begin
  
    fArmor := (MessageDlg('Reweigh Armor?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
    if (fArmor) AND (fWeightless <> TRUE) then begin
      fArmorWeight := (InputBox('Set Weight:', 'Weight:', 0.000000));
    end;
    
    fBooks := (MessageDlg('Reweigh Books?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
    if (fBooks) AND (fWeightless <> TRUE) then begin
      fBooksWeight := (InputBox('Set Weight:', 'Weight:', 0.000000));
    end;
    
    fConsumables := (MessageDlg('Reweigh Consumables?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
    if (fConsumables) AND (fWeightless <> TRUE) then begin
      fConsumablesWeight := (InputBox('Set Weight:', 'Weight:', 0.000000));
    end;
    
    fIngredients := (MessageDlg('Reweigh Ingredients?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
    if (fIngredients) AND (fWeightless <> TRUE) then begin
      fIngredientsWeight := (InputBox('Set Weight:', 'Weight:', 0.000000));
    end;
    
    fKeys := (MessageDlg('Reweigh Keys?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
    if (fKeys) AND (fWeightless <> TRUE) then begin
      fKeysWeight := (InputBox('Set Weight:', 'Weight:', 0.000000));
    end;
    
    fMisc := (MessageDlg('Reweigh Misc.?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
    if (fMisc) AND (fWeightless <> TRUE) then begin
      fMiscWeight := (InputBox('Set Weight:', 'Weight:', 0.000000));
    end;
    
    fScrolls := (MessageDlg('Reweigh Scrolls?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
    if (fScrolls) AND (fWeightless <> TRUE) then begin
      fScrollsWeight := (InputBox('Set Weight:', 'Weight:', 0.000000));
    end;
    
    fSoulGems := (MessageDlg('Reweigh Soul Gems?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
    if (fSoulGems) AND (fWeightless <> TRUE) then begin
      fSoulGemsWeight := (InputBox('Set Weight:', 'Weight:', 0.000000));
    end;
    
    fWeapons := (MessageDlg('Reweigh Weapons?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
    if (fWeapons) AND (fWeightless <> TRUE) then begin
      fWeaponsWeight := (InputBox('Set Weight:', 'Weight:', 0.000000));
    end;
  
  end;
  
end;

function Process(e: IInterface): integer;
begin
  Result := 0;
  
  AddMessage('Processing: ' + Name(e));
  
  if (fArmor) AND (Signature(e) = 'ARMO') then begin
    SetElementNativeValues(e, 'DATA - Data\Weight', fArmorWeight)
  end;
  
  if (fBooks) AND (Signature(e) = 'BOOK') then begin
    SetElementNativeValues(e, 'DATA - Data\Weight', fBooksWeight)
  end;
  
  if (fConsumables) AND (Signature(e) = 'ALCH') then begin
    SetElementNativeValues(e, 'DATA - Weight', fConsumablesWeight)
  end;
  
  if (fIngredients) AND (Signature(e) = 'INGR') then begin
    SetElementNativeValues(e, 'DATA - \Weight', fIngredientsWeight)
  end;
  
  if (fKeys) AND (Signature(e) = 'KEYM') then begin
    SetElementNativeValues(e, 'DATA - \Weight', fKeysWeight)
  end;
  
  if (fMisc) AND (Signature(e) = 'MISC') then begin
    SetElementNativeValues(e, 'DATA - Data\Weight', fMiscWeight)
  end;
  
  if (fScrolls) AND (Signature(e) = 'SCRL') then begin
    SetElementNativeValues(e, 'DATA - Item\Weight', fScrollsWeight)
  end;
  
  if (fSoulGems) AND (Signature(e) = 'SLGM') then begin
    SetElementNativeValues(e, 'DATA - \Weight', fSoulGemsWeight)
  end;
  
  if (fWeapons) AND (Signature(e) = 'WEAP') then begin
    SetElementNativeValues(e, 'DATA - Game Data\Weight', fWeaponsWeight)
  end;

end;

end.