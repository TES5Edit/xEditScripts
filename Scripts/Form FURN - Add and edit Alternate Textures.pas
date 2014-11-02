{
	Purpose: Add and edit Alternate Textures
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;
  
//============================================================================
function Initialize: integer;
	begin

	end;

//============================================================================
function Process(e: IInterface): integer;
	var
		model, mods: IInterface;
	
	begin
	
		model := ElementByName(e, 'Model');
		if not ElementExists(model, 'MODS') then
			AddMessage('MODS added');
			Add(model, 'MODS', true);
		
		if ElementExists(model, 'MODS') then begin
			AddMessage('MODS exists');
			mods := ElementBySignature(model, 'MODS');
			ElementAssign(mods, HighInteger, nil, true);			
		end;

	end;
	
function Finalize: integer;
  begin
    AddMessage(' ');
    Result := 1;
		exit;
  end;

end.