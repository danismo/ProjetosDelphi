unit uClassPosto;

interface

uses
  FireDAC.Comp.Client, Bde.DBTables, System.JSON;

type
  TBaseClass = class
  private
    FJSONObject: TJSONObject;
    FDConnection: TFDConnection;
    function ExistsPair(_ACampo: String): Boolean;
    procedure SetParamsConnection;
    function JSONDateToDatetime(_AJSONDateTime: String): TDateTime;
  public
    constructor Create; overload;
    destructor Destroy;

    function GetConnection: TFDConnection;
    function GetQuery: TFDQuery;
    function GetCodigoGenerator(_ANome: String): Integer;

    function GetFromJSONValue(_ACampo: String): String;
    procedure ProcessarJSONtoObject(_AJSON: TJSONValue); overload;
  end;

  TAbastecimento = class(TBaseClass)
  private
    FCodigo: Integer;
    FBomba: Integer;
    FTanque: Integer;
    FLitros: Currency;
    FValorLitro: Currency;
    FValorTotal: Currency;
    FAliquota: Currency;
    FValorAliquota: Currency;
    FDataAbastecimento: TDateTime;
    procedure CalcularTotais;
    function GetSqlInsert: String;
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property Bomba: Integer read FBomba write FBomba;
    property Tanque: Integer read FTanque write FTanque;
    property Litros: Currency read FLitros write FLitros;
    property ValorLitro: Currency read FValorLitro write FValorLitro;
    property ValorTotal: Currency read FValorTotal write FValorTotal;
    property Aliquota: Currency read FAliquota write FAliquota;
    property ValorAliquota: Currency read FValorAliquota write FValorAliquota;
    property DataAbastecimento: TDateTime read FDataAbastecimento write FDataAbastecimento;

    function ProcessarAbastecimento: Integer;
    procedure ProcessarJSONtoObject(_AJSON: TJSONValue); overload;
  end;

  TAbastecimentoRetorno = class
  private
    FCodigo: Integer;
  public
    property Codigo: Integer read FCodigo write FCodigo;
  end;

implementation

uses
  System.SysUtils, DateUtils;

{ TAbastecimento }

procedure TAbastecimento.CalcularTotais;
var
  ATotalBruto: Currency;
begin
  ATotalBruto := ValorLitro * Litros;
  ValorAliquota := ATotalBruto * (Aliquota/100);
  ValorTotal := ATotalBruto + ValorAliquota;
end;

function TAbastecimento.GetSqlInsert: String;
begin
  Result := 'SELECT * ' +
            '  FROM ABASTECIMENTO ' +
            ' WHERE CODIGO = -1';
end;

function TAbastecimento.ProcessarAbastecimento: Integer;
var
  AQuery: TFDQuery;
begin
  CalcularTotais;
  AQuery := GetQuery;
  try
    Codigo := GetCodigoGenerator('CODIGOABASTECIMENTO');
    AQuery.SQL.Text := GetSqlInsert;
    AQuery.Open;
    AQuery.Insert;
    AQuery.FieldByName('CODIGO').AsInteger := Codigo;
    AQuery.FieldByName('BOMBA').AsInteger := Bomba;
    AQuery.FieldByName('TANQUE').AsInteger := Tanque;
    AQuery.FieldByName('LITROS').AsCurrency := Litros;
    AQuery.FieldByName('VALOR_LITRO').AsCurrency := ValorLitro;
    AQuery.FieldByName('VALOR_TOTAL').AsCurrency := ValorTotal;
    AQuery.FieldByName('ALIQUOTA').AsCurrency := Aliquota;
    AQuery.FieldByName('VALOR_ALIQUOTA').AsCurrency := ValorAliquota;
    AQuery.FieldByName('DATA_ABASTECIMENTO').AsDateTime := DataAbastecimento;
    AQuery.ApplyUpdates(-1);
    Result := Codigo;
  finally
    AQuery.Free;
  end;
end;

procedure TAbastecimento.ProcessarJSONtoObject(_AJSON: TJSONValue);
var
  AValue: String;
begin
  inherited;
  Bomba := StrToInt(GetFromJSONValue('Bomba'));
  Tanque := StrToInt(GetFromJSONValue('Tanque'));

  AValue := GetFromJSONValue('Litros').Replace('.',',');
  Litros := StrToCurr(AValue);

  AValue := GetFromJSONValue('ValorLitro').Replace('.',',');
  ValorLitro := StrToCurr(AValue);

  AValue := GetFromJSONValue('Aliquota').Replace('.',',');
  Aliquota := StrToCurr(AValue);

  DataAbastecimento := JSONDateToDatetime(GetFromJSONValue('DataAbastecimento'));
end;

{ TBaseClass }

constructor TBaseClass.Create;
begin
  FDConnection := TFDConnection.Create(nil);
  SetParamsConnection;
end;

destructor TBaseClass.Destroy;
begin
  FreeAndNil(FDConnection);
end;

function TBaseClass.ExistsPair(_ACampo: String): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to FJSONObject.Count-1 do
  begin
    if LowerCase(FJSONObject.Pairs[i].JsonString.Value) = LowerCase(_ACampo) then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

function TBaseClass.GetCodigoGenerator(_ANome: String): Integer;
var
  AQuery: TFDQuery;
begin
  AQuery := GetQuery;
  try
    AQuery.SQL.Text := 'SELECT GEN_ID(' + _ANome + ', 1) AS CODIGO FROM RDB$DATABASE';
    AQuery.Open;
    Result := AQuery.FieldByName('CODIGO').AsInteger;
  finally
    AQuery.Free;
  end;
end;

function TBaseClass.GetConnection: TFDConnection;
begin
  Result := FDConnection;
end;

function TBaseClass.GetFromJSONValue(_ACampo: String): String;
begin
  Result := '';
  if ExistsPair(_ACampo) then
    Result := FJSONObject.GetValue(_ACampo).ToString;
end;

function TBaseClass.GetQuery: TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  try
    Result.Connection := GetConnection;
    Result.CachedUpdates := True;
  except
    on E:Exception do
      raise Exception.Create('Error ao criar query: ' + E.Message);
  end;
end;

function TBaseClass.JSONDateToDatetime(_AJSONDateTime: String): TDateTime;
var
  AStr: String;
  Ano, Mes, Dia, Hora, Minuto, Segundo: Word;
begin
  AStr := _AJSONDateTime.Replace('"','');
  Ano := StrToInt(Copy(AStr, 1, 4));
  Mes := StrToInt(Copy(AStr, 6, 2));
  Dia := StrToInt(Copy(AStr, 9, 2));
  Hora := StrToInt(Copy(AStr, 12, 2));
  Minuto := StrToInt(Copy(AStr, 15, 2));
  Segundo := StrToInt(Copy(AStr, 18, 2));

  Result := EncodeDateTime(Ano, Mes, Dia, Hora, Minuto, Segundo, 0);
end;

procedure TBaseClass.ProcessarJSONtoObject(_AJSON: TJSONValue);
begin
  FJSONObject := _AJSON as TJSONObject;
end;

procedure TBaseClass.SetParamsConnection;
begin
  FDConnection.Params.LoadFromFile('dbconexao.ini');
  FDConnection.LoginPrompt := False;
  FDConnection.Connected := True;
end;

end.

connect 'C:\Dev\Delphi\Projetos\ProjetosDelphi\DB\dados.fdb' user 'SYSDBA' password '12345';

create table ABASTECIMENTO(
  CODIGO integer not null primary key,
  BOMBA integer not null,
  TANQUE integer not null,
  LITROS numeric(9,4) not null,
  VALOR_LITRO numeric(9,4) not null,
  VALOR_TOTAL numeric(12,4) not null,
  ALIQUOTA numeric(2,2) default 0,
  VALOR_ALIQUOTA numeric(12,4) not null,
  DATA_ABASTECIMENTO TIMESTAMP
);

CREATE SEQUENCE CODIGOABASTECIMENTO;
