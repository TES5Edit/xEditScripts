{
  Purpose: NPC - Add Package
  Game: The Elder Scrolls V: Skyrim
  Author: fireundubh <fireundubh@gmail.com>
  Version: 0.1
}

unit UserScript;

var
	sInputFaction: string;

function Process(e: IInterface): integer;
  var
    rec, package, packages, lastpackage: IInterface;
		i, iPackages, iLastIndex, iResults: integer;
		sPackage, sInput: string;
		bAssigned: boolean;

  begin
    Result := 0;

    rec := Signature(e);

		AddMessage(' ');
    AddMessage('Processing: ' + FullPath(e));
		AddMessage('---------------------------------------------------------------');

    if rec <> 'NPC_' then
      exit;

		sInput := 'dubhGuardArrestPackage [PACK:020244C6]';
		
		packages := ElementByName(e, 'Packages');

		if Assigned(packages) then begin
			AddMessage('Packages exist!');

			iPackages := ElementCount(packages) - 1;
			
			iResults := 0;
			for i := 0 to iPackages do begin
					
					package		:= ElementByIndex(packages, i);
					sPackage	:= GetEditValue(package);

					if (sPackage = sInput) then begin
						iResults := iResults + 1;
					end;

					if iResults > 1 then
						AddMessage('There are duplicates of the package you tried to add in this record.');
			end;

			if iResults = 0 then begin
				package			:= ElementAssign(packages, HighInteger, nil, true);
				
				packages		:= ElementByName(e, 'Packages');
				iPackages		:= ElementCount(packages) - 1;
				lastpackage := ElementByIndex(packages, iPackages);

				SetEditValue(lastpackage, sInput);
				AddMessage('Added new package!');
			end;

		end;

    if not Assigned(packages) then begin
			packages := Add(e, 'Packages', true);
			package := ElementByPath(e, 'Packages\PKID');
			SetEditValue(package, sInput);
			AddMessage('Added new package!');
		end;

  end;

function Finalize: integer;
  begin
    AddMessage('---------------------------------------------------------------');
		AddMessage(' ');
    Result := 1;
  end;

end.
