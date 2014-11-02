{
	Purpose: Make NPCs Protected
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	a, b, c: integer;
	
// Called before processing
function Initialize: integer;
	begin
		AddMessage('-------------------------------------------------------------------------------');
	end;
	
function StripHTML(S: string): string;
	var
		TagBegin, TagEnd, TagLength: integer;
	begin
		TagBegin := Pos('<', S);
		
		while (TagBegin > 0) do begin
			TagEnd := Pos('>', S);
			TagLength := TagEnd - TagBegin + 1;
			Delete(S, TagBegin, TagLength);
			TagBegin := Pos('<', S);
		end;
		
	Result := S;
end;

function StripPageBreak(S: string): string;
	var
		TagBegin, TagEnd, TagLength: integer;
	begin
		TagBegin := Pos('[', S);
		
		while (TagBegin > 0) do begin
			TagEnd := Pos(']', S);
			TagLength := TagEnd - TagBegin + 1;
			Delete(S, TagBegin, TagLength);
			TagBegin := Pos('[', S);
		end;
		
	Result := S;
end;

function DeleteSpaces(Str: string): string;
var
  i: Integer;
begin
  i:=0;
  while i<=Length(Str) do
    if Str[i]=' ' then Delete(Str, i, 1)
    else Inc(i);
  Result:=Str;
end;

// Processing
function Process(e: IInterface): integer;
	var
		rec: IInterface;
		sID, sPath, sPathDesc, sDesc: string;
		i, iCharacterCount: integer;

	begin

		Result := 0;

		rec := Signature(e);
		sPath := Name(e);

		if (rec = 'BOOK') then begin

			sPathDesc := 'DESC';
			
			//sDesc := GetElementEditValues(e, sPathDesc);
			//iCharacterCount := Length(sDesc);
			//AddMessage(IntToStr(iCharacterCount) + ' characters before stripping tags');
			
			sDesc := StripHTML(GetElementEditValues(e, sPathDesc));
			//iCharacterCount := Length(sDesc);
			//AddMessage(IntToStr(iCharacterCount) + ' characters after stripping HTML');
			
			sDesc := StripPageBreak(sDesc);
			//iCharacterCount := Length(sDesc);
			//AddMessage(IntToStr(iCharacterCount) + ' characters after stripping page breaks');
			
			sDesc := Trim(sDesc);
			sDesc := StringReplace(sDesc,#9,' ',[rfReplaceAll]);
			sDesc := StringReplace(sDesc,#13,' ',[rfReplaceAll]);
			sDesc := StringReplace(sDesc,#10,' ',[rfReplaceAll]);
			sDesc := DeleteSpaces(sDesc);
			
			iCharacterCount := Length(sDesc);
			sID := GetElementEditValues(e, 'EDID');
			//AddMessage(sID + '	' + IntToStr(iCharacterCount) + '	' + IntToStr(iCharacterCount / 4.8));
			AddMessage(sID + '	' + IntToStr(iCharacterCount));
			//AddMessage(sDesc);
			
		end; // end condition

	end; // end function

// Cleanup
function Finalize: integer;
	begin

		AddMessage('-------------------------------------------------------------------------------');
		Result := 1;

	end; // end function

end. // end script
