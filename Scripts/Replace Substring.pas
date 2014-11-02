{
	Purpose: Replace substring in string
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	sQuerySearch, sQueryReplace, sQueryPrefix, sQuerySuffix: string;
	bCapitalized: boolean;

function Initialize: integer;
begin

	if MessageDlg('Capitalize string [YES] or modify string [NO]?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
		bCapitalized := false
	else
		bCapitalized := true;

	if (bCapitalized <> false) then begin

		if not InputQuery('Enter', 'Search for:', sQuerySearch) then begin
			Result := 1;
			exit;
		end;

		if not InputQuery('Enter', 'Replace with:', sQueryReplace) then begin
			Result := 1;
			exit;
		end;

		if not InputQuery('Enter', 'Add prefix:', sQueryPrefix) then begin
			Result := 1;
			exit;
		end;

		if not InputQuery('Enter', 'Add suffix:', sQuerySuffix) then begin
			Result := 1;
			exit;
		end;

	end;

end;

function Capitalize(const s: string): string;
	var
		flag: boolean;
		i: Byte;
		t: string;

	begin

		if s <> '' then begin

			flag := true;
			t := '';

			for i := 1 to Length(s) do begin

				if flag then
					t := t+ UpperCase(s[i])
				else
					t := t+ s[i];
					flag := (s[i] = ' ')

			end;

		end
			else t:='';

		result := t;
	end;

function Process(e: IInterface): integer;
var
	signature: IInterface;
	source, target: string;
begin
	Result := 0;

	signature := 'FULL';
	//signature := 'Responses\Response\NAM1';
	   source := GetElementEditValues(e, signature);

	AddMessage('Processing: ' + FullPath(e));

	if (bCapitalized = false) then begin

		if length(source) > 0 then begin

			SetElementEditValues(e, signature, Capitalize(source));
			exit;

		end;

	end;

	if (pos(sQuerySearch, source) > 0) then begin

		if length(sQuerySearch) > 0 then begin
			source := GetElementEditValues(e, signature);
			target := StringReplace(source, sQuerySearch, sQueryReplace, [rfReplaceAll, rfIgnoreCase]);
			SetElementEditValues(e, signature, target);
		end;

	end;

		if length(sQueryPrefix) > 0 then begin
			source := GetElementEditValues(e, signature);
			target := Insert(sQueryPrefix, source, 0);
			SetElementEditValues(e, signature, target);
		end;

		if length(sQuerySuffix) > 0 then begin
			source := GetElementEditValues(e, signature);
			target := Insert(sQuerySuffix, source, length(source) + 1);
			SetElementEditValues(e, signature, target);
		end;

end;

function Finalize: integer;
begin
	Result := 1;
	exit;
end;

end.
