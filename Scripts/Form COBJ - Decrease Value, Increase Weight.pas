{
	Purpose: Decrease Value, Increase Weight
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

function Initialize: integer;

	begin

		ClearMessages();

	end;

function Process(e: IInterface): integer;
	var
		input, output: IInterface;
		
		output_quantity: integer;
		output_value: integer;
		output_weight: float;

	begin
		Result := 0;

		// Exit if cell or worldspace is not selected
		if Signature(e) <> 'COBJ' then
			exit;
		
		e := WinningOverride(e);
		
		AddMessage(FullPath(e));
		
		input			:= ElementByPath(e, 'Items\Item\CNTO\Item');
		
		output			:= ElementByPath(e, 'CNAM');
		output_quantity	:= GetElementEditValues(e, 'NAM1');
		
		if Signature(WinningOverride(LinksTo(output))) <> 'ALCH' then begin
		
			output_value	:= GetElementEditValues(WinningOverride(LinksTo(output)), 'DATA\Value');
			if output_value = 0 then
				output_value := 1;
				
			output_weight	:= GetElementEditValues(WinningOverride(LinksTo(output)), 'DATA\Weight');
			if output_weight = 0.0 then
				output_weight := 0.1;
		
			SetElementEditValues(WinningOverride(LinksTo(input)), 'DATA\Value', round(output_quantity * (output_value / 1.5)));
		
			SetElementEditValues(WinningOverride(LinksTo(input)), 'DATA\Weight', output_quantity * (output_weight * 2.5));
		
		end;
		
		if Signature(WinningOverride(LinksTo(output))) = 'ALCH' then begin
		
			output_weight	:= GetElementEditValues(WinningOverride(LinksTo(output)), 'DATA - Weight');
			if output_weight = 0.0 then
				output_weight := 0.1;
		
			SetElementEditValues(WinningOverride(LinksTo(input)), 'DATA - Weight', output_quantity * (output_weight * 2));
		
		end;		
		
	end; // end function

function Finalize: integer;

	begin
		Result := 1;
	end;

end.
