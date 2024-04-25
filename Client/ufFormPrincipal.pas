unit ufFormPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ufDMPrincipal, ufServerClass;

type
  TFormPrincipal = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FDMPrincipal: TDMPrincipal;
  public

  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

procedure TFormPrincipal.Button1Click(Sender: TObject);
var
  AProxy: TSMServidorClient;
begin
  AProxy := FDMPrincipal.Proxy;
  try
    Memo1.Text := AProxy.Teste.ToString;
  finally
    AProxy.Free;
  end;
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
  FDMPrincipal := TDMPrincipal.Create(Self);
end;

procedure TFormPrincipal.FormDestroy(Sender: TObject);
begin
  FDMPrincipal.Free;
end;

end.
