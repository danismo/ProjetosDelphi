unit ufSMServidor;

interface

uses
  System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth,
  System.JSON, uClassPosto, uClassReport;

type
{$METHODINFO ON}
  TSMServidor = class(TComponent)
  private
    { Private declarations }
  public
    function UpdateAbastecer(_AJSON: TJSONValue): TJSONValue;
    function UpdateGerarRelatorio(_AJSON: TJSONValue): TJSONObject;
  end;
{$METHODINFO OFF}

implementation

uses
  System.StrUtils;

function TSMServidor.UpdateGerarRelatorio(_AJSON: TJSONValue): TJSONObject;
var
  AReportPosto: TReportPosto;
begin
  AReportPosto := TReportPosto.Create;
  try
    Result := AReportPosto.GerarRelatorio(_AJSON) as TJSONObject;
  finally
    AReportPosto.Free;
  end;
end;

function TSMServidor.UpdateAbastecer(_AJSON: TJSONValue): TJSONValue;
var
  AAbastecimento: TAbastecimento;
begin
  AAbastecimento := TAbastecimento.Create;
  try
    AAbastecimento.ProcessarJSONtoObject(_AJSON);
    Result := TJSONString.Create(AAbastecimento.ProcessarAbastecimento.ToString);
  finally
    AAbastecimento.Free;
  end;
end;

end.
