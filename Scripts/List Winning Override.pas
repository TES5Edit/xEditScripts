{
	Purpose: List Winning Override
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	slOverrides: TStringList;

function Initialize: integer;

	begin

		Result := 0;
		
		slOverrides := TStringList.Create;
		
		ClearMessages();

	end;

function Process(e: IInterface): integer;

	var
		sRecOverride: string;

	begin

		Result := 0;

		sRecOverride := GetFileName(GetFile(WinningOverride(e)));

		slOverrides.Add(sRecOverride + ' overrides:		' + GetElementEditValues(e, 'Record Header\FormID'));

	end;

function Finalize: integer;
	var
		i: integer;
		
	begin

		for i := slOverrides.Count - 1 downto 0 do
			AddMessage(slOverrides[i]);

		AddMessage('');
		Result := 0;
		exit;

	end;

end.
