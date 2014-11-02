{
	Purpose: Delete Referenced By In File
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
		formid, name, sFileRef, sFileSel: string;
		i, refcount: integer;
	begin
		Result := 0;

		refcount := ReferencedByCount(MasterOrSelf(e));

		if refcount > 0 then begin

			for i := 0 to refcount - 1 do begin

				ref := ReferencedByIndex(MasterOrSelf(e), i);
				formid := GetEditValue(ElementByPath(ref, 'Record Header\FormID'));

				sFileRef := GetFileName(GetFile(ref));
				sFileSel := GetFileName(GetFile(e));

				if refcount > 1 && sFileRef = sFileSel then begin

					RemoveNode(ref);
					AddMessage( 'Removed: ' + GetEditValue(ElementByPath(ref, 'Record Header\FormID')) );

				end;

			end;

		end;

	end;

function Finalize: integer;
	begin
		Result := 0;
	end;

end.
