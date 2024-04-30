program ProjClient;

uses
  Vcl.Forms,
  ufFormPrincipal in 'ufFormPrincipal.pas' {FormPrincipal},
  uClassPosto in '..\Comum\uClassPosto.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
