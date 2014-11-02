{
	Purpose: Add Keyword
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
	
	Keywords:
	VendorItemAnimalPart [KYWD:000914EB]
	VendorItemClutter [KYWD:000914E9]
	VendorItemTool [KYWD:000914EE]
}

unit UserScript;

var
	formid: string;

function Initialize: integer;
begin

	Result := 0;
	
	if not InputQuery('Enter', 'Form ID', formid) then begin
		Result := 1;
		exit;
	end;
	
	if formid = 'animalpart' then
		formid := 'VendorItemAnimalPart [KYWD:000914EB]'
	else if formid = 'clutter' then
		formid := 'VendorItemClutter [KYWD:000914E9]'
	else if formid = 'tool' then
		formid := 'VendorItemTool [KYWD:000914EE]';

end;

function Process(e: IInterface): integer;
var
	kwda, keyword: IInterface;
begin

	Result := 0;

	AddMessage('Processing: ' + FullPath(e));

	kwda := ElementByName(e, 'KWDA');

	if not Assigned(kwda) then
		Add(e, 'KWDA', true);
		
	keyword := ElementByPath(e, 'KWDA\Keyword');
	
	SetEditValue(keyword, formid);

end;

function Finalize: integer;
begin
	Result := 0;
end;

end.
