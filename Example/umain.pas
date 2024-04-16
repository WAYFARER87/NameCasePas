unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, NameCasePas,
  Buttons;

type

  { TfMain }

  TfMain = class(TForm)
    BitBtn1: TBitBtn;
    btStart: TButton;
    edName: TEdit;
    mmResult: TMemo;
    pnTop: TPanel;
    btClear: TSpeedButton;
    procedure btClearClick(Sender: TObject);
    procedure btStartClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  fMain: TfMain;
  NC:TNameCase;

implementation

{$R *.lfm}

{ TfMain }

procedure TfMain.btClearClick(Sender: TObject);
begin
  edName.Clear;
end;

procedure TfMain.btStartClick(Sender: TObject);
var SL: TStringList;
  fullname: String;
begin
  SL := TStringList.Create;
  SL.Delimiter:=' ';
  SL.AddDelimitedtext(edName.Text);
  caption:=SL[0];

  fullname:= NC.GetLastName(SL[0],CASE_DATIVE);
  fullname:= fullname+' '+ NC.GetFirstName(SL[1],CASE_DATIVE);
  fullname:= fullname+' '+ NC.GetMiddleName(SL[2],CASE_DATIVE);
  mmResult.Lines.Add(fullname);

  fullname:= NC.GetLastName(SL[0],CASE_GENITIVE);
  fullname:= fullname+' '+ NC.GetFirstName(SL[1],CASE_GENITIVE);
  fullname:= fullname+' '+ NC.GetMiddleName(SL[2],CASE_GENITIVE);
  mmResult.Lines.Add(fullname);

  fullname:= NC.GetLastName(SL[0],CASE_ACCUSATIVE);
  fullname:= fullname+' '+ NC.GetFirstName(SL[1],CASE_ACCUSATIVE);
  fullname:= fullname+' '+ NC.GetMiddleName(SL[2],CASE_ACCUSATIVE);
  mmResult.Lines.Add(fullname);

  fullname:= NC.GetLastName(SL[0],CASE_INSTRUMENTAL);
  fullname:= fullname+' '+ NC.GetFirstName(SL[1],CASE_INSTRUMENTAL);
  fullname:= fullname+' '+ NC.GetMiddleName(SL[2],CASE_INSTRUMENTAL);
  mmResult.Lines.Add(fullname);

  fullname:= NC.GetLastName(SL[0],CASE_PREPOSITIONAL);
  fullname:= fullname+' '+ NC.GetFirstName(SL[1],CASE_PREPOSITIONAL);
  fullname:= fullname+' '+ NC.GetMiddleName(SL[2],CASE_PREPOSITIONAL);
  mmResult.Lines.Add(fullname);




end;

procedure TfMain.FormShow(Sender: TObject);
begin
  NC := TNameCase.Create;
end;

end.

