{
	Purpose: Renumber TIRS subrecords in RACE records
	Game: The Elder Scrolls V: Skyrim
	Author: fireundubh <fireundubh@gmail.com>
	Version: 0.1
}

unit UserScript;

var

	i, j, k, l, m, n, o, p: integer;
	lPresets: TStringList;
	bGender: boolean;
	sGender: string;

// Called before processing
function Initialize: integer;
	begin

		lPresets := TStringList.Create;

		bGender := (MessageDlg('Male (YES) or Female (NO)?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
		if bGender = TRUE then begin
			sGender := 'Male';
		end;
		if bGender = FALSE then begin
			sGender := 'Female';
		end;

	end;

function Process(e: IInterface): integer;
	var

		rec, assets, preset, presets: IInterface;
		sPath, sAssets, sPresets: string;
		iAssets, iStart: integer;
		fProgress: extended;
		runOnce: boolean;

	begin

		Result := 0;

		rec := Signature(e);
		sPath := FullPath(e);

		AddMessage('------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');
		AddMessage('Processing: ' + sPath);
		AddMessage('------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');
		AddMessage(' ');

		if (rec = 'RACE') then begin

			sAssets  := 'Head Data\' + sGender + ' Head Data\Tint Masks';

			// Count number of Tint Assets
			iAssets  := ElementCount(ElementByPath(e, sAssets));
			//AddMessage('Found ' + IntToStr(iAssets) + ' Tint Assets...');

			// Initialize the runOnce variable
			runOnce := false;

			// Loop through Tint Assets collections
			for i := 0 to iAssets - 1 do begin

				// Get each Tint Assets collection as an element
				assets := ElementByIndex(ElementByPath(e, sAssets), i);

				// Get the number of assets in each collection
				j := ElementCount(assets);
				//AddMessage('Found ' + IntToStr(j) + ' Tint Layer/Presets pairs...');

				for k := 0 to j - 2 do begin

					// Get each Presets collection
					presets := ElementByIndex(assets, 1); // 0: Tint Layer, 1: Presets

					// Get the number of presets in each collection
					l := ElementCount(presets);
					//AddMessage('Found ' + IntToStr(l) + ' Presets...');
					AddMessage('------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');
					AddMessage(FullPath(presets));
					AddMessage('------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');

					for m := 0 to l - 1 do begin

						// Sets fProgress for use in showing progress as a percentage
						fProgress := ((m / (l - 1)) * 100);

						// Get each Preset as an element
						preset := ElementByIndex(presets, m); // m is the index of each Preset

						// Initially, get the value of the first TIRS subrecord
						if runOnce = false then begin

							n := GetNativeValue(ElementByIndex(preset, 2));

							// Terminate if the first TIRS subrecord has a zero value
							// TODO: Ask for user input instead
							if n < 1 then begin

								AddMessage('Error: The first TIRS subrecord must have a value greater than 0.');
								Exit;

							end;

						end;

						// After the first TIRS subrecord is updated, update the remaining TIRS subrecords
						// NOTE: Due to variable reuse, order is intentional!
						if runOnce = true then begin

							o := o + 1;
							SetNativeValue(ElementByIndex(preset, 2), o);

							AddMessage('Updated: ' + FullPath(preset) + ' \ [2] TIRS = ' + IntToStr(o) + ' (Progress: ' + FormatFloat('0.00', fProgress) + '%)');

						end;

						// Initially, update the first TIRS subrecord
						if runOnce = false and n <> 0 then begin

							lPresets.Add(n);
							o := lPresets[0];
							SetNativeValue(ElementByIndex(preset, 2), o);

							AddMessage('Updated: ' + FullPath(preset) + ' \ [2] TIRS = ' + IntToStr(o) + ' (Progress: ' + FormatFloat('0.00', fProgress) + '%)');
							runOnce := true;

						end;

					end; // end loop through individual presets

				end; // end loop through individual assets

			end; // end loop through tint asset collections

		end; // end condition

	end; // end function

// Cleanup
function Finalize: integer;
	begin

		AddMessage('------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');
		AddMessage('IMPORTANT! REMEMBER TO APPLY THE SCRIPT TO THE OTHER GENDER IF YOU HAVEN''T ALREADY!');
		AddMessage('------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');

		lPresets.Clear;
		lPresets.Free;

		Result := 1;

	end; // end function

end. // end script