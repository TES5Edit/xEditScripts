{
	Purpose: List spell base effects
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	a, b, c: integer;
	lBaseEffects: TStringList;

function Initialize: integer;
	begin
	
		lBaseEffects := TStringList.Create;
		lBaseEffects.Sorted := True;
		lBaseEffects.Duplicates := dupIgnore;

	end;

function Process(e: IInterface): integer;
	var
		rec: IInterface;
		sPath: string;

		// MGEF
		effects, effect, base: IInterface;
		sPathEffects, sBase: string;
		iEffects, iEffect: integer;

	begin

		Result := 0;

		rec := Signature(e);
		sPath := Name(e);

		if (rec = 'SPEL') then begin

			effects := ElementByPath(e, 'Effects');
			iEffects := ElementCount(effects);

			for a := 0 to iEffects - 1 do begin

				effect := ElementByIndex(effects, a);

				iEffect := ElementCount(effect);

				for b := 0 to iEffect - 1 do begin

					base := ElementByIndex(effect, b);
					sBase := GetEditValue(base);

					lBaseEffects.Add(sBase);

				end;

			end;

		end; // end condition

	end; // end function

function Finalize: integer;
	begin
	
		lBaseEffects.Sort;
		
		for c := 0 to lBaseEffects.Count - 1 do begin
		
			AddMessage(lBaseEffects[c]);
		
		end;
		
		lBaseEffects.Clear;

		Result := 1;

	end; // end function

end. // end script