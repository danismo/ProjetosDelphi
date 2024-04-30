unit ufSMServidor;

interface

uses
  System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth,
  System.JSON, uClassPosto;

type
{$METHODINFO ON}
  TSMServidor = class(TComponent)
  private
    { Private declarations }
  public
    function UpdateAbastecer(_AJSON: TJSONValue): TJSONValue;
  end;
{$METHODINFO OFF}

implementation

uses
  System.StrUtils;

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
