unit ufFormPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ufDMPrincipal, ufServerClass,
  Vcl.ExtCtrls;

type
  TipoCombustivel = (tcGasolina, tcDiesel);

  TFormPrincipal = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
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
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure EdtKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    FDMPrincipal: TDMPrincipal;
    function OnlyNumeric(Sender: TObject; _AKey: Char): Char;
    function ValidarLitros(_AValue: String): Currency;
    procedure Abastecer(_ABomba, _ATanque: Integer; _ALitros: Currency; _ATipoCombustivel: TipoCombustivel);
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

procedure TFormPrincipal.Abastecer(_ABomba, _ATanque: Integer; _ALitros: Currency; _ATipoCombustivel: TipoCombustivel);
var
  AProxy: TSMServidorClient;
begin
  AProxy := FDMPrincipal.Proxy;
  try
    AProxy.Teste.ToString; MONTAR JSON E ABASTECER
  finally
    AProxy.Free;
  end;
end;

procedure TFormPrincipal.Button1Click(Sender: TObject);
begin
  Abastecer(1, 1, ValidarLitros(EdtLitrosBomba1.Text), tcGasolina);
end;

procedure TFormPrincipal.Button2Click(Sender: TObject);
begin
  Abastecer(2, 1, ValidarLitros(EdtLitrosBomba2.Text), tcGasolina);
end;

procedure TFormPrincipal.Button3Click(Sender: TObject);
begin
  Abastecer(3, 2, ValidarLitros(EdtLitrosBomba3.Text), tcDiesel);
end;

procedure TFormPrincipal.Button4Click(Sender: TObject);
begin
  Abastecer(4, 2, ValidarLitros(EdtLitrosBomba4.Text), tcDiesel);
end;

procedure TFormPrincipal.EdtKeyPress(Sender: TObject; var Key: Char);
begin
  Key := OnlyNumeric(Sender, Key);
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
  FDMPrincipal := TDMPrincipal.Create(Self);
end;

procedure TFormPrincipal.FormDestroy(Sender: TObject);
begin
  FDMPrincipal.Free;
end;

function TFormPrincipal.OnlyNumeric(Sender: TObject; _AKey: Char): Char;
begin
  Result := #0;
  if CharInSet(_AKey, [',','.']) then
  begin
    if Pos('.', TEdit(Sender).Text) > 0 then
      exit;
  end;
  if _AKey = ',' then
    Result := '.'
  else if (CharInSet(_AKey, [#8, '0'..'9', '-', '.'])) then
    Result := _AKey;

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
