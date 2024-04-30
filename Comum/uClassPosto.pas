unit uClassPosto;

interface

uses
  FireDAC.Comp.Client, Bde.DBTables, System.JSON, FireDAC.Stan.Def, FireDAC.Phys.FB,
  FireDAC.DApt, FireDAC.Stan.Async, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, REST.JSON;

type
  TMetodosREST = class
  private
    FUrl: String;
    procedure SetParametersHTTP(_AIdHTTP: TIdHTTP);
    procedure SetUrl(_AUrl: String);
    function GetUrl: String;
  public
    property Url: String read GetUrl write SetUrl;

    constructor Create(_AUrl: String);
    function Post(_AJSONObject: TJSONObject): String;
  end;

  TAbastecimentoEnvio = class
  private
    FBomba: Integer;
    FTanque: Integer;
    FLitros: Currency;
    FValorLitro: Currency;
    FAliquota: Currency;
    FDataAbastecimento: TDateTime;
  public
    property Bomba: Integer read FBomba write FBomba;
    property Tanque: Integer read FTanque write FTanque;
    property Litros: Currency read FLitros write FLitros;
    property ValorLitro: Currency read FValorLitro write FValorLitro;
    property Aliquota: Currency read FAliquota write FAliquota;
    property DataAbastecimento: TDateTime read FDataAbastecimento write FDataAbastecimento;
  end;

  TBaseClass = class
  private
    FJSONObject: TJSONObject;
    FDConnection: TFDConnection;
    procedure SetParamsConnection;
    function JSONDateToDatetime(_AJSONDateTime: String): TDateTime;
  public
    constructor Create; overload;
    destructor Destroy; override;

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

  TTotais = record
    ValorLitro: Currency;
    Litros: Currency;
    Aliquota: Currency;
    ValorAliquota: Currency;
    ValorTotal: Currency;
  end;

  procedure CalcularTotais(var _ATotais: TTotais);

implementation

uses
  System.SysUtils, DateUtils, Math, System.Classes;

procedure CalcularTotais(var _ATotais: TTotais);
var
  ATotalBruto: Currency;
begin
  ATotalBruto := _ATotais.ValorLitro * _ATotais.Litros;
  _ATotais.ValorAliquota := ATotalBruto * (_ATotais.Aliquota/100);
  _ATotais.ValorTotal := ATotalBruto + _ATotais.ValorAliquota;
  _ATotais.ValorAliquota := RoundTo(_ATotais.ValorAliquota, -2);
  _ATotais.ValorTotal := RoundTo(_ATotais.ValorTotal, -2);
end;

{ TAbastecimento }
function TAbastecimento.GetSqlInsert: String;
begin
  Result := 'SELECT * ' +
            '  FROM ABASTECIMENTO ' +
            ' WHERE CODIGO = -1';
end;

function TAbastecimento.ProcessarAbastecimento: Integer;
var
  AQuery: TFDQuery;
  ATotais: TTotais;
begin
  ATotais.ValorLitro := ValorLitro;
  ATotais.Litros := Litros;
  ATotais.Aliquota := Aliquota;
  CalcularTotais(ATotais);
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
    AQuery.FieldByName('VALOR_TOTAL').AsCurrency := ATotais.ValorTotal;
    AQuery.FieldByName('ALIQUOTA').AsCurrency := Aliquota;
    AQuery.FieldByName('VALOR_ALIQUOTA').AsCurrency := ATotais.ValorAliquota;
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
var
  i: Integer;
begin
  Result := '';
  for i := 0 to FJSONObject.Count-1 do
  begin
    if LowerCase(FJSONObject.Pairs[i].JsonString.Value) = LowerCase(_ACampo) then
    begin
      Result := FJSONObject.Pairs[i].JsonValue.Value;
      Exit;
    end;
  end;
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

{ TMetodosREST }

constructor TMetodosREST.Create(_AUrl: String);
begin
  Url := _AUrl;
end;

function TMetodosREST.GetUrl: String;
begin
  Result := FUrl;
end;

function TMetodosREST.Post(_AJSONObject: TJSONObject): String;
var
  AJSONEnvio: TStream;
  FIdHTTP: TIdHTTP;
begin
  FIdHTTP := TIdHTTP.Create(nil);
  try
    SetParametersHTTP(FIdHTTP);

    AJSONEnvio := TStringStream.Create(_AJSONObject.ToString);
    try
      AJSONEnvio.Position := 0;
      try
        Result := FIdHTTP.Post(Url, AJSONEnvio);
      except
        on E: Exception do
          raise Exception.Create('Erro ao enviar JSON: ' + E.Message);
      end;
    finally
      AJSONEnvio.Free;
    end;
  finally
    FIdHTTP.Free;
  end;
end;

procedure TMetodosREST.SetParametersHTTP(_AIdHTTP: TIdHTTP);
begin
  _AIdHTTP.Request.UserAgent:= 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36';
  _AIdHTTP.Request.Accept := 'application/json, text/javascript, */*; q=0.01';
  _AIdHTTP.Request.ContentType := 'application/x-www-form-urlencoded; charset=UTF-8';
  _AIdHTTP.Request.CharSet := 'utf-8';
end;

procedure TMetodosREST.SetUrl(_AUrl: String);
begin
  FUrl := _AUrl;
end;

end.
