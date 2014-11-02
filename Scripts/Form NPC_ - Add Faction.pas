{
  Purpose: NPC - Add Faction
  Game: The Elder Scrolls V: Skyrim
  Author: fireundubh <fireundubh@gmail.com>
  Version: 0.1
}

unit UserScript;

var
	sInputFaction: string;

function Process(e: IInterface): integer;
  var
    rec, faction, factions, snam, firstsnam: IInterface;
		i, iLastIndex, iResults: integer;
		sFaction, sFlagUseFactions: string;
		bAssigned: boolean;

  begin
    Result := 0;

    rec := Signature(e);

		AddMessage(' ');
    AddMessage('Processing: ' + FullPath(e));
		AddMessage('---------------------------------------------------------------');

    if rec <> 'NPC_' then
      exit;

		//sInputFaction := 'ForswornFaction "Forsworn Faction" [FACT:00043599]';
		//sInputFaction := 'PenitusOculatusFaction "Penitus Oculatus Faction" [FACT:0002584B]';
		sInputFaction := 'ThalmorFaction "Thalmor" [FACT:00039F26]';
		//sInputFaction := 'VigilantOfStendarrFaction "Vigilant of Stendarr Faction" [FACT:000B3292]';
		//sInputFaction := 'NecromancerFaction [FACT:00034B74]';
		//sInputFaction := 'SilverHandFaction [FACT:000AA0A4]';
		//sInputFaction := 'CWSonsFactionNPC "NPC faction (creates hostility to enemy)" [FACT:0001C9FD]';
		//sInputFaction := 'CWImperialFactionNPC "NPC faction (creates hostility to enemy)" [FACT:0001C9FC]';
		//sInputFaction := 'WerewolfFaction "Werewolf Faction" [FACT:00043594]';
		//sInputFaction := 'VampireFaction [FACT:00027242]';


		factions := ElementByName(e, 'Factions');
		sFlagUseFactions := 'ACBS\Template Flags\Use Factions';

		if Assigned(factions) then begin
			AddMessage('Factions exist!');

			iResults := 0;
			for i := 0 to ElementCount(factions) - 1 do begin
					snam		 := ElementByIndex(factions, i);
					sFaction := GetEditValue(ElementByIndex(snam, 0));

					if (sFaction = sInputFaction) then begin
						iResults := iResults + 1;
					end;

					if iResults > 1 then
						AddMessage('There are duplicates of the faction you tried to add in this record.');
			end;

			if iResults = 0 then begin
				faction 	 := ElementAssign(factions, HighInteger, nil, true);
				factions 	 := ElementByName(e, 'Factions');
				firstsnam  := ElementByIndex(factions, 0);

				SetEditValue(ElementByIndex(firstsnam, 0), sInputFaction);
				AddMessage('Added new faction!');
			end;

		end;

    if not Assigned(factions) then begin
			factions := Add(e, 'Factions', true);
			snam := ElementByPath(e, 'Factions\SNAM');
			SetEditValue(ElementByIndex(snam, 0), sInputFaction);
			AddMessage('Added new faction!');
		end;
		
		if (GetElementEditValues(e, sFlagUseFactions) = '1') then
			SetElementEditValues(e, sFlagUseFactions, '0');

  end;

function Finalize: integer;
  begin
    AddMessage('---------------------------------------------------------------');
		AddMessage(' ');
    Result := 1;
  end;

end.
