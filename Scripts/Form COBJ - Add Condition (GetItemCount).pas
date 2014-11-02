{
  Purpose: Add GetItemCount condition to COBJ
  Game: The Elder Scrolls V: Skyrim
  Author: fireundubh <fireundubh@gmail.com>
  Version: 0.1
}

unit UserScript;

function Process(e: IInterface): integer;
  var
    rec, item, conditions, condition, ctda, lastcondition, lastctda, checkcondition, checkctda: IInterface;
		i, iLastIndex, iResults: integer;
		sFunction, sInvObject, sInvObjectCheck: string;
		bAssigned: boolean;

  begin
    Result := 0;

    rec := Signature(e);

		AddMessage(' ');
		AddMessage('--------------------------------------------------------------------------------');
    AddMessage('Processing: ' + FullPath(e));
    AddMessage('--------------------------------------------------------------------------------');

    if rec <> 'COBJ' then
      exit;
		
		item := ElementByPath(e, 'Items\Item\CNTO');

		bAssigned  := false;
		conditions := ElementByName(e, 'Conditions');
    if not Assigned(conditions) then begin
			conditions := Add(e, 'Conditions', true);
			ctda       := ElementByPath(e, 'Conditions\Condition\CTDA');

			SetEditValue(ElementByIndex(ctda, 0), '11000000');
			SetNativeValue(ElementByIndex(ctda, 2), GetNativeValue(ElementByPath(e, 'Items\Item\CNTO\Count')));
			SetEditValue(ElementByIndex(ctda, 3), 'GetItemCount');
			SetEditValue(ElementByName(ctda, 'Inventory Object'), GetEditValue(ElementByIndex(item, 0)));
			SetNativeValue(ElementByIndex(ctda, 9), -1);

			bAssigned := true;
		end;

		if bAssigned <> true and Assigned(conditions) then begin

			conditions := ElementByName(e, 'Conditions');
			iLastIndex := ElementCount(conditions) - 1;
			iResults := 0;

			if Assigned(conditions) then begin
				for i := 0 to iLastIndex do begin
					checkcondition	:= ElementByIndex(conditions, i);
					checkctda				:= ElementBySignature(ElementByIndex(conditions, i), 'CTDA');
					sFunction				:= GetEditValue(ElementByIndex(checkctda, 3));
					sInvObject			:= GetEditValue(ElementByName(checkctda, 'Inventory Object'));
					sInvObjectCheck := GetEditValue(ElementByIndex(item, 0));

					if (sFunction = 'GetItemCount') and (sInvObject = sInvObjectCheck) then
						iResults := iResults + 1;
				end;
			end;

			if iResults = 0 then begin
				condition			:= ElementAssign(conditions, HighInteger, nil, true);
				conditions 		:= ElementByName(e, 'Conditions');
				iLastIndex		:= ElementCount(conditions) - 1;
				lastcondition	:= ElementByIndex(conditions, iLastIndex);
				lastctda			:= ElementBySignature(ElementByIndex(conditions, iLastIndex), 'CTDA');

				SetEditValue(ElementByIndex(lastctda, 0), '11000000');
				SetNativeValue(ElementByIndex(lastctda, 2), GetNativeValue(ElementByName(item, 'Count')));
				SetEditValue(ElementByIndex(lastctda, 3), 'GetItemCount');
				SetEditValue(ElementByName(lastctda, 'Inventory Object'), GetEditValue(ElementByIndex(item, 0)));
				SetNativeValue(ElementByIndex(lastctda, 9), -1);
			end;

		end;

  end;

function Finalize: integer;
  begin
    AddMessage(' ');
    Result := 1;
  end;

end.
