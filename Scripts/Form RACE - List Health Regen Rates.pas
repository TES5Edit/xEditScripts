{
	Purpose: Change CNAM to Bone Meal
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

function Process(e: IInterface): integer;
	var
		kwda: IInterface;
		full, keyword: string;
		hpregen: float;
		i: integer;
	begin
		Result := 0;

		full := GetElementEditValues(e, 'FULL');
		hpregen := GetElementEditValues(e, 'DATA\Health Regen');
		
		kwda := ElementBySignature(e, 'KWDA');
		for i := 0 to ElementCount(kwda) - 1 do begin
			keyword := lowercase(GetEditValue(ElementByIndex(kwda, i)));
			if pos('animal', keyword) > 0 then begin
				AddMessage(full + '	' + IntToStr(hpregen));
			end;
		end;
		
	end;

function Finalize: integer;
	begin
		Result := 1;
	end;

end.
