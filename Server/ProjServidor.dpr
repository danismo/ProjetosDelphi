program ProjServidor;

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  ufFormServidor in 'ufFormServidor.pas' {FormServidor},
  ufSMServidor in 'ufSMServidor.pas',
  ufSCServidor in 'ufSCServidor.pas' {SCServidor: TDataModule},
  uClassPosto in '..\Comum\uClassPosto.pas',
  ufDMServidor in 'ufDMServidor.pas' {DMServidor: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSCServidor, SCServidor);
  Application.CreateForm(TFormServidor, FormServidor);
  Application.Run;
end.

