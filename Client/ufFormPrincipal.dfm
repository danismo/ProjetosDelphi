object FormPrincipal: TFormPrincipal
  Left = 0
  Top = 0
  Caption = 'Posto ABC'
  ClientHeight = 349
  ClientWidth = 735
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Tag = 1
    Left = 185
    Top = 33
    Width = 185
    Height = 271
    Align = alLeft
    TabOrder = 1
    object Label4: TLabel
      Left = 93
      Top = 6
      Width = 54
      Height = 13
      Caption = 'TANQUE 1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 27
      Top = 6
      Width = 50
      Height = 13
      Caption = 'BOMBA 2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label11: TLabel
      Left = 1
      Top = 255
      Width = 63
      Height = 15
      Align = alBottom
      Alignment = taCenter
      Caption = 'GASOLINA'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label19: TLabel
      Left = 35
      Top = 41
      Width = 26
      Height = 13
      Caption = 'Litros'
    end
    object Label23: TLabel
      Left = 37
      Top = 68
      Width = 24
      Height = 13
      Caption = 'Total'
    end
    object EdtLitrosBomba2: TEdit
      Left = 67
      Top = 38
      Width = 76
      Height = 21
      TabOrder = 0
      Text = '0'
      OnExit = EdtLitrosBomba2Exit
      OnKeyPress = EdtLitrosBomba2KeyPress
    end
    object EdtTotalBomba2: TEdit
      Left = 67
      Top = 65
      Width = 76
      Height = 21
      Enabled = False
      TabOrder = 1
      Text = '0,00'
      OnKeyPress = EdtKeyPress
    end
    object Button2: TButton
      Left = 56
      Top = 224
      Width = 75
      Height = 25
      Caption = 'Abastecer'
      TabOrder = 2
      OnClick = Button2Click
    end
  end
  object Panel1: TPanel
    Tag = 1
    Left = 0
    Top = 33
    Width = 185
    Height = 271
    Align = alLeft
    TabOrder = 0
    object Label2: TLabel
      Left = 27
      Top = 6
      Width = 50
      Height = 13
      Caption = 'BOMBA 1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 101
      Top = 6
      Width = 54
      Height = 13
      Caption = 'TANQUE 1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label10: TLabel
      Left = 1
      Top = 255
      Width = 63
      Height = 15
      Align = alBottom
      Alignment = taCenter
      Caption = 'GASOLINA'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label14: TLabel
      Left = 27
      Top = 41
      Width = 26
      Height = 13
      Caption = 'Litros'
    end
    object Label22: TLabel
      Left = 29
      Top = 68
      Width = 24
      Height = 13
      Caption = 'Total'
    end
    object EdtLitrosBomba1: TEdit
      Left = 59
      Top = 38
      Width = 76
      Height = 21
      TabOrder = 0
      Text = '0'
      OnExit = EdtLitrosBomba1Exit
      OnKeyPress = EdtLitrosBomba1KeyPress
    end
    object EdtTotalBomba1: TEdit
      Left = 59
      Top = 65
      Width = 76
      Height = 21
      Enabled = False
      TabOrder = 1
      Text = '0,00'
      OnKeyPress = EdtKeyPress
    end
    object Button1: TButton
      Left = 55
      Top = 224
      Width = 75
      Height = 25
      Caption = 'Abastecer'
      TabOrder = 2
      OnClick = Button1Click
    end
  end
  object Panel3: TPanel
    Tag = 2
    Left = 370
    Top = 33
    Width = 185
    Height = 271
    Align = alLeft
    TabOrder = 2
    object Label6: TLabel
      Left = 101
      Top = 6
      Width = 54
      Height = 13
      Caption = 'TANQUE 2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 35
      Top = 6
      Width = 50
      Height = 13
      Caption = 'BOMBA 3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label12: TLabel
      Left = 1
      Top = 255
      Width = 43
      Height = 15
      Align = alBottom
      Alignment = taCenter
      Caption = 'DIESEL'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label20: TLabel
      Left = 35
      Top = 41
      Width = 26
      Height = 13
      Caption = 'Litros'
    end
    object Label24: TLabel
      Left = 37
      Top = 68
      Width = 24
      Height = 13
      Caption = 'Total'
    end
    object EdtLitrosBomba3: TEdit
      Tag = 1
      Left = 67
      Top = 38
      Width = 76
      Height = 21
      TabOrder = 0
      Text = '0'
      OnExit = EdtLitrosBomba3Exit
      OnKeyPress = EdtLitrosBomba3KeyPress
    end
    object EdtTotalBomba3: TEdit
      Left = 67
      Top = 65
      Width = 76
      Height = 21
      Enabled = False
      TabOrder = 1
      Text = '0,00'
      OnKeyPress = EdtKeyPress
    end
    object Button3: TButton
      Left = 56
      Top = 224
      Width = 75
      Height = 25
      Caption = 'Abastecer'
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object Panel4: TPanel
    Tag = 2
    Left = 555
    Top = 33
    Width = 181
    Height = 271
    Align = alLeft
    TabOrder = 3
    object Label8: TLabel
      Left = 96
      Top = 6
      Width = 54
      Height = 13
      Caption = 'TANQUE 2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label9: TLabel
      Left = 30
      Top = 6
      Width = 50
      Height = 13
      Caption = 'BOMBA 4'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label13: TLabel
      Left = 1
      Top = 255
      Width = 43
      Height = 15
      Align = alBottom
      Alignment = taCenter
      Caption = 'DIESEL'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label21: TLabel
      Left = 35
      Top = 41
      Width = 26
      Height = 13
      Caption = 'Litros'
    end
    object Label25: TLabel
      Left = 37
      Top = 68
      Width = 24
      Height = 13
      Caption = 'Total'
    end
    object EdtLitrosBomba4: TEdit
      Tag = 1
      Left = 67
      Top = 38
      Width = 76
      Height = 21
      TabOrder = 0
      Text = '0'
      OnExit = EdtLitrosBomba4Exit
      OnKeyPress = EdtLitrosBomba4KeyPress
    end
    object EdtTotalBomba4: TEdit
      Left = 67
      Top = 65
      Width = 76
      Height = 21
      Enabled = False
      TabOrder = 1
      Text = '0,00'
      OnKeyPress = EdtKeyPress
    end
    object Button4: TButton
      Left = 53
      Top = 224
      Width = 75
      Height = 25
      Caption = 'Abastecer'
      TabOrder = 2
      OnClick = Button4Click
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 735
    Height = 33
    Align = alTop
    TabOrder = 4
    object Label1: TLabel
      Left = 27
      Top = 10
      Width = 39
      Height = 13
      Caption = 'Al'#237'quota'
    end
    object Label15: TLabel
      Left = 180
      Top = 10
      Width = 70
      Height = 13
      Caption = 'Pre'#231'o Gasolina'
    end
    object Label16: TLabel
      Left = 335
      Top = 10
      Width = 14
      Height = 13
      Caption = '(lt)'
    end
    object Label17: TLabel
      Left = 373
      Top = 10
      Width = 58
      Height = 13
      Caption = 'Pre'#231'o Diesel'
    end
    object Label18: TLabel
      Left = 517
      Top = 10
      Width = 14
      Height = 13
      Caption = '(lt)'
    end
    object Label26: TLabel
      Left = 134
      Top = 10
      Width = 11
      Height = 13
      Caption = '%'
    end
    object EdtAliquota: TEdit
      Left = 72
      Top = 6
      Width = 58
      Height = 21
      TabOrder = 0
      Text = '13'
      OnKeyPress = EdtKeyPress
    end
    object EdtPrecoGasolina: TEdit
      Left = 256
      Top = 6
      Width = 76
      Height = 21
      TabOrder = 1
      Text = '5,66'
      OnKeyPress = EdtKeyPress
    end
    object EdtPrecoDiesel: TEdit
      Left = 438
      Top = 6
      Width = 76
      Height = 21
      TabOrder = 2
      Text = '5,30'
      OnKeyPress = EdtKeyPress
    end
  end
  object Panel6: TPanel
    Left = 0
    Top = 304
    Width = 735
    Height = 45
    Align = alBottom
    TabOrder = 5
  end
end
