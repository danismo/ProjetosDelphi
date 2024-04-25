object FormServidor: TFormServidor
  Left = 0
  Top = 0
  Caption = 'Servidor'
  ClientHeight = 91
  ClientWidth = 380
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonStatus: TButton
    Left = 144
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 0
    OnClick = ButtonStatusClick
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 280
    Top = 16
  end
end
