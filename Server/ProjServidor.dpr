program ProjServidor;

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  ufFormServidor in 'ufFormServidor.pas' {FormServidor},
  ufSMServidor in 'ufSMServidor.pas',
  ufSCServidor in 'ufSCServidor.pas' {SCServidor: TDataModule},
  uClassPosto in '..\Comum\uClassPosto.pas',
  uClassBase in '..\Comum\uClassBase.pas',
  uClassReport in '..\Comum\uClassReport.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSCServidor, SCServidor);
  Application.CreateForm(TFormServidor, FormServidor);
  Application.Run;
end.

