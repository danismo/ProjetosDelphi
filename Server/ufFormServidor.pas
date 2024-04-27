unit ufFormServidor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Samples.Spin, ufSCServidor, Vcl.ExtCtrls, System.UITypes;

type
  TFormServidor = class(TForm)
    ButtonStatus: TButton;
    Timer1: TTimer;
    procedure ButtonStatusClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FMsgStatus: String;
    FStatusVisible: Boolean;
    procedure SetConnected;
    procedure SetDisconnected;
    procedure SetStatusConnection;

    procedure SetInitialCaptionStatus;
  public
    { Public declarations }
  end;

var
  FormServidor: TFormServidor;

implementation

{$R *.dfm}

const
  CAPTION_SERVIDOR = 'Servidor - Status: ';

procedure TFormServidor.ButtonStatusClick(Sender: TObject);
begin
  SetStatusConnection;
end;

procedure TFormServidor.FormCreate(Sender: TObject);
begin
  SetInitialCaptionStatus;
  Timer1.Enabled := True;
end;

procedure TFormServidor.SetInitialCaptionStatus;
begin
  FStatusVisible := True;
  FMsgStatus := 'Started';
  Caption := CAPTION_SERVIDOR + FMsgStatus;
end;

procedure TFormServidor.SetConnected;
begin
  SCServidor.StartService;
  ButtonStatus.Caption := 'Stop';
  FMsgStatus := 'Started';
end;

procedure TFormServidor.SetDisconnected;
begin
  if MessageDlg('Deseja realmente parar o serviço?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;

  SCServidor.StopService;
  ButtonStatus.Caption := 'Start';
  FMsgStatus := 'Stopped';
end;

procedure TFormServidor.SetStatusConnection;
begin
  try
    if not SCServidor.IsStarted then SetConnected
    else                             SetDisconnected;
  except
    on E: Exception do
      raise Exception.Create('Erro ao connectar: ' + E.Message);
  end;
end;

procedure TFormServidor.Timer1Timer(Sender: TObject);
begin
  if FStatusVisible then
    Caption := CAPTION_SERVIDOR
  else
    Caption := CAPTION_SERVIDOR + FMsgStatus;

  FStatusVisible := not FStatusVisible;
end;

end.

