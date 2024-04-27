unit ufFormPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ufDMPrincipal, ufServerClass,
  Vcl.ExtCtrls, System.JSON, REST.JSON, System.UITypes;

type
  TipoCombustivel = (tcGasolina, tcDiesel);

  TFormPrincipal = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    EdtAliquota: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    EdtLitrosBomba1: TEdit;
    Label15: TLabel;
    EdtPrecoGasolina: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    EdtPrecoDiesel: TEdit;
    Label18: TLabel;
    Label19: TLabel;
    EdtLitrosBomba2: TEdit;
    Label20: TLabel;
    EdtLitrosBomba3: TEdit;
    Label21: TLabel;
    EdtLitrosBomba4: TEdit;
    Label22: TLabel;
    EdtTotalBomba1: TEdit;
    EdtTotalBomba2: TEdit;
    Label23: TLabel;
    EdtTotalBomba3: TEdit;
    Label24: TLabel;
    EdtTotalBomba4: TEdit;
    Label25: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label26: TLabel;

    procedure EdtKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure EdtLitrosBomba1KeyPress(Sender: TObject; var Key: Char);
    procedure EdtLitrosBomba2KeyPress(Sender: TObject; var Key: Char);
    procedure EdtLitrosBomba3KeyPress(Sender: TObject; var Key: Char);
    procedure EdtLitrosBomba4KeyPress(Sender: TObject; var Key: Char);
    procedure EdtLitrosBomba1Exit(Sender: TObject);
    procedure EdtLitrosBomba2Exit(Sender: TObject);
    procedure EdtLitrosBomba3Exit(Sender: TObject);
    procedure EdtLitrosBomba4Exit(Sender: TObject);
  private
    function OnlyNumeric(Sender: TObject; _AKey: Char): Char;
    function CacularValor(_AValue: Currency; _ATipoCombustivel: TipoCombustivel): Currency;
    function ValidarLitros(_AValue: String): Currency;
    procedure LimparCampos(_AEdit1, _AEdit2: TEdit);
    procedure Abastecer(_ABomba, _ATanque: Integer; _ALitros: Currency; _ATipoCombustivel: TipoCombustivel);
    procedure TratarRetorno(_ARetorno: String);
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

uses
  uClassPosto;

procedure TFormPrincipal.Abastecer(_ABomba, _ATanque: Integer; _ALitros: Currency; _ATipoCombustivel: TipoCombustivel);
var
  ADMPrincipal: TDMPrincipal;
  AProxy: TSMServidorClient;
  AAbastecimentoEnvio: TAbastecimentoEnvio;
  AJSONObject: TJSONObject;
  ARetorno: String;

begin
  ADMPrincipal := TDMPrincipal.Create(Self);
  try
    AProxy := ADMPrincipal.Proxy;
    try
      AAbastecimentoEnvio := TAbastecimentoEnvio.Create;
      try
        AAbastecimentoEnvio.Bomba := _ABomba;
        AAbastecimentoEnvio.Tanque := _ATanque;
        AAbastecimentoEnvio.Litros := _ALitros;
        if _ATipoCombustivel = tcGasolina then
          AAbastecimentoEnvio.ValorLitro := StrToCurrDef(EdtPrecoGasolina.Text,0)
        else
          AAbastecimentoEnvio.ValorLitro := StrToCurrDef(EdtPrecoDiesel.Text,0);
        AAbastecimentoEnvio.Aliquota := StrToCurrDef(EdtAliquota.Text,0);
        AAbastecimentoEnvio.DataAbastecimento := now;
        AJSONObject := TJSON.ObjectToJsonObject(AAbastecimentoEnvio);
        ARetorno := AProxy.UpdateAbastecer(AJSONObject).ToString;
      finally
        AAbastecimentoEnvio.Free;
      end;
    finally
      AProxy.Free;
    end;
  finally
    ADMPrincipal.Free;
  end;
  TratarRetorno(ARetorno);
end;

procedure TFormPrincipal.Button1Click(Sender: TObject);
begin
  Abastecer(1, 1, ValidarLitros(EdtLitrosBomba1.Text), tcGasolina);
  LimparCampos(EdtLitrosBomba1, EdtTotalBomba1);
end;

procedure TFormPrincipal.Button2Click(Sender: TObject);
begin
  Abastecer(2, 1, ValidarLitros(EdtLitrosBomba2.Text), tcGasolina);
  LimparCampos(EdtLitrosBomba2, EdtTotalBomba2);
end;

procedure TFormPrincipal.Button3Click(Sender: TObject);
begin
  Abastecer(3, 2, ValidarLitros(EdtLitrosBomba3.Text), tcDiesel);
  LimparCampos(EdtLitrosBomba3, EdtTotalBomba3);
end;

procedure TFormPrincipal.Button4Click(Sender: TObject);
begin
  Abastecer(4, 2, ValidarLitros(EdtLitrosBomba4.Text), tcDiesel);
  LimparCampos(EdtLitrosBomba4, EdtTotalBomba4);
end;

function TFormPrincipal.CacularValor(_AValue: Currency; _ATipoCombustivel: TipoCombustivel): Currency;
var
  ATotais: TTotais;
begin
  ATotais := Default(TTotais);
  if _ATipoCombustivel = tcGasolina then
    ATotais.ValorLitro := StrToCurrDef(EdtPrecoGasolina.Text,0)
  else
    ATotais.ValorLitro := StrToCurrDef(EdtPrecoDiesel.Text,0);

  ATotais.Litros := _AValue;
  ATotais.Aliquota := StrToCurrDef(EdtAliquota.Text,0);
  CalcularTotais(ATotais);
  Result := ATotais.ValorTotal;
end;

procedure TFormPrincipal.EdtKeyPress(Sender: TObject; var Key: Char);
var
  ATotal: Currency;
begin
  Key := OnlyNumeric(Sender, Key);
  ATotal := CacularValor(StrToCurrDef(TEdit(Sender).Text, 0), TipoCombustivel(TEdit(Sender).Tag));
  TEdit(Sender).Text := FormatCurr('#0.00', ATotal);
end;

procedure TFormPrincipal.EdtLitrosBomba1Exit(Sender: TObject);
var
  ATotal: Currency;
begin
  ATotal := CacularValor(StrToCurrDef(TEdit(Sender).Text, 0), TipoCombustivel(TEdit(Sender).Tag));
  EdtTotalBomba1.Text := FormatCurr('#0.00', ATotal);
end;

procedure TFormPrincipal.EdtLitrosBomba1KeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := OnlyNumeric(Sender, Key);
end;

procedure TFormPrincipal.EdtLitrosBomba2Exit(Sender: TObject);
var
  ATotal: Currency;
begin
  ATotal := CacularValor(StrToCurrDef(TEdit(Sender).Text, 0), TipoCombustivel(TEdit(Sender).Tag));
  EdtTotalBomba2.Text := FormatCurr('#0.00', ATotal);
end;

procedure TFormPrincipal.EdtLitrosBomba2KeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := OnlyNumeric(Sender, Key);
end;

procedure TFormPrincipal.EdtLitrosBomba3Exit(Sender: TObject);
var
  ATotal: Currency;
begin
  ATotal := CacularValor(StrToCurrDef(TEdit(Sender).Text, 0), TipoCombustivel(TEdit(Sender).Tag));
  EdtTotalBomba3.Text := FormatCurr('#0.00', ATotal);
end;

procedure TFormPrincipal.EdtLitrosBomba3KeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := OnlyNumeric(Sender, Key);
end;

procedure TFormPrincipal.EdtLitrosBomba4Exit(Sender: TObject);
var
  ATotal: Currency;
begin
  ATotal := CacularValor(StrToCurrDef(TEdit(Sender).Text, 0), TipoCombustivel(TEdit(Sender).Tag));
  EdtTotalBomba4.Text := FormatCurr('#0.00', ATotal);
end;

procedure TFormPrincipal.EdtLitrosBomba4KeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := OnlyNumeric(Sender, Key);
end;

procedure TFormPrincipal.LimparCampos(_AEdit1, _AEdit2: TEdit);
begin
  _AEdit1.Text := '0';
  _AEdit2.Text := '0,00';
end;

function TFormPrincipal.OnlyNumeric(Sender: TObject; _AKey: Char): Char;
begin
  Result := #0;
  if CharInSet(_AKey, [',','.']) then
  begin
    if Pos(',', TEdit(Sender).Text) > 0 then
      exit;
  end;
  if _AKey = '.' then
    Result := ','
  else if (CharInSet(_AKey, [#8, '0'..'9', '-', ','])) then
    Result := _AKey;
end;

procedure TFormPrincipal.TratarRetorno(_ARetorno: String);
var
  ARetorno: String;
begin
  ARetorno := _ARetorno.Replace('"','');
  if StrToCurrDef(ARetorno, 0) > 0 then
    MessageDlg('Abastecimento concluído', mtInformation, [], 0)
  else
    MessageDlg('Erro ao abastecer', mtError, [], 0);
end;

function TFormPrincipal.ValidarLitros(_AValue: String): Currency;
var
  ALitros: Currency;
begin
  ALitros := StrToCurrDef(_AValue, 0);
  if ALitros = 0 then
    raise Exception.Create('Informe uma quantidade de litros válida.');   

  Result := ALitros;
end;

end.
