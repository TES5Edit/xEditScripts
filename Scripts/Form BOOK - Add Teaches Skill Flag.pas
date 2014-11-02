{
	Purpose: Make NPCs Protected
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

		if (rec = 'BOOK') then begin
		
			

				sPathFlags := 'DATA\Flags';

				if (GetElementEditValues(e, 'DATA\Type') = 'Note/Scroll') then

					RemoveNode(e)
					
				//else if pos('Recipe:', GetElementEditValues(e, 'FULL')) > 0 then
                //
				//	RemoveNode(e)
                //
				//else if (GetElementNativeValues(e, sPathFlags) = 1) and (GetElementEditValues(e, 'DATA\Skill') <> 'Smithing') then
                //
				//	RemoveNode(e)
				//	
				//else if (GetElementNativeValues(e, sPathFlags) = 4) then
                //
				//	RemoveNode(e)

				else if (GetElementEditValues(e, 'DATA\Type') = 'Book/Tome') then begin

					if GetElementEditValues(e, 'DATA\Skill') <> 'Speech' then begin
					
						SetElementNativeValues(e, sPathFlags, GetElementNativeValues(e, sPathFlags) or 1);
						SetElementEditValues(e, 'DATA\Skill', 'Speech');
						AddMessage(sPath + ' now flagged Teaches Skill: Speech');
					
					end;
		
				end;
			
		end; // end condition

	end; // end function

// Cleanup
function Finalize: integer;
	begin

		Result := 1;

	end; // end function

end. // end script
