{
    Purpose: Update Owner to Parent XOWN
    Game: The Elder Scrolls V: Skyrim
    Author: fireundubh <fireundubh@gmail.com>
    Version: 0.1

    1. Select the Cell, Block, Sub-Block, Persistent, or Temporary groups.
       Alternatively, select a CELL record or any number of REFR records.
    2. Apply script.
}

unit UserScript;

var
    slRecordTypes: TStringList;
    slUpdates: TStringList;
    slWarnings: TStringList;
	filename: string;

function Initialize: integer;
begin
    Result := 0;

    ClearMessages(); // Only works in the latest versions of TES5Edit

    // List of logged successes
    slUpdates  := TStringList.Create;

    // List of logged warnings
    slWarnings := TStringList.Create;
    slWarnings.Add('The parent cells of the following items do not have ownership data.' + #13#10);

    // List of record types to target for ownership updates
    slRecordTypes := TStringList.Create;
    slRecordTypes.Add('ALCH'); // Alchemy
    slRecordTypes.Add('AMMO'); // Ammunition
    slRecordTypes.Add('ARMO'); // Armor
    slRecordTypes.Add('BOOK'); // Books
    slRecordTypes.Add('CONT'); // Containers
    slRecordTypes.Add('FLOR'); // Flora
    slRecordTypes.Add('INGR'); // Ingredients
    slRecordTypes.Add('KEYM'); // Keys
    slRecordTypes.Add('MISC'); // Miscellaneous
    slRecordTypes.Add('SCRL'); // Scrolls
    slRecordTypes.Add('SLGM'); // Soul Gems
    slRecordTypes.Add('WEAP'); // Weapons

    AddMessage('Applying script...');
    AddMessage('-------------------------------------------------------------------------------');
    AddMessage('');
end;

function Process(e: IInterface): integer;
var
    ParentCell, ParentCellOwner, ParentCellOwnerRank, ReferenceOwner, ReferenceOwnerRank: IInterface;
    sFormID, sParentCellID, sParentCellOwner, sParentCellOwnerRank, sReferenceOwner, sReferenceOwnerRank: string;
    i, j: integer;
begin
    Result := 0;

    // -------------------------------------------------------------------------------
    // Restrict processing to REFR records
    // -------------------------------------------------------------------------------
    if Signature(e) <> 'REFR' then
        exit;
		
	filename := GetFileName(GetFile(e));

    // -------------------------------------------------------------------------------
    // Check if the reference has an appropriate record type
    // -------------------------------------------------------------------------------
    j := 0;
    for i := 0 to slRecordTypes.Count - 1 do begin
        if Signature(LinksTo(ElementByName(e, 'NAME - Base'))) <> slRecordTypes[i] then
            j := j + 1;
    end;

    // If the record type is not listed, stop processing record
    if j >= slRecordTypes.Count then
        exit;

    // -------------------------------------------------------------------------------
    // Initialization
    // -------------------------------------------------------------------------------
    sFormID := GetElementEditValues(e, 'Record Header\FormID');

    ParentCell    := LinksTo(ElementByName(e, 'Cell'));
    sParentCellID := GetElementEditValues(ParentCell, 'EDID');

    // -------------------------------------------------------------------------------
    // Check if the parent cell has ownership data
    // -------------------------------------------------------------------------------
    ParentCellOwner := ElementByName(ParentCell, 'Ownership');

    if not Assigned(ParentCellOwner) then begin
        slWarnings.Add(sFormID);
        exit;
    end;

    sParentCellOwner := GetElementEditValues(ParentCell, 'Ownership\XOWN - Owner');

    if pos('NULL', sParentCellOwner) > 0 then begin
        Remove(ParentCellOwner);
        AddMessage('Removed null ownership data from ' + GetElementEditValues(ParentCell, 'Record Header\FormID'));
        exit;
    end;

    // -------------------------------------------------------------------------------
    // Check if the parent cell has owner rank set
    // -------------------------------------------------------------------------------
    ParentCellOwnerRank := ElementByPath(ParentCell, 'Ownership\XRNK - Faction rank');

    if Assigned(ParentCellOwnerRank) then
        sParentCellOwnerRank := GetElementEditValues(ParentCell, 'Ownership\XRNK - Faction rank');

    // -------------------------------------------------------------------------------
    // Check if the reference has ownership data
    // -------------------------------------------------------------------------------
    ReferenceOwner := ElementByName(e, 'Ownership');

    if not Assigned(ReferenceOwner) then begin
        ReferenceOwner := Add(e, 'Ownership', true);
    end;

    sReferenceOwner := GetElementEditValues(e, 'Ownership\XOWN - Owner');

    if CompareStr(sReferenceOwner, sParentCellOwner) <> 0 then
        SetElementEditValues(ReferenceOwner, 'XOWN - Owner', sParentCellOwner)
    else
        exit;

    // -------------------------------------------------------------------------------
    // Check if the sParentCellOwnerRank string is set
    // -------------------------------------------------------------------------------
    if length(sParentCellOwnerRank) > 0 then begin

        ReferenceOwnerRank := ElementByPath(ReferenceOwner, 'XRNK - Faction rank');

        if not Assigned(ReferenceOwnerRank) then begin
            ReferenceOwnerRank := Add(ReferenceOwner, 'XRNK - Faction rank', true);
        end;

        SetElementEditValues(ReferenceOwner, 'XRNK - Faction rank', sParentCellOwnerRank);

        sReferenceOwnerRank := GetElementEditValues(e, 'Ownership\XRNK - Faction rank');

    end;

    sReferenceOwner := GetElementEditValues(e, 'Ownership\XOWN - Owner');

    if length(sReferenceOwnerRank) > 0 then
        slUpdates.Add(sFormID + #13#10 + '-- Set owner to: ' + sReferenceOwner + #13#10 + '-- Set owner rank to: ' + sReferenceOwnerRank + #13#10)
    else
        slUpdates.Add(sFormID + #13#10 + '-- Set owner to: ' + sReferenceOwner + #13#10);

end;

function Finalize: integer;
var
    i, limit: integer;
    dlgSave: TSaveDialog;
begin

    limit := 1;

    AddMessage('-------------------------------------------------------------------------------');
    AddMessage('REFERENCES UPDATED');
    AddMessage('-------------------------------------------------------------------------------');
    AddMessage('');

    if slUpdates.Count > limit then begin

        AddMessage(IntToStr(slUpdates.Count) + ' records were updated. Saving log to file...' + #13#10);
        AddMessage('-------------------------------------------------------------------------------');

        dlgSave := TSaveDialog.Create(nil);
        dlgSave.Options := dlgSave.Options + [ofOverwritePrompt];
        dlgSave.Filter := 'Text files (*.txt)|*.txt';
        dlgSave.InitialDir := ProgramPath;
        dlgSave.FileName := 'fireundubh\' + filename + ' - Ownership Updates.txt';
        if dlgSave.Execute then
            slUpdates.SaveToFile(dlgSave.FileName);
        dlgSave.Free;

    end;

    if slUpdates.Count <= limit then begin

        if slUpdates.Count <> 0 then begin

            for i := 0 to slUpdates.Count - 1 do
                AddMessage(slUpdates[i]);

        end;

        if slUpdates.Count = 0 then begin

            AddMessage(IntToStr(slUpdates.Count) + ' records were updated.' + #13#10);

        end;

    end;

    slUpdates.Clear;

    AddMessage('-------------------------------------------------------------------------------');
    AddMessage('REFERENCES NOT UPDATED');
    AddMessage('-------------------------------------------------------------------------------');
    AddMessage('');

    if slWarnings.Count > limit then begin

        AddMessage(IntToStr(slWarnings.Count) + ' records were not updated. Saving log to file...' + #13#10);
        AddMessage('-------------------------------------------------------------------------------');

        dlgSave := TSaveDialog.Create(nil);
        dlgSave.Options := dlgSave.Options + [ofOverwritePrompt];
        dlgSave.Filter := 'Text files (*.txt)|*.txt';
        dlgSave.InitialDir := ProgramPath;
        dlgSave.FileName := 'fireundubh\' + filename + ' - Ownership Warnings.txt';
        if dlgSave.Execute then
            slWarnings.SaveToFile(dlgSave.FileName);
        dlgSave.Free;

    end;

    if slWarnings.Count <= limit then begin

        if slWarnings.Count <> 1 then begin

            for i := 0 to slWarnings.Count - 1 do
                AddMessage(slWarnings[i]);

            AddMessage('-------------------------------------------------------------------------------');

        end;

        if slWarnings.Count = 1 then begin

            AddMessage('0 records were not updated.' + #13#10);

            AddMessage('-------------------------------------------------------------------------------');

        end;

    end;

    slWarnings.Clear;

    Result := 1;
end;

end.
