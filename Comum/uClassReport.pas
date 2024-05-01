unit uClassReport;

interface

uses
  FireDAC.Comp.Client, Bde.DBTables, System.JSON, FireDAC.Stan.Def, FireDAC.Phys.FB,
  FireDAC.DApt, FireDAC.Stan.Async, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, REST.JSON, uClassBase, uClassPosto, Data.DB;

type
  TReportFiltros = class
  private
    FDataInicial: TDateTime;
    FDataFinal: TDateTime;
  public
    property DataInicial: TDateTime read FDataInicial write FDataInicial;
    property DataFinal: TDateTime read FDataFinal write FDataFinal;
  end;

  TReportPosto = class(TBaseClass)
  private
    function GetSqlReport: String;
    function GetValuesRelatorio(_AQuery: TFDQuery): TAbastecimentoRelatorio;
    function ProcessarJSONtoObject(_AJSON: TJSONValue): TReportFiltros;
  public
    function GerarRelatorio(_AJSON: TJSONValue): TJSONObject;
  end;

implementation

uses
  DateUtils;

{ TReportPosto }

function TReportPosto.GerarRelatorio(_AJSON: TJSONValue): TJSONObject;
var
  AQuery: TFDQuery;
  AAbastecimentoRelatorioList: TAbastecimentoRelatorioList;
  AAbastecimentoRelatorio: TAbastecimentoRelatorio;
  AReportFiltros: TReportFiltros;
begin
  Result := nil;
  AQuery := GetQuery;
  try
    AReportFiltros := ProcessarJSONtoObject(_AJSON);
    try
      AQuery.SQL.Text := GetSqlReport;
      AQuery.Params.ParamValues['DATAINICIAL'] := AReportFiltros.DataInicial;
      AQuery.Params.ParamValues['DATAFINAL'] := AReportFiltros.DataFinal;
      AQuery.Active := True;
      if AQuery.IsEmpty then
        Exit;
    finally
      AReportFiltros.Free;
    end;

    AAbastecimentoRelatorioList := TAbastecimentoRelatorioList.Create;
    try
      while not AQuery.Eof do
      begin
        AAbastecimentoRelatorio := GetValuesRelatorio(AQuery);
        AAbastecimentoRelatorioList.Add(AAbastecimentoRelatorio);
        AQuery.Next;
      end;
      Result := AAbastecimentoRelatorioList.ToJSON;
    finally
      AAbastecimentoRelatorioList.Free
    end;
  finally
    AQuery.Free;
  end;
end;

function TReportPosto.GetSqlReport: String;
begin
  Result := 'SELECT * ' +
            '  FROM ABASTECIMENTO ' +
            ' WHERE DATA_ABASTECIMENTO BETWEEN :DATAINICIAL AND :DATAFINAL ' +
            ' ORDER BY DATA_ABASTECIMENTO, BOMBA, TANQUE, VALOR_TOTAL';
end;

function TReportPosto.GetValuesRelatorio(_AQuery: TFDQuery): TAbastecimentoRelatorio;
begin
  Result := TAbastecimentoRelatorio.Create;
  Result.Codigo := _AQuery.FieldByName('CODIGO').AsInteger;
  Result.Bomba := _AQuery.FieldByName('BOMBA').AsInteger;
  Result.Tanque := _AQuery.FieldByName('TANQUE').AsInteger;
  Result.Litros := _AQuery.FieldByName('LITROS').AsCurrency;
  Result.ValorLitro := _AQuery.FieldByName('VALOR_LITRO').AsCurrency;
  Result.ValorTotal := _AQuery.FieldByName('VALOR_TOTAL').AsCurrency;
  Result.Aliquota := _AQuery.FieldByName('ALIQUOTA').AsCurrency;
  Result.ValorAliquota := _AQuery.FieldByName('VALOR_ALIQUOTA').AsCurrency;
  Result.DataAbastecimento := _AQuery.FieldByName('DATA_ABASTECIMENTO').AsDateTime;
end;

function TReportPosto.ProcessarJSONtoObject(_AJSON: TJSONValue): TReportFiltros;
begin
  FJSONObject := _AJSON as TJSONObject;
  Result := TReportFiltros.Create;
  Result.DataInicial := JSONDateToDatetime(GetFromJSONValue('DataInicial'));
  Result.DataFinal := JSONDateToDatetime(GetFromJSONValue('DataFinal'));
end;

end.
