//
// Created by the DataSnap proxy generator.
// 26/04/2024 00:47:14
//

unit ufServerClass;

interface

uses System.JSON, Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap, Data.DBXJSON, Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB, Data.SqlExpr, Data.DBXDBReaders, Data.DBXCDSReaders, Data.DBXJSONReflect;

type
  TSMServidorClient = class(TDSAdminClient)
  private
    FEchoStringCommand: TDBXCommand;
    FReverseStringCommand: TDBXCommand;
    FTesteCommand: TDBXCommand;
    FUpdateAbastecerCommand: TDBXCommand;
  public
    constructor Create(ADBXConnection: TDBXConnection); overload;
    constructor Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
    function Teste: TJSONValue;
    function UpdateAbastecer(_AJSON: TJSONValue): TJSONValue;
  end;

implementation

function TSMServidorClient.EchoString(Value: string): string;
begin
  if FEchoStringCommand = nil then
  begin
    FEchoStringCommand := FDBXConnection.CreateCommand;
    FEchoStringCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FEchoStringCommand.Text := 'TSMServidor.EchoString';
    FEchoStringCommand.Prepare;
  end;
  FEchoStringCommand.Parameters[0].Value.SetWideString(Value);
  FEchoStringCommand.ExecuteUpdate;
  Result := FEchoStringCommand.Parameters[1].Value.GetWideString;
end;

function TSMServidorClient.ReverseString(Value: string): string;
begin
  if FReverseStringCommand = nil then
  begin
    FReverseStringCommand := FDBXConnection.CreateCommand;
    FReverseStringCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FReverseStringCommand.Text := 'TSMServidor.ReverseString';
    FReverseStringCommand.Prepare;
  end;
  FReverseStringCommand.Parameters[0].Value.SetWideString(Value);
  FReverseStringCommand.ExecuteUpdate;
  Result := FReverseStringCommand.Parameters[1].Value.GetWideString;
end;

function TSMServidorClient.Teste: TJSONValue;
begin
  if FTesteCommand = nil then
  begin
    FTesteCommand := FDBXConnection.CreateCommand;
    FTesteCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FTesteCommand.Text := 'TSMServidor.Teste';
    FTesteCommand.Prepare;
  end;
  FTesteCommand.ExecuteUpdate;
  Result := TJSONValue(FTesteCommand.Parameters[0].Value.GetJSONValue(FInstanceOwner));
end;

function TSMServidorClient.UpdateAbastecer(_AJSON: TJSONValue): TJSONValue;
begin
  if FUpdateAbastecerCommand = nil then
  begin
    FUpdateAbastecerCommand := FDBXConnection.CreateCommand;
    FUpdateAbastecerCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FUpdateAbastecerCommand.Text := 'TSMServidor.UpdateAbastecer';
    FUpdateAbastecerCommand.Prepare;
  end;
  FUpdateAbastecerCommand.Parameters[0].Value.SetJSONValue(_AJSON, FInstanceOwner);
  FUpdateAbastecerCommand.ExecuteUpdate;
  Result := TJSONValue(FUpdateAbastecerCommand.Parameters[1].Value.GetJSONValue(FInstanceOwner));
end;


constructor TSMServidorClient.Create(ADBXConnection: TDBXConnection);
begin
  inherited Create(ADBXConnection);
end;


constructor TSMServidorClient.Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ADBXConnection, AInstanceOwner);
end;


destructor TSMServidorClient.Destroy;
begin
  FEchoStringCommand.DisposeOf;
  FReverseStringCommand.DisposeOf;
  FTesteCommand.DisposeOf;
  FUpdateAbastecerCommand.DisposeOf;
  inherited;
end;

end.

