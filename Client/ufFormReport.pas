unit ufFormReport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, RLReport,uClassPosto,
  Vcl.ExtCtrls, System.JSON, REST.JSON, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Data.DBXJSONReflect, System.UITypes,
  uClassBase, ufFormReportFiltros;

type
  TDatas_REC = record
    DataInicial: String;
    DataFinal: String;
  end;

  TFormReport = class(TForm)
    RLReport1: TRLReport;
    DataSource1: TDataSource;
    FDTable: TFDMemTable;
    BandHeader: TRLBand;
    BandCabecalho: TRLBand;
    BandTitulo: TRLBand;
    BandConteudo: TRLBand;
    BandRodape: TRLBand;
    RLLabel1: TRLLabel;
    RLSystemInfo2: TRLSystemInfo;
    RLSystemInfo1: TRLSystemInfo;
    RLLabel2: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLDBText1: TRLDBText;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLDBText4: TRLDBText;
    Panel1: TPanel;
    Button1: TButton;
    RLDBResult1: TRLDBResult;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure SetFieldsAbastecimento;
    procedure CreateField(_AName, _ADisplayName: String; _ADataType: TFieldType);

    procedure GerarRelatorio;
    function GetJSONFiltros: TJSONObject;
    function TratarRetornoReport(_AJSON: String): TAbastecimentoRelatorioList;
    function GetValuesAbastecimentoReport(_AJSON:TJSONObject): TAbastecimentoRelatorio;
  public
    { Public declarations }
  end;

var
  FormReport: TFormReport;

implementation

{$R *.dfm}

uses
  System.Contnrs, StrUtils;

procedure TFormReport.FormCreate(Sender: TObject);
begin
  SetFieldsAbastecimento;
  FDTable.CreateDataSet;
  GerarRelatorio;
end;

procedure TFormReport.SetFieldsAbastecimento;
begin
  CreateField('CODIGO', 'Código', ftInteger);
  CreateField('BOMBA', 'Bomba',  ftInteger);
  CreateField('TANQUE', 'Tanque', ftInteger);
  CreateField('LITROS', 'Litros Abastecidos', ftCurrency);
  CreateField('VALOR_LITRO', 'Valor por Litro', ftCurrency);
  CreateField('VALOR_TOTAL', 'Total Abastecimento', ftCurrency);
  CreateField('ALIQUOTA', 'Alíquota', ftCurrency);
  CreateField('VALOR_ALIQUOTA', 'Valor Alíquota', ftCurrency);
  CreateField('DATA_ABASTECIMENTO', 'Data Abastecimento', ftDateTime);
end;

procedure TFormReport.Button1Click(Sender: TObject);
begin
  GerarRelatorio;
end;

procedure TFormReport.CreateField(_AName, _ADisplayName: String; _ADataType: TFieldType);
begin
  with FDTable.FieldDefs.AddFieldDef do
  begin
    Name := _AName;
    DataType := _ADataType;
    DisplayName := _ADisplayName;
  end;
end;

function TFormReport.TratarRetornoReport(_AJSON: String): TAbastecimentoRelatorioList;
var
  i: Integer;
  AJSONArray: TJSONArray;
  AJSONString: String;
  AJSONObject: TJSONObject;
  AJSONValue: TJSONValue;
  AAbastecimentoRelatorio: TAbastecimentoRelatorio;
begin
  Result := TAbastecimentoRelatorioList.Create;
  if _AJSON = '{"result":[null]}' then
    Exit;

  AJSONString := RemoverStringsMarshal(_AJSON);
  AJSONValue := TJSonObject.ParseJSONValue(AJSONString);
  AJSONArray := AJSONValue as TJSONArray;
  try
    for i := 0 to AJSONArray.Count - 1 do
    begin
      AJSONObject := (AJSONArray.Items[i]) as TJSONObject;
      AAbastecimentoRelatorio := GetValuesAbastecimentoReport(AJSONObject);
      Result.Add(AAbastecimentoRelatorio);
    end;
  finally
    AJSONArray.Free;
  end;
end;

procedure TFormReport.GerarRelatorio;
var
  AMetodosREST: TMetodosREST;
  AAbastecimentoRelatorioList: TAbastecimentoRelatorioList;
  AAbastecimentoRelatorio: TAbastecimentoRelatorio;
  AJSONFiltros: TJSONObject;
  AJSONRetorno, AUrl: String;
begin
  AJSONFiltros := GetJSONFiltros;
  try
    AUrl := 'http://localhost:8081/datasnap/rest/TSMServidor/GerarRelatorio';
    AMetodosREST := TMetodosREST.Create(AUrl);
    try
      AJSONRetorno := AMetodosREST.Post(AJSONFiltros);
      AAbastecimentoRelatorioList := TratarRetornoReport(AJSONRetorno);
      try
        if AAbastecimentoRelatorioList.Count = 0 then
        begin
          MessageDlg('Não há dados', mtInformation, [], 0);
          Exit;
        end;

        for AAbastecimentoRelatorio in AAbastecimentoRelatorioList do
        begin
          FDTable.Append;
          FDTable.FieldByName('CODIGO').AsInteger := AAbastecimentoRelatorio.Codigo;
          FDTable.FieldByName('BOMBA').AsInteger := AAbastecimentoRelatorio.Bomba;
          FDTable.FieldByName('TANQUE').AsInteger := AAbastecimentoRelatorio.Tanque;
          FDTable.FieldByName('LITROS').AsCurrency := AAbastecimentoRelatorio.Litros;
          FDTable.FieldByName('VALOR_LITRO').AsCurrency := AAbastecimentoRelatorio.ValorLitro;
          FDTable.FieldByName('VALOR_TOTAL').AsCurrency := AAbastecimentoRelatorio.ValorTotal;
          FDTable.FieldByName('ALIQUOTA').AsCurrency := AAbastecimentoRelatorio.Aliquota;
          FDTable.FieldByName('VALOR_ALIQUOTA').AsCurrency := AAbastecimentoRelatorio.ValorAliquota;
          FDTable.FieldByName('DATA_ABASTECIMENTO').AsDateTime := AAbastecimentoRelatorio.DataAbastecimento;
          FDTable.Post;
        end;
      finally
        AAbastecimentoRelatorioList.Free;
      end;
    finally
      AMetodosREST.Free;
    end;
  finally
    AJSONFiltros.Free;
  end;
end;

function TFormReport.GetJSONFiltros: TJSONObject;
var
  AFormReportFiltros: TFormReportFiltros;
begin
  AFormReportFiltros := TFormReportFiltros.Create(nil);
  try
    AFormReportFiltros.ShowModal;
    if AFormReportFiltros.ModalResult <> mrOk then
    begin
      Result := nil;
      Abort;
    end;

    Result := AFormReportFiltros.GetJSON;
  finally
    AFormReportFiltros.Free
  end;
end;

function TFormReport.GetValuesAbastecimentoReport(_AJSON: TJSONObject): TAbastecimentoRelatorio;
var
  i: Integer;
  AField, AVal: String;
begin
  Result := TAbastecimentoRelatorio.Create;
  for i := 0 to _AJSON.Count - 1 do
  begin
    AField := LowerCase(_AJSON.Pairs[i].JsonString.Value);
    AVal := _AJSON.Pairs[i].JsonValue.ToString;
    case AnsiIndexStr(AField , ['codigo', 'bomba', 'tanque', 'litros',
                                'valorlitro', 'valortotal', 'aliquota',
                                'valoraliquota', 'dataabastecimento'])
    of
      0: Result.Codigo := StrToIntDef(AVal, 0);
      1: Result.Bomba := StrToIntDef(AVal, 0);
      2: Result.Tanque := StrToIntDef(AVal, 0);
      3: Result.Litros := StrToCurrDef(AVal.Replace('.',','),0);
      4: Result.ValorLitro := StrToCurrDef(AVal.Replace('.',','),0);
      5: Result.ValorTotal := StrToCurrDef(AVal.Replace('.',','),0);
      6: Result.Aliquota := StrToCurrDef(AVal.Replace('.',','),0);
      7: Result.ValorAliquota := StrToCurrDef(AVal.Replace('.',','),0);
      8: Result.DataAbastecimento := JSONDateToDatetime(AVal);
    end;
  end;
end;

end.
