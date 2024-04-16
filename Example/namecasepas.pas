{The MIT License (MIT)

Copyright (c) 2024 Anton Lindeberg

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.}


unit NameCasePas;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fpjson, jsonparser, StrUtils, Dialogs;

type


  { TNameCase }


  TNameCase = class

  private
    middlename, firstname, lastname, gender: string;
    rules: TJSONData;

    function inflect(Name: string; aCase: integer; ruleType: string): string;
    function findInRules(Name: string; aCase: integer; ruleType: string): string;
    function applyRule(Mods, Name: string; aCase: integer): string;
  public
    constructor Create;

    function GetFirstName(AFirstName: string; ACase: integer): string;
    function GetLastName(ALastName: string; ACase: integer): string;
    function GetMiddleName(AMiddleName: string; ACase: integer): string;
    function GetGender:String;
  end;

const
  CASE_DATIVE = 0; //родительный

const
  CASE_GENITIVE = 1; //дательный

const
  CASE_ACCUSATIVE = 2; //винительный

const
  CASE_INSTRUMENTAL = 3; //творительный

const
  CASE_PREPOSITIONAL = 4; //предложный

implementation

{ TCaseName }



constructor TNameCase.Create;
var
  JSONParser: TJSONParser;
begin

  JSONParser := TJSONParser.Create(TFileStream.Create(ExtractFilePath(ParamStr(0)) +
    'rules.js', fmOpenRead));
  rules := JSONParser.Parse;
end;

function TNameCase.GetFirstName(AFirstName: string; ACase: integer): string;
begin
     { $this->firstname = $firstname;
        return $this->inflect($this->firstname,$case,__FUNCTION__);  }
  self.firstname := AFirstName;


  Result := inflect(firstname, ACase, 'firstname');
end;

function TNameCase.GetLastName(ALastName: string; ACase: integer): string;
begin
   self.lastname := ALastName;
   Result := inflect(lastname, ACase, 'lastname');
end;

function TNameCase.GetMiddleName(AMiddleName: string; ACase: integer): string;
begin
   self.lastname := AMiddleName;
   Result := inflect(lastname, ACase, 'middlename');
end;

function TNameCase.GetGender: String;
begin
  Result:=gender;
end;

function CountChar(const str: string; const chr: char): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 1 to Length(str) do
    if str[i] = chr then
      Inc(Result);
end;

{ private function inflect($name,$case,$type) {
          //если двойное имя или фамилия или отчество
        if(substr_count($name,'-') > 0) {
            $names_arr = explode('-',$name);
            $result = '';

            foreach($names_arr as $arr_name) {
                $result .= $this->findInRules($arr_name,$case,$type).'-';
            }
            return substr($result,0,strlen($result)-1);
        } else {
            return $this->findInRules($name,$case,$type);
        }
    }}

function TNameCase.inflect(Name: string; aCase: integer; ruleType: string): string;
var
  nameArr: TStringList;
  i: integer;
  res: string;
begin
  if CountChar(Name, '-') > 0 then
  begin
    nameArr := TStringList.Create;
    try
      nameArr.DelimitedText := Name;
      res := '';
      for i := 0 to nameArr.Count - 1 do
        res := res + findInRules(nameArr[i], aCase, ruleType) + '-';
      Result := Copy(res, 1, Length(res) - 1);
    finally
      nameArr.Free;
    end;
  end
  else
    Result := findInRules(Name, aCase, ruleType);

end;

{  foreach($this->rules[$type]->suffixes as $rule) {
            foreach($rule->test as $last_char) {
                $last_name_char = substr($name,strlen($name)-strlen($last_char),strlen($last_char));
                if($last_char == $last_name_char) {
                    if($rule->mods[$case] == '.')
                        continue;

                    if($this->gender == 'androgynous' || $this->gender == null)
                        $this->gender = $rule->gender;

                    return $this->applyRule($rule->mods,$name,$case);
                }
            }
        }}

function TNameCase.findInRules(Name: string; aCase: integer; ruleType: string): string;
var
  i, j: integer;
  suffixes: TJSONData;
  last_char: TJSONData;
  last_name_char, rule: string;
begin
  suffixes := rules.FindPath(ruleType).FindPath('suffixes');
  for i := 0 to suffixes.Count - 1 do
  begin
    //last_name_char = substr($name,strlen($name)-strlen($last_char),strlen($last_char));

    last_char := suffixes.Items[i].FindPath('test');


    for j := 0 to last_char.Count - 1 do
    begin
      last_name_char := Copy(Name, Length(Name) - Length(last_char.Items[j].Value) +
        1, Length(last_char.Items[j].Value));

      if (last_char.Items[j].Value = last_name_char) then
      begin

        if suffixes.Items[i].FindPath('mods').Items[aCase].Value = '.' then Continue;

        gender := suffixes.Items[i].FindPath('gender').Value;
        Result := applyRule(suffixes.Items[i].FindPath(
          'mods').Items[aCase].Value, Name, aCase);
      end;
    end;

  end;

end;

function substr_count(const substr: string; Str: string): integer;
begin
  if (Length(substr) = 0) or (Length(Str) = 0) or (Pos(substr, Str) = 0) then
    Result := 0
  else
    Result := (Length(Str) - Length(StringReplace(Str, substr, '', [rfReplaceAll]))) div
      Length(substr);
end;

function TNameCase.applyRule(Mods, Name: string; aCase: integer): string;
var
  res: string;
begin
  res := Copy(Name, 1, Length(Name) - substr_count(Mods, '-'));
  res := res + StringReplace(Mods, '-', '', [rfReplaceAll]);
  Result := res;

end;

end.
