unit ufDMServidor;

interface

uses
  System.SysUtils, System.Classes, Data.DBXFirebird, Data.DB, Data.SqlExpr,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Comp.Client, Bde.DBTables,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  TDMServidor = class(TDataModule)
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMServidor: TDMServidor;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDMServidor.DataModuleCreate(Sender: TObject);
begin
  FDConnection1.Params.LoadFromFile('dbconexao.ini');
  FDConnection1.Connected := True;
end;

end.
