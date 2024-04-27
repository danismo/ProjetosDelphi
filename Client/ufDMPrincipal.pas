unit ufDMPrincipal;

interface

uses
  System.SysUtils, System.Classes, Data.DBXDataSnap, IPPeerClient,
  Data.DBXCommon, Data.DB, Data.SqlExpr, ufServerClass;

type
  TDMPrincipal = class(TDataModule)
    SQLConnection1: TSQLConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    procedure SetParamsConnection;
    procedure SetConnected;

    function GetProxy: TSMServidorClient;
  public
    property Proxy: TSMServidorClient read GetProxy;
  end;

var
  DMPrincipal: TDMPrincipal;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDMPrincipal }

procedure TDMPrincipal.DataModuleCreate(Sender: TObject);
begin
  SetParamsConnection;
end;

function TDMPrincipal.GetProxy: TSMServidorClient;
begin
  SetConnected;
  Result := TSMServidorClient.Create(SQLConnection1.DBXConnection);
end;

procedure TDMPrincipal.SetConnected;
begin
  try
    if not SQLConnection1.Connected then
      SQLConnection1.Connected := True;
  except
    on E:Exception do
      raise Exception.Create('Erro ao conectar: ' + E.Message);
  end;
end;

procedure TDMPrincipal.SetParamsConnection;
begin
  SQLConnection1.Params.LoadFromFile('dsconexao.ini');
  SQLConnection1.LoginPrompt := False;
end;

end.
