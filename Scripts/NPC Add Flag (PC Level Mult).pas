{
	Purpose: Add PC Level Mult flag to NPC
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
		sPath, sPathFlags: string;
		iLevelMult: integer;

	begin

		Result := 0;

		rec := Signature(e);
		sPath := Name(e);

		if (rec = 'NPC_') then begin
		
			sPathFlags := 'ACBS - Configuration\Flags';

			SetElementNativeValues(e, sPathFlags, GetElementNativeValues(e, sPathFlags) or 128);
			AddMessage(sPath + ' now flagged PC Level Mult');
			
		end; // end condition

	end; // end function

// Cleanup
function Finalize: integer;
	begin

		Result := 1;

	end; // end function

end. // end script