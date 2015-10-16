{
	Purpose: Count Doors
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.2
}

unit UserScript;

var
	i: integer;

function GetElement(x: IInterface; s: string): IInterface;
begin
	if (pos('[', s) > 0) then
		Result := ElementByIP(x, s)
	else if (pos('\', s) > 0) then
		Result := ElementByPath(x, s)
	else if (s = Uppercase(s)) then
		Result := ElementBySignature(x, s)
	else
		Result := ElementByName(x, s);
end;

function Initialize: integer;
begin
	i := 0;
end;

function Process(e: IInterface): integer;
var
	r, xt: IInterface;
	rn: string;
begin
	if Signature(e) = 'REFR' then begin
		if IsMaster(e) then begin
			r := GetElement(e, 'NAME');
			rn := GetEditValue(r);
			
			if pos('DOOR:', rn) > 0 then begin
				xt := GetElement(e, 'XTEL');
				if Assigned(GetElement(xt, 'Door')) then
					i := i + 1;
			end;
		end;
	end;
end;

function Finalize: integer;
begin
	AddMessage('Found ' + IntToStr(i) + ' doors.');
end;

end.
