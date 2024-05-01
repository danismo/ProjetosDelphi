program ProjClient;

uses
  Vcl.Forms,
  ufFormPrincipal in 'ufFormPrincipal.pas' {FormPrincipal},
  uClassPosto in '..\Comum\uClassPosto.pas',
  ufFormReport in 'ufFormReport.pas' {FormReport},
  uClassBase in '..\Comum\uClassBase.pas',
  ufFormReportFiltros in 'ufFormReportFiltros.pas' {FormReportFiltros},
  uClassReport in '..\Comum\uClassReport.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
