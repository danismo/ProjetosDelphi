unit uClassPosto;

interface

uses
  FireDAC.Comp.Client, Bde.DBTables, System.JSON, FireDAC.Stan.Def, FireDAC.Phys.FB,
  FireDAC.DApt, FireDAC.Stan.Async, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, REST.JSON, uClassBase, System.Generics.Collections;

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

  TAbastecimentoRelatorio = class
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
  end;

  TAbastecimentoRelatorioList = class(TObjectList<TAbastecimentoRelatorio>)
  public
    function ToJSON: TJSONObject;
  end;

  TAbastecimentoBase = class(TBaseClass)
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
  end;

  TAbastecimento = class(TAbastecimentoBase)
  private
    function GetSqlInsert: String;
  public
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

{ TAbastecimentoRelatorioList }

function TAbastecimentoRelatorioList.ToJSON: TJSONObject;
begin
  Result := REST.JSON.TJSON.ObjectToJsonObject(Self);
end;

end.
