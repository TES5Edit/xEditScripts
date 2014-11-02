{
	Purpose: List Reference Names
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	i: integer;

function Initialize: integer;
begin
	Result := 0;
end;

function Process(e: IInterface): integer;
var
	rec: IInterface;
	formid, name: string;
begin
	Result := 0;
		
	formid := GetElementEditValues(e, 'Record Header\FormID');
	name   := GetElementEditValues(e, 'NAME');

	AddMessage(name + '	' + formid);
end;

function Finalize: integer;
begin
	Result := 0;
end;

end.
