{
	Purpose: List referenced by
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
		ref: IInterface;
		formid, name: string;
		i, refcount: integer;
	begin
		Result := 0;
		
		refcount := ReferencedByCount(MasterOrSelf(e));
		AddMessage( 'Found ' + IntToStr( refcount ) + ' references...' );

		if refcount > 0 then begin
		
			for i := 0 to refcount - 1 do begin
				ref := ReferencedByIndex(MasterOrSelf(e), i);
				formid := GetEditValue(ElementByPath(ref, 'Record Header\FormID'));
				//if Signature(ref) = 'NPC_' then
				AddMessage( IntToStr(i + 1) + '	' + formid );
			end;
			
		end;

	end;

function Finalize: integer;
	begin
		Result := 0;
	end;

end.
