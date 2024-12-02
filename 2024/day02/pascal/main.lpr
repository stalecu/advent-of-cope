program main;

{$mode objfpc}{$H+}
uses
  Classes,
  SysUtils,
  Generics.Collections;

type
  TReport = specialize TList<integer>;
  TReportArray = specialize TList<TReport>;

  function IsSafe(report: TReport): Boolean;
  var
    i, diff: Integer;
    isIncreasing, isDecreasing: Boolean;
    curr, prev: Integer;
  begin
    if report.Count < 2 then
      Exit(False);

    isIncreasing := True;
    isDecreasing := True;

    for i := 1 to report.Count - 1 do
    begin
      curr := report[i];
      prev := report[i - 1];
      diff := Abs(curr - prev);
      if (diff < 1) or (diff > 3) then
        Exit(False);

      if curr <= prev then
        isIncreasing := False;
      if curr >= prev then
        isDecreasing := False;
    end;

    Result := isIncreasing or isDecreasing;
  end;

  function TryRemovingOne(report: TReport): boolean;
  var
    i: integer;
    newReport: TReport;
  begin
    for i := 0 to report.Count - 1 do
    begin
      newReport := TReport.Create;
      try
        if i > 0 then
          newReport.AddRange(report.ToArray[0..i-1]);

        if i < report.Count - 1 then
          newReport.AddRange(report.ToArray[i + 1..report.Count - 1]);

        if IsSafe(newReport) then
          Exit(True);
      finally
        newReport.Free;
      end;
    end;

    Result := False;
  end;

  function CountSafeReports(reports: TReportArray; part: integer): integer;
  var
    i: integer;
  begin
    for i := 0 to reports.Count - 1 do
      case part of
        1: if IsSafe(reports[i]) then Inc(Result);
        2: if TryRemovingOne(reports[i]) then Inc(Result);
      end;
  end;

  function ReadReportsFromFile(const filePath: String): TReportArray;
  var
    lines: TStringList;
    line, part: String;
    parts: TStringArray;
    report: TReport;
    num: Integer;
  begin
    Result := TReportArray.Create;
    lines := TStringList.Create;
    try
      lines.LoadFromFile(filePath);

      for line in lines do
      begin
        if line.Trim = '' then Continue;

        report := TReport.Create;
        try
          parts := line.Trim.Split([',', ' ']);
          for part in parts do
            if TryStrToInt(part, num) then
              report.Add(num);
          Result.Add(report);
        except
          report.Free;
          raise;
        end;
      end;
    finally
      lines.Free;
    end;
  end;

procedure FreeReports(reports: TReportArray);
var
  report: TReport;
begin
  for report in reports do
    report.Free;
  reports.Free;
end;

procedure ProcessReports(const filePath: String);
var
  data: TReportArray;
begin
  data := ReadReportsFromFile(filePath);
  try
    WriteLn('Part 1: ', CountSafeReports(data, 1));
    WriteLn('Part 2: ', CountSafeReports(data, 2));
  finally
    FreeReports(data);
  end;
end;

var
  filePath: String;
begin
  filePath := '../inputs/input';
  try
    ProcessReports(filePath);
  except
    on E: Exception do
      WriteLn('Error: ', E.Message);
  end;
end.