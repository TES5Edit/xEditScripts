{
	Purpose: Update AIDT
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

function Process(e: IInterface): integer;
	begin
		Result := 0;

		// comment this out if you don't want those messages
		AddMessage('Processing: ' + FullPath(e));

		// processing code goes here
		SetElementEditValues(e, 'AIDT\Aggression', 	'Aggressive');
		//SetElementEditValues(e, 'AIDT\Confidence', 	'Average');
		SetElementEditValues(e, 'AIDT\Confidence', 	'Brave');
		SetElementEditValues(e, 'AIDT\Responsibility', 	'No crime');
		SetElementEditValues(e, 'AIDT\Assistance', 	'Helps Friends and Allies');
		
	end;

function Finalize: integer;
	begin
		Result := 1;
	end;

end.
