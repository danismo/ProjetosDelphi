unit uClassBase;

interface
uses
  FireDAC.Comp.Client, Bde.DBTables, System.JSON, FireDAC.Stan.Def, FireDAC.Phys.FB,
  FireDAC.DApt, FireDAC.Stan.Async, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, REST.JSON;

type
  TBaseClass = class
  private
    FDConnection: TFDConnection;
    procedure SetParamsConnection;
  public
    FJSONObject: TJSONObject;
    constructor Create; overload;
    destructor Destroy; override;

    function GetConnection: TFDConnection;
    function GetQuery: TFDQuery;
    function GetCodigoGenerator(_ANome: String): Integer;

    function GetFromJSONValue(_ACampo: String): String;
    procedure ProcessarJSONtoObject(_AJSON: TJSONValue); overload;
  end;

  function JSONDateToDatetime(_AJSONDateTime: String): TDateTime;
  function RemoverStringsMarshal(_AJSON: String): String;

implementation

uses
  System.SysUtils, DateUtils, Math, System.Classes;

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

function JSONDateToDatetime(_AJSONDateTime: String): TDateTime;
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

function RemoverStringsMarshal(_AJSON: String): String;
var
  i, APos: Integer;
  AJSONString: String;
begin
  AJSONString := _AJSON.Replace('{"result":[{"ownsObjects":true,"items":','');
  for i := Pos('arrayManager', AJSONString)-1 downto 0 do
  begin
    if AJSONString[i] = '}' then
    begin
      APos := AJSONString.Length-i;
      AJSONString := Copy(AJSONString, 0, AJSONString.Length - APos);
      AJSONString := AJSONString + ']';
      break;
    end;
  end;
  Result := AJSONString;
end;

end.
