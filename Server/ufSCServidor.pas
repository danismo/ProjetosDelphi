unit ufSCServidor;

interface

uses System.SysUtils, System.Classes,
  Datasnap.DSTCPServerTransport,
  Datasnap.DSServer, Datasnap.DSCommonServer,
  Datasnap.DSAuth, IPPeerServer, Datasnap.DSHTTP;

type
  TSCServidor = class(TDataModule)
    DSServer1: TDSServer;
    DSTCPServerTransport1: TDSTCPServerTransport;
    DSServerClass1: TDSServerClass;
    DSHTTPService1: TDSHTTPService;
    procedure DSServerClass1GetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
  private
    { Private declarations }
  public
    procedure StartService;
    procedure StopService;
    function IsStarted: Boolean;
  end;

var
  SCServidor: TSCServidor;

implementation

{$R *.dfm}

uses Winapi.Windows, ufSMServidor;

const
   DEFAULT_PORT = 8081;

procedure TSCServidor.DSServerClass1GetClass(
  DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := ufSMServidor.TSMServidor;
end;

function TSCServidor.IsStarted: Boolean;
begin
  Result := DSHTTPService1.Active;
end;

procedure TSCServidor.StartService;
begin
  DSHTTPService1.Active := True;
end;

procedure TSCServidor.StopService;
begin
  DSHTTPService1.Active := False;
end;

end.

