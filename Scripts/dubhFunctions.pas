unit dubhFunctions;

uses mteFunctions;

function Log(s: string): Integer;
begin
	AddMessage(s);
end;

function LogPath(x: IInterface): Integer;
begin
	AddMessage('Path: ' + Path(x));
end;

function LogFullPath(x: IInterface): Integer;
begin
	AddMessage('Full path: ' + FullPath(x));
end;

function LogName(x: IInterface; s: String): Integer;
begin
	AddMessage(SmallNameEx(x) + '	' + s);
end;

function CompareStrLower(s1, s2: String): Integer;
begin
	Result := CompareStr(Lowercase(s1), Lowercase(s2));
end;

function FindInElement(s: String; x: IInterface; CaseSensitive: Boolean): Boolean;
begin
	if not CaseSensitive then
		if pos(Lowercase(s), Lowercase(GetEditValue(x))) > 0 then
			Result := true;
	if CaseSensitive then
		if pos(s, GetEditValue(x)) > 0 then
			Result := true;
end;

function ElementAssigned(x: IInterface; s: String): Boolean;
begin
	if Assigned(GetElement(x, s)) then
		Result := true;
end;

function ElementToString(x: IInterface; s: String): String;
begin
	Result := GetEditValue(GetElement(x, s));
end;

function StringExistsInList(item: String; list: TStringList): boolean;
begin
	Result := (list.IndexOf(item) <> -1);
end;

// --------------------------------------------------------------------
// GetEditValue alias
// --------------------------------------------------------------------
function gev(s: String): String;
begin
	Result := GetEditValue(s);
end;

// --------------------------------------------------------------------
// SetEditValue alias
// --------------------------------------------------------------------
function sev(x: IInterface; s: String): Integer;
begin
	SetEditValue(x, s);
end;

// ==================================================================
// Returns True if the x signature is in the y list of signatures
function InStringList(x, y: String): Boolean;
begin
	Result := InSignatureList(x, y);
end;

function InSignatureList(x, y: String): Boolean;
var
	signatures: TStringList;
	i: integer;
begin
	signatures := TStringList.Create;
	signatures.DelimitedText := y;
	i := signatures.IndexOf(x);
	signatures.Free;
	Result := (i > -1);
end;

// --------------------------------------------------------------------
// Returns true if the needle is in the haystack
// --------------------------------------------------------------------
//function InStringList(needle, haystack: String; delimitedNeedle: Boolean): Boolean;
//var
//	ls: TStringList;
//	idx: Integer;
//begin
//	ls := TStringList.Create;
//
//	if not delimitedNeedle then begin
//		ls.CommaText := Lowercase(needle);
//		idx := ls.IndexOf(Lowercase(haystack));
//	end;
//
//	if delimitedNeedle then begin
//		ls.CommaText := Lowercase(haystack);
//		idx := ls.IndexOf(Lowercase(needle));
//	end;
//
//	ls.Free;
//	Result := (idx > -1);
//end;

// --------------------------------------------------------------------
// Returns true if the needle is in the haystack
// --------------------------------------------------------------------
function HasString(needle, haystack: String; caseSensitive: Boolean): Boolean;
begin
	if caseSensitive then
		if pos(needle, haystack) > 0 then
			Result := true;

	if not caseSensitive then
		if pos(Lowercase(needle), Lowercase(haystack)) > 0 then
			Result := true;
end;

// --------------------------------------------------------------------
// Returns any element from a string
// --------------------------------------------------------------------
function GetElement(x: IInterface; s: String): IInterface;
begin
	if (pos('[', s) > 0) then
		Result := ElementByIP(x, s)
	else if (pos('\', s) > 0) then
		Result := ElementByPath(x, s)
	else if (s = Uppercase(s)) then
		Result := ElementBySignature(x, s)
	else
		Result := ElementByName(x, s);
end;

// --------------------------------------------------------------------
// Returns a master overriding record. Int parameter should be 1 or 2.
// --------------------------------------------------------------------
function GetLastMaster(x: IInterface; i: integer): IInterface;
begin
	Result := OverrideMaster(x, i);
end;

function GetLastOverride(x: IInterface; i: integer): IInterface;
begin
	Result := OverrideMaster(x, i);
end;

function OverrideMaster(x: IInterface; i: integer): IInterface;
var
	o: IInterface;
begin
	o := Master(x);
	if not Assigned(o) then
		o := MasterOrSelf(x);
	if OverrideCount(o) > i - 1 then
		o := OverrideByIndex(o, OverrideCount(o) - i);
	Result := o;
end;

// --------------------------------------------------------------------
// Returns "NAME/EDID [SIG_:00000000]" as a String
// --------------------------------------------------------------------
function SmallNameEx(e: IInterface): string;
begin
	if Signature(e) = 'REFR' then
		Result := geev(e, 'NAME') + ' [' + Signature(e) + ':' + HexFormID(e) + ']'
	else
		Result := geev(e, 'EDID') + ' [' + Signature(e) + ':' + HexFormID(e) + ']';
end;

// --------------------------------------------------------------------
// Returns the sortkey with handling for .nif paths, and unknown/unused
// 	data. Also uses a better delimiter.
// --------------------------------------------------------------------
function SortKeyEx(e: IInterface): string;
var
	i: integer;
begin
	Result := gev(e);

	// manipulate result for model paths - sometimes the same paths have different cases
	if pos('.nif', Lowercase(Result)) > 0 then
		Result := Lowercase(gev(e));

	for i := 0 to ElementCount(e) - 1 do begin
		if (pos('unknown', Lowercase(Name(ElementByIndex(e, i)))) > 0)
		or (pos('unused', Lowercase(Name(ElementByIndex(e, i)))) > 0) then
			exit;
		if (Result <> '') then
			Result := Result + ' ' + SortKeyEx(ElementByIndex(e, i))
		else
			Result := SortKeyEx(ElementByIndex(e, i));
	end;
end;

// --------------------------------------------------------------------
// Returns values from a text file as a TStringList
// --------------------------------------------------------------------
function LoadFromCsv(autoSort: boolean; allowDuplicates: boolean; useDelimiter: boolean; delimiter: string = '='): TStringList;
var
	fileObject: TOpenDialog;
	lsLines: TStringList;
begin
	lsLines := TStringList.Create;

	if autoSort then
		lsLines.Sorted;

	if allowDuplicates then
		lsLines.Duplicates := dupIgnore;

	if useDelimiter then
		if delimiter = '' then
			lsLines.NameValueSeparator := ',';

	fileObject := TOpenDialog.Create(nil);

	try
		fileObject.InitialDir := GetCurrentDir;
		fileObject.Options := [ofFileMustExist];
		fileObject.Filter := '*.csv';
		fileObject.FilterIndex := 1;
		if fileObject.Execute then
			lsLines.LoadFromFile(fileObject.FileName);
	finally
		fileObject.Free;
	end;

	Result := lsLines;
end;

// --------------------------------------------------------------------
// Returns properties object by the name of the script (exact match)
// --------------------------------------------------------------------
function ScriptPropertiesByName(x: IInterface; scriptName: String): IInterface;
var
	scripts, script: IInterface;
	i: integer;
	s: string;
begin
	if Signature(x) = 'QUST' then
		s := 'Quest VMAD\';
	scripts := GetElement(x, 'VMAD\Data\' + s + 'Scripts');
	for i := 0 to ElementCount(scripts) - 1 do begin
		script := ElementByIndex(scripts, i);
		if scriptName = geev(script, 'scriptName') then
			Result := GetElement(script, 'Properties'); // return script properties by script name
	end;
end;

// --------------------------------------------------------------------
// Returns object array by the name of the property (exact match)
// --------------------------------------------------------------------
function ObjectArrayByProperty(properties: IInterface; propertyName: String): IInterface;
var
	p: IInterface;
	i: integer;
begin
	for i := 0 to ElementCount(properties) - 1 do begin
		p := ElementByIndex(properties, i);
		if propertyName = geev(p, 'propertyName') then
			Result := GetElement(p, 'Value\Array of Object');
	end;
end;

// --------------------------------------------------------------------
// Returns the number of scripts in a record
// --------------------------------------------------------------------
function ScriptCount(x: IInterface): Integer;
var
	s: string;
begin
	if Signature(x) = 'QUST' then
		s := 'Quest VMAD\';
	Result := ElementCount(GetElement(x, 'VMAD\Data\' + s + 'Scripts'));
end;

// --------------------------------------------------------------------
// Returns script object by the script index
// --------------------------------------------------------------------
function ScriptByIndex(rec: IInterface; scriptIndex: integer): IInterface;
var
	s: string;
begin
	if Signature(rec) = 'QUST' then
		s := 'Quest VMAD\';
	Result := GetElement(rec, 'VMAD\Data\' + s + 'Scripts\[' + IntToStr(scriptIndex) + ']');
end;

// --------------------------------------------------------------------
// Returns properties object by the script index
// --------------------------------------------------------------------
function PropertiesByIndex(rec: IInterface; scriptIndex: integer): IInterface;
var
	s: string;
begin
	if Signature(rec) = 'QUST' then
		s := 'Quest VMAD\';
	Result := GetElement(rec, 'VMAD\Data\' + s + 'Scripts\[' + IntToStr(scriptIndex) + ']\Properties');
end;

function PropertyName(objProperties: IInterface): string;
begin
	Result := gev(GetElement(objProperties, 'Property\propertyName'));
end;

// --------------------------------------------------------------------
// Script property stuff
// --------------------------------------------------------------------
function PropertyByIndex(objProperties: IInterface; propertyIndex: integer): IInterface;
begin
	Result := ElementByIndex(objProperties, propertyIndex);
end;

function PropertyType(objProperty: IInterface): string;
var
	objType: string;
begin
	objType := gev(GetElement(objProperty, 'Type'));
	if objType = 'Array of Bool' then
		Result := objType
	else if objType = 'Array of Object' then
		Result := objType
	else if objType = 'Object' then
		Result := 'Object Union'
	else if objType = 'String' then
		Result := objType
	else
		Result := 'Undefined';
end;

function PropertyValue(objProperty: IInterface): IInterface;
var
	t: string;
begin
	t := PropertyType(objProperty);
	if t = 'Array of Bool'  then
		Result := GetElement(objProperty, 'Value\' + t)
	else if t = 'Array of Object' then
		Result := GetElement(objProperty, 'Value\' + t)
	else if t = 'Object' then
		Result := GetElement(objProperty, 'Value\' + t)
	else if t = 'String' then
		Result := GetElement(objProperty, t);
end;

function ObjectByArrayIndex(objProperty: IInterface; arrayIndex: integer; boolArray: boolean): IInterface;
var
	v: IInterface;
begin
	v := PropertyValue(objProperty);
	LogPath(v);
	if boolArray then begin

		Result := GetElement(v, '[' + IntToStr(arrayIndex) + ']');
	end;

	if not boolArray then
		Result := GetElement(v, '[' + IntToStr(arrayIndex) + ']\Object v2');
end;

function ObjectFromProperty(objProperty: IInterface): IInterface;
var
	t, v: string;
begin
	t := PropertyType(objProperty);
	v := PropertyValue(objProperty);
	if t = 'Object Union' then
		Result := v
	else if t = 'String' then
		Result := GetElement(v, t);
end;

end.