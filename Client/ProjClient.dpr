program ProjClient;

uses
  Vcl.Forms,
  ufFormPrincipal in 'ufFormPrincipal.pas' {FormPrincipal},
  ufDMPrincipal in 'ufDMPrincipal.pas' {DMPrincipal: TDataModule},
  ufServerClass in 'ufServerClass.pas',
  uClassPosto in '..\Comum\uClassPosto.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.CreateForm(TDMPrincipal, DMPrincipal);
  Application.Run;
end.
