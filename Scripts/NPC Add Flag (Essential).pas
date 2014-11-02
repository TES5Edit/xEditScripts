{
	Purpose: Add essential flag to NPC
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	a, b, c: integer;
	
// Called before processing
function Initialize: integer;
	begin
	
	end;

// Processing
function Process(e: IInterface): integer;
	var
		rec: IInterface;
		sPath, sPathFlags: string;

	begin

		Result := 0;

		rec := Signature(e);
		sPath := Name(e);

		if (rec = 'NPC_') then begin
		
			sPathFlags := 'ACBS\Flags';
		
			SetElementNativeValues(e, sPathFlags, GetElementNativeValues(e, sPathFlags) or 1);
			AddMessage(sPath + ' now flagged Essential');
			
		end; // end condition

	end; // end function

// Cleanup
function Finalize: integer;
	begin

		Result := 1;

	end; // end function

end. // end script