{
  New script template, only shows processed records
  Assigning any nonzero value to Result will terminate script
}
unit userscript;

// Called before processing
// You can remove it if script doesn't require initialization code
function Initialize: integer;
begin
  Result := 0;
end;

// called for every record selected in xEdit
function Process(e: IInterface): integer;
begin
  Result := 0;

  // comment this out if you don't want those messages
  AddMessage('Processing: ' + FullPath(e));

  // processing code goes here
  //RemoveElement(e, 'DNAM');
  //SetElementEditValues(e, 'DNAM', '0');
  //SetElementEditValues(e, 'TNAM', '2');
  //SetElementEditValues(e, 'ACBS\Template Flags\Use Def Pack List', '1');
  //SetElementEditValues(e, 'RNAM', 'HeadPartsAllRaces [FLST:06000D62]');
  SetElementNativeValues(e, 'DATA\Flags', GetElementNativeValues(e, 'DATA\Flags') or 4);

end;

// Called after processing
// You can remove it if script doesn't require finalization code
function Finalize: integer;
begin
  Result := 0;
end;

end.
