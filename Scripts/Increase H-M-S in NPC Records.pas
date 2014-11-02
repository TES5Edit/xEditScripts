{
	Purpose: Increase H-M-S in NPC_ records
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var
	a, b, c: integer;
	fMult: float;

// Called before processing
function Initialize: integer;
	begin

		fMult := (InputBox('Set Multiplier', 'Mult:', 1.5));
	
	end;

function Process(e: IInterface): integer;
	var
		rec: IInterface;
		sPath, sPathHealth, sPathMagicka, sPathStamina: string;
		iHealth, iMagicka, iStamina, iHealthNew, iMagickaNew, iStaminaNew: integer;

	begin

		Result := 0;

		rec := Signature(e);
		sPath := Name(e);

		AddMessage('--------------------------------------------------------------------------------');
		AddMessage(sPath);
		AddMessage('--------------------------------------------------------------------------------');

		if (rec = 'NPC_') then begin
		
			sPathHealth := 'DNAM - Player Skills\Health';
			sPathMagicka := 'DNAM - Player Skills\Magicka';
			sPathStamina := 'DNAM - Player Skills\Stamina';
		
			iHealth  := GetElementNativeValues(e, sPathHealth);
			iMagicka := GetElementNativeValues(e, sPathMagicka);
			iStamina := GetElementNativeValues(e, sPathStamina);
			
			AddMessage('[list]');
			if iHealth > 0 then begin
				iHealthNew := iHealth * fMult;
				SetElementNativeValues(e, sPathHealth, iHealthNew);
				AddMessage('[*] Health increased from ' + IntToStr(iHealth) + ' to ' + IntToStr(iHealthNew));
			end;
			
			if iMagicka > 0 then begin
				iMagickaNew := iMagicka * fMult;
				SetElementNativeValues(e, sPathMagicka, iMagickaNew);
				AddMessage('[*] Magicka increased from ' + IntToStr(iMagicka) + ' to ' + IntToStr(iMagickaNew));
			end;
			
			if iStamina > 0 then begin
				iStaminaNew := iStamina * fMult;
				SetElementNativeValues(e, sPathStamina, iStaminaNew);
				AddMessage('[*] Stamina increased from ' + IntToStr(iStamina) + ' to ' + IntToStr(iStaminaNew));
			end;
			
			AddMessage('[/list]');
			AddMessage(' ');
			
		end; // end condition

	end; // end function

// Cleanup
function Finalize: integer;
	begin

		Result := 1;

	end; // end function

end. // end script