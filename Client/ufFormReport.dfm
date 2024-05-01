object FormReport: TFormReport
  Left = 0
  Top = 0
  Caption = 'FormReport'
  ClientHeight = 469
  ClientWidth = 794
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
  object RLReport1: TRLReport
    Left = 0
    Top = 40
    Width = 794
    Height = 1123
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    object BandHeader: TRLBand
      Left = 38
      Top = 57
      Width = 718
      Height = 51
      BandType = btColumnHeader
      Borders.Sides = sdCustom
      Borders.DrawLeft = False
      Borders.DrawTop = False
      Borders.DrawRight = False
      Borders.DrawBottom = True
      object RLLabel2: TRLLabel
        Left = 203
        Top = 10
        Width = 312
        Height = 30
        Align = faCenter
        Caption = 'Relat'#243'rio Abastecimentos'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = 30
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object BandCabecalho: TRLBand
      Left = 38
      Top = 38
      Width = 718
      Height = 19
      BandType = btTitle
      Borders.Sides = sdCustom
      Borders.DrawLeft = False
      Borders.DrawTop = False
      Borders.DrawRight = False
      Borders.DrawBottom = True
      object RLLabel1: TRLLabel
        Left = 288
        Top = 0
        Width = 142
        Height = 18
        Align = faCenter
        Alignment = taCenter
        Caption = 'POSTO ABC'
      end
      object RLSystemInfo2: TRLSystemInfo
        Left = 679
        Top = 0
        Width = 39
        Height = 16
        Alignment = taRightJustify
        Info = itHour
        Text = ''
      end
      object RLSystemInfo1: TRLSystemInfo
        Left = 0
        Top = 0
        Width = 39
        Height = 16
        Text = ''
      end
    end
    object BandTitulo: TRLBand
      Left = 38
      Top = 108
      Width = 718
      Height = 21
      BandType = btColumnHeader
      object RLLabel3: TRLLabel
        Left = 180
        Top = 2
        Width = 50
        Height = 16
        Alignment = taCenter
        Caption = 'Bomba'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object RLLabel4: TRLLabel
        Left = 275
        Top = 2
        Width = 52
        Height = 16
        Alignment = taCenter
        Caption = 'Tanque'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object RLLabel5: TRLLabel
        Left = 364
        Top = 2
        Width = 58
        Height = 16
        Alignment = taCenter
        Caption = 'Valor R$'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object RLLabel6: TRLLabel
        Left = 11
        Top = 2
        Width = 34
        Height = 16
        Alignment = taCenter
        Caption = 'Data'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object BandConteudo: TRLBand
      Left = 38
      Top = 129
      Width = 718
      Height = 24
      object RLDBText1: TRLDBText
        Left = 11
        Top = 6
        Width = 155
        Height = 16
        DataField = 'DATA_ABASTECIMENTO'
        DataSource = DataSource1
        Text = ''
      end
      object RLDBText2: TRLDBText
        Left = 180
        Top = 6
        Width = 52
        Height = 16
        DataField = 'BOMBA'
        DataSource = DataSource1
        Text = ''
      end
      object RLDBText3: TRLDBText
        Left = 275
        Top = 6
        Width = 57
        Height = 16
        DataField = 'TANQUE'
        DataSource = DataSource1
        Text = ''
      end
      object RLDBText4: TRLDBText
        Left = 364
        Top = 6
        Width = 95
        Height = 16
        DataField = 'VALOR_TOTAL'
        DataSource = DataSource1
        Text = ''
      end
    end
    object BandRodape: TRLBand
      Left = 38
      Top = 153
      Width = 718
      Height = 24
      BandType = btFooter
      Borders.Sides = sdCustom
      Borders.DrawLeft = False
      Borders.DrawTop = True
      Borders.DrawRight = False
      Borders.DrawBottom = False
      object RLDBResult1: TRLDBResult
        Left = 364
        Top = 4
        Width = 134
        Height = 16
        DataField = 'VALOR_TOTAL'
        DataSource = DataSource1
        Info = riSum
        Text = ''
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 794
    Height = 41
    Align = alTop
    TabOrder = 1
    object Button1: TButton
      Left = 16
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Gerar'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object DataSource1: TDataSource
    DataSet = FDTable
    Left = 451
    Top = 240
  end
  object FDTable: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 539
    Top = 240
  end
end
