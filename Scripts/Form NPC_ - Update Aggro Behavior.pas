{
	This is where you should describe your script and add any general notes.
}

unit UserScript;

var
	// you set global script variables here

// this runs once when you apply the script
// best used for creating TStringLists, dialog prompts, etc.
function Initialize: integer;
	var
		// you set local function variables here
		
	begin
	
		Result := 0;
	
		// i like to do this because it makes reading the messages window easier
		AddMessage('-------------------------------------------------------------------------------');
	
	end;

// this is usually where all operations go
function Process(e: IInterface): integer;
	var
		// you set local function variables here
		formid, pathAggro1, pathAggro2, pathAggro3, pathAggro4, pathAggro5: string;

	begin
		
		Result := 0;

		// this prints the full path to the record you're editing
		// example: Processing:  \ [01] test.esp \ [1] GRUP Top "NPC_" \ [0] BolgeirBearclaw "Bolgeir Bearclaw" [NPC_:00013264]
		AddMessage('Processing: ' + FullPath(e));
		
		// this turns the record's formid into an 8-digit string
		// example: 00013264
		formid := IntToHex(FixedFormID(e), 8);
		
		// these string variables contain the paths to the data you want to change
		pathAggro1 := 'AIDT\Aggro\Aggro Radius Behavior';
		pathAggro2 := 'AIDT\Aggro\Unknown';
		pathAggro3 := 'AIDT\Aggro\Warn';
		pathAggro4 := 'AIDT\Aggro\Warn/Attack';
		pathAggro5 := 'AIDT\Aggro\Attack';
		
		// use edit for strings and native for numbers
		// other operations can be found here: http://www.creationkit.com/TES5Edit_Scripting_Functions
		SetElementEditValues(e, pathAggro1, 'True');
		SetElementNativeValues(e, pathAggro2, 0);
		SetElementNativeValues(e, pathAggro3, 0);
		SetElementNativeValues(e, pathAggro4, 0);
		SetElementNativeValues(e, pathAggro5, 0);
		
		// these print strings to the Messages window
		// tip: anything you want to print must be a string or turned into one
		// tip: you can use the tab if you want to copy and paste into Excel
		AddMessage(formid + ' : Aggro Radius Behavior was changed to ' + GetElementEditValues(e, pathAggro1));
		AddMessage(formid + ' : Aggro Unknown was changed to ' + GetElementEditValues(e, pathAggro2));
		AddMessage(formid + ' : Aggro Warn was changed to ' + GetElementEditValues(e, pathAggro3));
		AddMessage(formid + ' : Aggro Warn/Attack was changed to ' + GetElementEditValues(e, pathAggro4));
		AddMessage(formid + ' : Aggro Attack was changed to ' + GetElementEditValues(e, pathAggro5));
		
	end;

// this runs after Process()
function Finalize: integer;
	var
		// you set local function variables here

	begin
		
		// i like to do this because it makes reading the messages window easier
		AddMessage('-------------------------------------------------------------------------------');
		
		// any time Result = 1, the script terminates
		// the script will terminate after Finalize anyway
		Result := 1;

	end;

end.
