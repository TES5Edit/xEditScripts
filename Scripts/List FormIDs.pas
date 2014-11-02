{
	Purpose: List forms
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	i: integer;
	slResults: TStringList;

function Initialize: integer;

	begin

		Result := 0;

		i := 0;
		
		slResults := TStringList.Create;

		ClearMessages();

	end;

function Process(e: IInterface): integer;

	var
		rec: IInterface;
		formid, name, full, lctn, itemid: string;

	begin

		Result := 0;

		//if Signature(e) <> 'NAVM' then exit;

		i := i + 1;

		formid := IntToHex(FixedFormID(e),8);
		//name := GetEditValue(ElementByPath(e, 'EDID'));
		//full := GetEditValue(ElementByPath(e, 'FULL'));
		//lctn := GetEditValue(ElementByPath(e, 'DATA\Location'));
		itemid := GetEditValue(ElementByPath(e, 'Record Header\FormID'));
		//AddMessage('player.additem ' + formid + ' 1');
		//AddMessage(formid + '	' + name + '	' + full + '	' + lctn);
		//AddMessage(full);
		//AddMessage(name);
		//AddMessage(itemid);
		slResults.Add('player.additem ' + formid + ' 10');

	end;

function Finalize: integer;

	begin

		for i := slResults.Count - 1 downto 0 do
			AddMessage(slResults[i]);

		Result := 1;
		exit;

	end;

end.
