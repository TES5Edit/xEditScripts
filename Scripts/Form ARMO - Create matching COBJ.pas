{
	Purpose: Create matching COBJ from MISC
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
  baserecord: IInterface;
  
//============================================================================
function Initialize: integer;
	begin
		// RecipeIngotIron [COBJ:000A30C3]
		baserecord := RecordByFormID(FileByIndex(0), $000A30C3, true);
		if not Assigned(baserecord) then begin
			AddMessage('Can not find base record');
			Result := 1;
			Exit;
		end;
	end;

//============================================================================
function Process(e: IInterface): integer;
	var
		r, kwda: IInterface;
		formid: Cardinal;
		keyword, bnam, cnam: string;
		i, iMaterials: integer;
	
	begin
		if Signature(e) <> 'ARMO' then
			Exit;
			
		iMaterials := 0;
		
		kwda := ElementBySignature(e, 'KWDA');
		for i := 0 to ElementCount(kwda) - 1 do begin
			keyword := lowercase(GetEditValue(ElementByIndex(kwda, i)));
			AddMessage(keyword);
				
			if (pos('daedric', keyword) > 0) then begin
				iMaterials := iMaterials + 1;
				bnam := 'CraftingSmelter [KYWD:000A5CCE]';
				cnam := 'OreEbony "Ebony Ore" [MISC:0005ACDC]';
			end;
			
			if (pos('dragonplate', keyword) > 0) then begin
				iMaterials := iMaterials + 1;
				bnam := 'CraftingSmelter [KYWD:000A5CCE]';
				cnam := 'DragonBone "Dragon Bone" [MISC:0003ADA4]';
			end;
			
			if (pos('dragonscale', keyword) > 0) then begin
				iMaterials := iMaterials + 1;
				bnam := 'CraftingSmelter [KYWD:000A5CCE]';
				cnam := 'DragonScales "Dragon Scales" [MISC:0003ADA3]';
			end;
			
			if (pos('dwarven', keyword) > 0) then begin
				iMaterials := iMaterials + 1;
				bnam := 'CraftingSmelter [KYWD:000A5CCE]';
				cnam := 'DwarvenScrapBent "Bent Dwemer Scrap Metal" [MISC:000C886C]';
			end;
			
			if (pos('ebony', keyword) > 0) then begin
				iMaterials := iMaterials + 1;
				bnam := 'CraftingSmelter [KYWD:000A5CCE]';
				cnam := 'OreEbony "Ebony Ore" [MISC:0005ACDC]';
			end;
			
			if (pos('elven', keyword) > 0) then begin
				iMaterials := iMaterials + 1;
				bnam := 'CraftingSmelter [KYWD:000A5CCE]';
				cnam := 'OreMoonstone "Moonstone Ore" [MISC:0005ACE0]';
			end;
			
			if (pos('glass', keyword) > 0) then begin
				iMaterials := iMaterials + 1;
				bnam := 'CraftingSmelter [KYWD:000A5CCE]';
				cnam := 'OreMalachite "Malachite Ore" [MISC:0005ACE1]';
			end;
			
			if (pos('iron', keyword) > 0) then begin
				iMaterials := iMaterials + 1;
				bnam := 'CraftingSmelter [KYWD:000A5CCE]';
				cnam := 'OreIron "Iron Ore" [MISC:00071CF3]';
			end;
			
			if (pos('leather', keyword) > 0) then begin
				iMaterials := iMaterials + 1;
				bnam := 'CraftingTanningRack [KYWD:0007866A]';
				cnam := 'Leather01 "Leather" [MISC:000DB5D2]';
			end;
			
			if (pos('hide', keyword) > 0) then begin
				iMaterials := iMaterials + 1;
				bnam := 'CraftingTanningRack [KYWD:0007866A]';
				cnam := 'Leather01 "Leather" [MISC:000DB5D2]';
			end;
			
			if (pos('orcish', keyword) > 0) then begin
				iMaterials := iMaterials + 1;
				bnam := 'CraftingSmelter [KYWD:000A5CCE]';
				cnam := 'OreOrichalcum "Orichalcum Ore" [MISC:0005ACDD]';
			end;
			
			if (pos('steel', keyword) > 0) or (pos('advanced', keyword) > 0) then begin
				iMaterials := iMaterials + 1;
				bnam := 'CraftingSmelter [KYWD:000A5CCE]';
				cnam := 'OreCorundum "CorundumOre" [MISC:0005ACDB]';
			end;
			
		end;
		
		AddMessage(IntToStr(iMaterials) + ' materials found...');
		
		r := wbCopyElementToFile(baserecord, GetFile(e), true, true);
		if not Assigned(r) then begin
			AddMessage('Can''t copy base record as new');
			Result := 1;
			Exit;
		end;
		
		SetElementEditValues(r, 'EDID', 'dubhBreakdown' + GetElementEditValues(e, 'EDID'));
		SetElementEditValues(r, 'COCT', 1);
		SetElementEditValues(r, 'DESC', GetElementEditValues(e, 'FULL'));
		SetElementEditValues(r, 'Items\Item\CNTO\Item', GetEditValue(ElementByPath(e, 'Record Header\FormID')));
		SetElementEditValues(r, 'Items\Item\CNTO\Count', 1);
		
		if (iMaterials > 0)) then begin
			SetElementEditValues(r, 'CNAM', cnam);
			SetElementEditValues(r, 'BNAM', bnam);
			SetElementEditValues(r, 'NAM1', 1);
		end;
		if (iMaterials = 0) then begin
			SetElementEditValues(r, 'CNAM', 'IngotIron "Iron Ingot" [MISC:0005ACE4]');
			SetElementEditValues(r, 'BNAM', 'CraftingSmelter [KYWD:000A5CCE]');
			SetElementEditValues(r, 'NAM1', 1);
		end;
		
		formid := GetLoadOrderFormID(e);
		RemoveNode(e);
		SetLoadOrderFormID(r, formid);
	end;
	
//function Finalize: integer;
//  begin
//    AddMessage(' ');
//    Result := 1;
//  end;

end.