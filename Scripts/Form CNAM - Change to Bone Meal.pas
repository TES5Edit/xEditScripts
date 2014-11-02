{
	Purpose: Change CNAM to Bone Meal
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

// Called before processing
// You can remove it if script doesn't require initialization code
function Initialize: integer;
begin
  Result := 0;
end;

// called for every record selected in xEdit
function Process(e: IInterface): integer;
var
	test: string;
begin
  Result := 0;

  // comment this out if you don't want those messages
  AddMessage('Processing: ' + FullPath(e));

  // processing code goes here
  SetElementEditValues(e, 'CNAM', 'BoneMeal "Bone Meal" [INGR:00034CDD]');
	SetElementNativeValues(e, 'NAM1', 1);
	
end;

// Called after processing
// You can remove it if script doesn't require finalization code
function Finalize: integer;
begin
  Result := 0;
end;

end.
