{
	Purpose: Make NPCs Protected
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

function Process(e: IInterface): integer;
	var
		rec: IInterface;
		sPath, sPathFlags: string;
		sPath0, sPath1, sPath3, sPath4, sPath5, sPath6, sPath7, sPath11, sPath14, sPath16, sPath31: string;

	begin

		Result := 0;

		rec := Signature(e);
		sPath := Name(e);

		if (rec = 'NPC_') then begin

			sPathFlags := 'ACBS\Flags';
			sPath0  := 'ACBS\Flags\Female';
			sPath1  := 'ACBS\Flags\Essential';
			sPath3  := 'ACBS\Flags\Respawn';
			sPath4  := 'ACBS\Flags\Auto-calc stats';
			sPath5  := 'ACBS\Flags\Unique';
			sPath7  := 'ACBS\Flags\PC Level Mult';
			sPath11 := 'ACBS\Flags\Protected';
			sPath14 := 'ACBS\Flags\Summonable';
			sPath31 := 'ACBS\Flags\Invulnerable';

			// REMOVE 'ESSENTIAL' FLAG
			if ElementExists(e, sPath1) then
				begin
					SetElementEditValues(e, sPath1, 0);
					AddMessage(sPath + ' is no longer Essential');
				end;
				
			// REMOVE 'INVULNERABLE' FLAG
			if ElementExists(e, sPath31) then
				begin
					SetElementEditValues(e, sPath31, 0);
					AddMessage(sPath + ' is no longer Invulnerable');
				end;

			// ADD 'AUTO-CALC STATS' FLAG
			if GetElementEditValues(e, sPath4) = 0 then
				begin
					SetElementNativeValues(e, sPathFlags, GetElementNativeValues(e, sPathFlags) or 16);
					AddMessage(sPath + ' is flagged Auto-Calc Stats');
				end;

			// ADD 'UNIQUE' FLAG
			if GetElementEditValues(e, sPath5) = 0 then
				begin
					SetElementNativeValues(e, sPathFlags, GetElementNativeValues(e, sPathFlags) or 32);
					AddMessage(sPath + ' is flagged Unique');
				end;

			// ADD 'PC LEVEL MULT' FLAG
			if GetElementEditValues(e, sPath7) = 0 then
				begin
					SetElementNativeValues(e, sPathFlags, GetElementNativeValues(e, sPathFlags) or 128);
					AddMessage(sPath + ' is flagged PC Level Mult');
				end;

			// ADD 'PROTECTED' FLAG
			if GetElementEditValues(e, sPath11) = 0 then
				begin
					SetElementNativeValues(e, sPathFlags, GetElementNativeValues(e, sPathFlags) or 2048);
					AddMessage(sPath + ' is flagged Protected');
				end;

			// CHANGE 'LEVEL MULT' TO 1.00
			if GetElementEditValues(e, 'ACBS\Level Mult') <> 1.0 then
				begin
					SetElementEditValues(e, 'ACBS\Level Mult', 1.0);
					AddMessage(sPath + ' now levels up with the player');
				end;

			// CHANGE 'CALC MAX LEVEL' TO 80
			if GetElementEditValues(e, 'ACBS\Calc max level') <> 81 then
				begin
					SetElementEditValues(e, 'ACBS\Calc max level', 81);
					AddMessage(sPath + ' can now level up to 81');
				end;

			// CHANGE 'SPEED MULTIPLIER' TO 100
			if GetElementEditValues(e, 'ACBS\Speed Multiplier') <> 100 then
				begin
					SetElementEditValues(e, 'ACBS\Speed Multiplier', 100);
					AddMessage(sPath + ' has a new speed of 100 (normal)');
				end;

		end; // end condition

	end; // end function

// Cleanup
function Finalize: integer;
	begin

		Result := 1;

	end; // end function

end. // end script