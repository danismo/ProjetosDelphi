unit ufDMPrincipal;

interface

uses
  System.SysUtils, System.Classes, Data.DBXDataSnap, IPPeerClient,
  Data.DBXCommon, Data.DB, Data.SqlExpr, ufServerClass;

type
  TDMPrincipal = class(TDataModule)
    SQLConnection1: TSQLConnection;
  private
    { Private declarations }
    function GetProxy: TSMServidorClient;
    procedure SetConnected;
  public
    property Proxy: TSMServidorClient read GetProxy;
  end;

var
  DMPrincipal: TDMPrincipal;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDMPrincipal }

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

end.
