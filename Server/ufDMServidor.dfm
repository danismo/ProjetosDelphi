object DMServidor: TDMServidor
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 215
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=C:\Dev\Delphi\Projetos\ProjetosDelphi\DB\DADOS.FDB'
      'User_Name=sysdba'
      'Password=masterkey'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Left = 32
    Top = 16
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 88
    Top = 80
  end
end
