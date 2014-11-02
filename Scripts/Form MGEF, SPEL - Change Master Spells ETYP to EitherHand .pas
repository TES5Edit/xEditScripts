{
	Purpose: Make master spells one-handed and dual castable
		- MGEF: Remove RitualSpellEffect keyword
		- SPEL: Change BothHands to EitherHands
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	a, b, c: integer;

function Initialize: integer;
	begin
	
	end;

function Process(e: IInterface): integer;
	var
		rec: IInterface;
		sPath: string;

		// MGEF
		keywords, keyword: IInterface;
		sPathKeywords, sPathKeyword, sKeyword: string;
		iKeywords: integer;
		
		// SPEL
		sPathName, sPathHands, sPathDualCast, sName, sHands: string;
		iDualCast: integer;

	begin

		Result := 0;

		rec := Signature(e);
		sPath := Name(e);

		if (rec = 'MGEF') then begin
		
			// Path Reference
			sPathKeywords := 'KWDA - Keywords';
			sPathKeyword := 'KWDA - Keywords\Keyword';
			
			// Get keywords as an element to check actual keyword count
			keywords := ElementByPath(e, sPathKeywords);
			iKeywords := ElementCount(keywords);
			
			// Update the KSIZ subrecord to the actual keyword count
			//SetElementEditValues(e, 'KSIZ - Keyword Count', iKeywords);
			
			// Remove specific keyword from keywords element
			// Note: Indices change when removing, so use downto
			for a := iKeywords - 1 downto 0 do begin
			
				keyword := ElementByIndex(keywords, a);
				sKeyword := GetEditValue(keyword);
			
				if sKeyword = 'RitualSpellEffect [KYWD:000806E1]' then begin
					AddMessage('--------------------------------------------------------------------------------');
					AddMessage(sPath);
					AddMessage('--------------------------------------------------------------------------------');
				
					Remove(keyword);
					AddMessage('Removed keyword ' + sKeyword + ' at index ' + IntToStr(a));
				
				end;
			
			end;
			
			// Update the KSIZ subrecord to the new actual keyword count
			iKeywords := ElementCount(keywords);
			SetElementEditValues(e, 'KSIZ - Keyword Count', iKeywords);
			AddMessage('Updated keyword count to ' + IntToStr(iKeywords) + '...');
			
			// If the KSIZ subrecord equals zero, remove the KWDA and KSIZ subrecords
			iKeywords := ElementCount(keywords);
			if iKeywords = 0 then begin
				RemoveElement(e, 'KWDA - Keywords');
				RemoveElement(e, 'KSIZ - Keyword Count');
				AddMessage('Removed KSIZ and KWDA subrecords because keyword count was zero...');
			end;
			
			AddMessage(' ');
		
		end; // end condition
		
		if (rec = 'SPEL') then begin
		
			// Path References
			sPathName := 'FULL - Name';
			sPathHands := 'ETYP - Equipment Type';
			sPathDualCast := 'SPIT - Data\Flags\No Dual Cast Modification';
		
			// Variable Substitutions
			sName := GetElementEditValues(e, sPathName);
			sHands := GetElementEditValues(e, sPathHands);
			iDualCast := GetElementNativeValues(e, sPathDualCast);
			//AddMessage('No Dual Cast Modification Flag: ' + IntToStr(iDualCast));
			
			// Modify Elements
			if sHands = 'BothHands [EQUP:00013F45]' then begin
				AddMessage('--------------------------------------------------------------------------------');
				AddMessage(sPath);
				AddMessage('--------------------------------------------------------------------------------');
				SetElementEditValues(e, sPathHands, 'EitherHand [EQUP:00013F44]');
				AddMessage('+ Equipment Type updated to EitherHand [EQUP:00013F44]');
				if iDualCast = -1 then begin
					SetElementNativeValues(e, sPathDualCast, 0);
					AddMessage('- Removed No Dual Cast Modification flag');
				end;
				AddMessage(' ');
			end;
			
		end; // end condition

	end; // end function

function Finalize: integer;
	begin

		Result := 1;

	end; // end function

end. // end script