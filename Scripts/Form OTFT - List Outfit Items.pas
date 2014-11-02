{
	Purpose: OTFT - List INAM Items
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
		rec, list, ref, item: IInterface;
		formid, edid, full, itemid: string;
		i: integer;
	begin
		Result := 0;

		list := ElementByName(e, 'INAM - Items');

		AddMessage('-------------------------------------------------------------------------------');

		for i := 0 to ElementCount(list) - 1 do begin
			item	:= ElementByIndex(list, i);
			ref		:= LinksTo(item);
			formid	:= IntToHex(FixedFormID(ref), 8);
			edid	:= GetElementEditValues(ref, 'EDID');
			full	:= GetElementEditValues(ref, 'FULL');
			itemid	:= GetEditValue(item);
			
			AddMessage(itemid);
		end;

		AddMessage('-------------------------------------------------------------------------------');

	end;

function Finalize: integer;
	begin
		Result := 1;
	end;

end.
