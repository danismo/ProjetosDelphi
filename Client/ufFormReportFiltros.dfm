object FormReportFiltros: TFormReportFiltros
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Filtro Relat'#243'rio - Informe o per'#237'odo'
  ClientHeight = 118
  ClientWidth = 354
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 354
    Height = 77
    Align = alClient
    TabOrder = 0
    ExplicitTop = -6
    ExplicitWidth = 469
    ExplicitHeight = 67
    object Label1: TLabel
      Left = 30
      Top = 28
      Width = 36
      Height = 13
      Caption = 'Per'#237'odo'
    end
    object Label2: TLabel
      Left = 183
      Top = 28
      Width = 6
      Height = 13
      Caption = 'a'
    end
    object EdtDataIni: TDateTimePicker
      Left = 72
      Top = 25
      Width = 105
      Height = 21
      Date = 45413.615467766210000000
      Time = 45413.615467766210000000
      TabOrder = 0
    end
    object EdtDataFin: TDateTimePicker
      Left = 200
      Top = 25
      Width = 105
      Height = 21
      Date = 45413.615467766210000000
      Time = 45413.615467766210000000
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 77
    Width = 354
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 75
    object Button1: TButton
      Left = 230
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Gerar'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
end
