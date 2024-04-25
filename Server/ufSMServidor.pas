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
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
    function Teste: TJSONValue;
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
    AAbastecimento := (_AJSON as TJSONObject).GetValue('jahre').ToString

    Result := TJSONString.Create(_AJSON.ToString);
  finally
    AAbastecimento.Free;
  end;
end;

function TSMServidor.EchoString(Value: string): string;
begin
  Result := Value;
end;

function TSMServidor.ReverseString(Value: string): string;
begin
  Result := System.StrUtils.ReverseString(Value);
end;

function TSMServidor.Teste: TJSONValue;
begin
  Result := TJSONString.Create(DateTimeToStr(Now));
end;

end.
