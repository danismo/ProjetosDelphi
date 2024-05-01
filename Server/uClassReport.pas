unit uClassReport;

interface

uses
  FireDAC.Comp.Client, Bde.DBTables, System.JSON, FireDAC.Stan.Def, FireDAC.Phys.FB,
  FireDAC.DApt, FireDAC.Stan.Async, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, REST.JSON, uClassBase, uClassPosto;

type
  TReportPosto = class(TBaseClass)
  private
    function GetSqlReport: String;
    function GetValuesRelatorio(_AQuery: TFDQuery): TAbastecimentoRelatorio;
  public
    function GerarRelatorio(_AJSON: TJSONValue): TJSONObject;
    function TratarJSONRetorno(_AJSON: String): String;
  end;

implementation

{ TReportPosto }

function TReportPosto.GerarRelatorio(_AJSON: TJSONValue): TJSONObject;
var
  AQuery: TFDQuery;
  AAbastecimentoRelatorioList: TAbastecimentoRelatorioList;
  AAbastecimentoRelatorio: TAbastecimentoRelatorio;
begin
  Result := nil;
  AQuery := GetQuery;
  try
    AQuery.SQL.Text := GetSqlReport;
    AQuery.Active := True;
    if AQuery.IsEmpty then
      Exit;

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
  Result := 'SELECT * FROM ABASTECIMENTO';
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

function TReportPosto.TratarJSONRetorno(_AJSON: String): String;
begin

end;

end.
