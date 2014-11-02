{
	Purpose: Keyword Search - Location
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	sQuery: string;

function Initialize: integer;
	begin

		Result := 0;
		
		if not InputQuery('Enter', 'Search Query:', sQuery) then begin
			Result := 1;
			exit;
		end; // end if
		
		if sQuery = '' then begin
			Result := 1;
			exit;
		end; // end if
		
		AddMessage('-------------------------------------------------------------------------------');
		
	end; // end begin

function Process(e: IInterface): integer;
	var
		FORM, TARGET, NAME: IInterface;
		sForm, sName, sTarget: string;

	begin
		Result := 0;

		//if Signature(e) <> 'REFR' then
		//	exit;

		FORM   := ElementByPath(e, 'Record Header\FormID');
		NAME   := ElementByPath(e, 'EDID');
		TARGET := ElementByPath(e, 'DATA\Location');

		sForm   := GetEditValue(FORM);
		sName	:= GetEditValue(NAME);
		sTarget := GetEditValue(TARGET);
			
		if pos(lowercase(sQuery), lowercase(sTarget)) > 0 then begin
			AddMessage('Match: ' + sName + '	' + sForm);
		end;

	end;

function Finalize: integer;
	var
		i: integer;
	begin
	
		AddMessage('-------------------------------------------------------------------------------');
		Result := 1;
	end;

end.
