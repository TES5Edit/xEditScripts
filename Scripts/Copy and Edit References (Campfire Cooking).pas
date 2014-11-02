{
	Purpose: List model paths
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
  slReferences: TStringList;

function Initialize: integer;
	begin
		Result := 0;
		
		slReferences := TStringList.Create;
		slReferences.Add('00035F49'); // Campfire01Burning
		slReferences.Add('00035F47'); // Campfire01LandBurning
		slReferences.Add('000A9230'); // Campfire01LandBurning_Heavy_SN
		slReferences.Add('00090CA4'); // Campfire01LandBurning_ReachDirt01
		slReferences.Add('0010D820'); // Campfire01LandBurningCaveBaseGround02
		slReferences.Add('000C2BF1'); // Campfire01LandBurningCoastalBeach01
		slReferences.Add('000DB682'); // Campfire01LandBurningDirt01
		slReferences.Add('000C6918'); // Campfire01LandBurningFallForestDirt01
		slReferences.Add('000FB9B0'); // Campfire01LandBurningFieldGrass01
		slReferences.Add('000CBB23'); // Campfire01LandBurningFrozenMarshDirtSlope01
		slReferences.Add('000B6C08'); // Campfire01LandBurningPineForest01
		slReferences.Add('000951D8'); // Campfire01LandBurningReachDirt01
		slReferences.Add('000E7C9A'); // Campfire01LandBurningRiverBedEdge01
		slReferences.Add('000CBB2F'); // Campfire01LandBurningRocks01
		slReferences.Add('00101A51'); // Campfire01LandBurningTundra01
	end;

function Process(e: IInterface): integer;
	var
		r, rec: IInterface;
		query, formid, name, checkname: string;
		j, refcount: integer;
	begin
		Result := 0;
	
		if Signature(e) <> 'REFR' then
			exit;
		
		formid := GetEditValue(ElementByPath(e, 'Record Header\FormID'));
		name := GetEditValue(ElementByPath(e, 'NAME'));
		refcount := slReferences.Count - 1;
		
		for j := 0 to refcount do begin
			
			if (pos(slReferences[j], name) > 0) then begin

				AddMessage('Copying: ' + formid);
				r := wbCopyElementToFile(e, FileByLoadOrder(04), true, true); // Change this to the right file
				
				if not Assigned(r) then begin
					AddMessage('Can''t copy record as new');
					Result := 1;
					Exit;
				end;
				
				if (pos(slReferences[0], name) > 0) then
					SetElementEditValues(r, 'NAME', 'dubhBenchCampfire01Burning [FURN:02FF1234]');
				if (pos(slReferences[1], name) > 0) then
					SetElementEditValues(r, 'NAME', 'dubhBenchCampfire01LandBurning [FURN:02FF1235]');
				if (pos(slReferences[2], name) > 0) then
					SetElementEditValues(r, 'NAME', 'dubhBenchCampfire01LandBurning_Heavy_SN [FURN:02FF1241]');
				if (pos(slReferences[3], name) > 0) then
					SetElementEditValues(r, 'NAME', 'dubhBenchCampfire01LandBurning_ReachDirt01 [FURN:02FF1242]');
				if (pos(slReferences[4], name) > 0) then
					SetElementEditValues(r, 'NAME', 'dubhBenchCampfire01LandBurningCaveBaseGround02 [FURN:02FF1236]');
				if (pos(slReferences[5], name) > 0) then
					SetElementEditValues(r, 'NAME', 'dubhBenchCampfire01LandBurningCoastalBeach01 [FURN:02FF1237]');
				if (pos(slReferences[6], name) > 0) then
					SetElementEditValues(r, 'NAME', 'dubhBenchCampfire01LandBurningDirt01 [FURN:02FF1238]');
				if (pos(slReferences[7], name) > 0) then
					SetElementEditValues(r, 'NAME', 'dubhBenchCampfire01LandBurningFallForestDirt01 [FURN:02FF1239]');
				if (pos(slReferences[8], name) > 0) then
					SetElementEditValues(r, 'NAME', 'dubhBenchCampfire01LandBurningFieldGrass01 [FURN:02FF123A]');
				if (pos(slReferences[9], name) > 0) then
					SetElementEditValues(r, 'NAME', 'dubhBenchCampfire01LandBurningFrozenMarshDirtSlope01 [FURN:02FF123B]');
				if (pos(slReferences[10], name) > 0) then
					SetElementEditValues(r, 'NAME', 'dubhBenchCampfire01LandBurningPineForest01 [FURN:02FF123C]');
				if (pos(slReferences[11], name) > 0) then
					SetElementEditValues(r, 'NAME', 'dubhBenchCampfire01LandBurningReachDirt01 [FURN:02FF123D]');
				if (pos(slReferences[12], name) > 0) then
					SetElementEditValues(r, 'NAME', 'dubhBenchCampfire01LandBurningRiverBedEdge01 [FURN:02FF123E]');
				if (pos(slReferences[13], name) > 0) then
					SetElementEditValues(r, 'NAME', 'dubhBenchCampfire01LandBurningRocks01 [FURN:02FF123F]');
				if (pos(slReferences[14], name) > 0) then
					SetElementEditValues(r, 'NAME', 'dubhBenchCampfire01LandBurningTundra01 [FURN:02FF1240]');
					
				SetLoadOrderFormID(r, GetLoadOrderFormID(e)); // copies load order for overrides
					
			end;
		end;

	end;

function Finalize: integer;
	begin
		Result := 0;
	end;

end.
