{
	Purpose: List model paths
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
		i := 0;	
	end;

function Process(e: IInterface): integer;
	var
		rec: IInterface;
		query, formid, name, posx, posy, posz, rotx, roty, rotz: string;
	begin
		Result := 0;

		query := 'WEAP:';
		
		if Signature(e) <> 'REFR' then
			exit;
		
		formid := GetEditValue(ElementByPath(e, 'Record Header\FormID'));
		name := GetEditValue(ElementByPath(e, 'NAME'));
		posx := GetEditValue(ElementByPath(e, 'DATA\Position\X'));
		posy := GetEditValue(ElementByPath(e, 'DATA\Position\Y'));
		posz := GetEditValue(ElementByPath(e, 'DATA\Position\Z'));
		rotx := GetEditValue(ElementByPath(e, 'DATA\Rotation\X'));
		roty := GetEditValue(ElementByPath(e, 'DATA\Rotation\Y'));
		rotz := GetEditValue(ElementByPath(e, 'DATA\Rotation\Z'));
		if (pos(lowercase(query), lowercase(name)) > 0) then begin
			//i := i + 1;
			AddMessage(GetFileName(GetFile(e)) + '	' + name + '	' + posx + '	' + posy + '	' + posz + '	' + rotx + '	' + roty + '	' + rotz);
		end;

	end;

function Finalize: integer;
	begin
		Result := 0;
	end;

end.
