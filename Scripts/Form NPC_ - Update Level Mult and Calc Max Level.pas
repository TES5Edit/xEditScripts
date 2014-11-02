{
	Purpose: Make NPC Level with Player
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	a, b, c: integer;
	//fMult: float;

// Called before processing
function Initialize: integer;
	begin

		//fMult := (InputBox('Set Multiplier', 'Mult:', 1.5));
	
	end;

function Process(e: IInterface): integer;
	var
		rec: IInterface;
		sPath, sPathLevelMult, sPathMaxLevel: string;
		iLevelMult, iMaxLevel: integer;

	begin

		Result := 0;

		rec := Signature(e);
		sPath := Name(e);

		if (rec = 'NPC_') then begin
		
			sPathLevelMult := 'ACBS\Level Mult';
			sPathMaxLevel  := 'ACBS\Calc max level';
		
			iLevelMult := GetElementNativeValues(e, sPathLevelMult);
			if iLevelMult <> 1.0 then begin
				SetElementNativeValues(e, sPathLevelMult, 1.0);
				AddMessage(sPath + ' now matches the level of the player');
			end;
			
			iMaxLevel := GetElementNativeValues(e, sPathMaxLevel);
			if iMaxLevel <> 80 then begin
				SetElementNativeValues(e, sPathMaxLevel, 80);
				AddMessage(sPath + ' now can reach Level 80');
			end;
			
		end; // end condition

	end; // end function

// Cleanup
function Finalize: integer;
	begin

		Result := 1;

	end; // end function

end. // end script