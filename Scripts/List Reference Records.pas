{
	Purpose: List model paths
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

function Initialize: integer;
	begin
		Result := 0;
	end;

function Process(e: IInterface): integer;
	var
		rec: IInterface;
		query, formid, name: string;
	begin
		Result := 0;

		query := 'dubh';
		
		formid := GetEditValue(ElementByPath(e, 'Record Header\FormID'));
		name := GetEditValue(ElementByPath(e, 'EDID'));
		if (pos(lowercase(query), lowercase(name)) > 0) then begin
			AddMessage(formid);
			//AddMessage('SetElementEditValues(r, ''NAME'', ''' + formid + ''');');
		end;

	end;

function Finalize: integer;
	begin
		Result := 0;
	end;

end.
