unit uClassPosto;

interface

uses
  ufDMServidor, System.JSON;

type
  TBaseClass = class
  private
    FDMServidor: TDMServidor;
    constructor Create; overload;
    destructor Destroy;
  public
    function GetDMServidor: TDMServidor;
    procedure ProcessarJSONtoObject(_AJSON: TJSONValue);
  end;

  TAbastecimento = class(TBaseClass)
  private
    FCodigo: Integer;
    FBomba: Integer;
    FLitros: Currency;
    FValorLitro: Currency;
    FValorTotal: Currency;
    FAliquota: Currency;
    FDataAbastecimento: TDateTime;
    procedure CalcularTotal;
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property Bomba: Integer read FBomba write FBomba;
    property Litros: Currency read FLitros write FLitros;
    property ValorLitro: Currency read FValorLitro write FValorLitro;
    property ValorTotal: Currency read FValorTotal write FValorTotal;
    property Aliquota: Currency read FAliquota write FAliquota;
    property DataAbastecimento: TDateTime read FDataAbastecimento write FDataAbastecimento;

    function ProcessarAbastecimento: Integer;
  end;

  TAbastecimentoRetorno = class
  private
    FCodigo: Integer;
  public
    property Codigo: Integer read FCodigo write FCodigo;
  end;

implementation

uses
  System.SysUtils;

{ TAbastecimento }

procedure TAbastecimento.CalcularTotal;
begin
  ValorTotal := (ValorLitro * Litros);
  ValorTotal := ValorTotal + (ValorTotal * (Aliquota/100));
end;

function TAbastecimento.ProcessarAbastecimento: Integer;
begin

end;

{ TBaseClass }

constructor TBaseClass.Create;
begin
  FDMServidor := TDMServidor.Create(nil);
end;

destructor TBaseClass.Destroy;
begin
  FreeAndNil(FDMServidor);
end;

function TBaseClass.GetDMServidor: TDMServidor;
begin
  Result := FDMServidor;
end;

end.

connect 'C:\Dev\Delphi\Projetos\ProjetosDelphi\DB\dados.fdb' user 'SYSDBA' password '12345';

create table ABASTECIMENTO(
  CODIGO integer not null primary key,
  BOMBA integer not null,
  LITROS numeric(9,4) not null,
  VALOR_LITRO numeric(9,4) not null,
  VALOR_TOTAL numeric(12,4) not null,
  ALIQUOTA numeric(2,2) default 0
);
