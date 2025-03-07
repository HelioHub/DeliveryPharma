unit Model.Entregador;

interface

uses
  Interfaces.IEntregador, FireDAC.Comp.Client, Data.DB, Utils.DatabaseConnection;

type
  TEntregador = class(TInterfacedObject, IEntregador)
  private
    FIdEntregador: Integer;
    FNomeEntregador: string;
    FSituacaoEntregador: SmallInt;

    FQuery: TFDQuery;
    FDatabaseConnection: TDatabaseConnection;

    procedure SetIdEntregador(const Value: Integer);
    function GetIdEntregador: Integer;

    procedure SetNomeEntregador(const Value: string);
    function GetNomeEntregador: string;

    procedure SetSituacaoEntregador(const Value: SmallInt);
    function GetSituacaoEntregador: SmallInt;

  public
    constructor Create;
    destructor Destroy; override;

    property IdEntregador: Integer read GetIdEntregador write SetIdEntregador;
    property NomeEntregador: string read GetNomeEntregador write SetNomeEntregador;
    property SituacaoEntregador: SmallInt read GetSituacaoEntregador write SetSituacaoEntregador;

    function Salvar: Boolean; // Implementação do método Salvar
    function Excluir(const AId: Integer): Boolean; // Implementação do método Excluir

    procedure CarregarDados(const AFDMemTable: TFDMemTable; pEntregador, pStatus: String); // Implementação do método CarregarDados
end;

implementation

uses
  FireDAC.DApt, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, System.SysUtils, System.Classes, Vcl.Dialogs, Utils.ErrorLogger;

{ TEntregador }

constructor TEntregador.Create;
begin
  // Usa a conexão centralizada com parâmetros do arquivo .INI
  FDatabaseConnection := TDatabaseConnection.Create;
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FDatabaseConnection.Connection;
end;

destructor TEntregador.Destroy;
begin
  FQuery.Free;
  FDatabaseConnection.Free;
  inherited;
end;

// Métodos Set e Get
procedure TEntregador.SetIdEntregador(const Value: Integer);
begin
  if Value < 0 then
    raise Exception.Create('ID do entregador não pode ser negativo.');
  FIdEntregador := Value;
end;

function TEntregador.GetIdEntregador: Integer;
begin
  Result := FIdEntregador;
end;

procedure TEntregador.SetNomeEntregador(const Value: string);
begin
  if Length(Value) > 50 then
    raise Exception.Create('Nome do entregador não pode ter mais de 50 caracteres.');
  FNomeEntregador := Value;
end;

function TEntregador.GetNomeEntregador: string;
begin
  Result := FNomeEntregador;
end;

procedure TEntregador.SetSituacaoEntregador(const Value: SmallInt);
begin
  if not (Value in [0, 1]) then
    raise Exception.Create('Situação inválida! Valores permitidos: 0, 1.');
  FSituacaoEntregador := Value;
end;

function TEntregador.GetSituacaoEntregador: SmallInt;
begin
  Result := FSituacaoEntregador;
end;

function TEntregador.Salvar: Boolean;
var
  Logger: TErrorLogger;
begin
  Result := False;
  Logger := TErrorLogger.Create; // Usa o caminho padrão 'error.log'
  try

  FDatabaseConnection.Connection.StartTransaction;
  try
    // Prepara a query para inserir ou atualizar o item de pedido
    FQuery.SQL.Clear;
    if FIdEntregador = 0 then
    begin
      // Inserir novo item de pedido
      FQuery.SQL.Add('INSERT INTO Entregador ' +
                     '(idEntregador, NomeEntregador, SituacaoEntregador) ' +
                     'VALUES ' +
                     '(GEN_ID(GEN_Entregador_ID, 1), :Nome, :Situacao)');
    end
    else
    begin
      FQuery.SQL.Add('UPDATE Entregador SET ' +
                     'NomeEntregador = :Nome, ' +
                     'SituacaoEntregador = :Situacao ' +
                     'WHERE idEntregador = :Id');
      FQuery.ParamByName('Id').Value := FIdEntregador;
    end;

    // Define os parâmetros da query
    FQuery.ParamByName('Nome').Value := FNomeEntregador;
    FQuery.ParamByName('Situacao').Value := FSituacaoEntregador;

    // Executa a query
    FQuery.ExecSQL;

    // Se for uma inserção, recupera o ID gerado
    if FIdEntregador = 0 then
    begin
      FQuery.SQL.Clear;
      FQuery.SQL.Add('SELECT GEN_ID(GEN_Entregador_ID, 0) AS LastID FROM RDB$DATABASE ');
      FQuery.Open;
      FIdEntregador := FQuery.FieldByName('LastID').AsInteger;
    end;

    FDatabaseConnection.Connection.Commit;
    Result := True;
  except
    on E: Exception do
    begin
      FDatabaseConnection.Connection.Rollback;
      Logger.LogError(E);
      raise Exception.Create('Erro ao salvar Entregador: ' + E.Message);
    end;
  end;

  finally
    Logger.Free;
  end;
end;

procedure TEntregador.CarregarDados(const AFDMemTable: TFDMemTable; pEntregador, pStatus: String);
begin
  try
    // Prepara a query para selecionar os dados
    FQuery.SQL.Clear;
    FQuery.SQL.Add(' SELECT a.idEntregador, ');
    FQuery.SQL.Add('        a.NomeEntregador, ');
    FQuery.SQL.Add(' CASE                  ');
    FQuery.SQL.Add('   WHEN a.SituacaoEntregador = 0 THEN '+QuotedStr('Disponível'));
    FQuery.SQL.Add('   WHEN a.SituacaoEntregador = 1 THEN '+QuotedStr('Não Disponível'));
    FQuery.SQL.Add('   ELSE '+QuotedStr('Desconhecido'));
    FQuery.SQL.Add(' END AS Status ');
    FQuery.SQL.Add(' FROM Entregador a ');
    if not pEntregador.IsEmpty then
      FQuery.SQL.Add(' WHERE a.idEntregador = '+pEntregador);
    if not pStatus.IsEmpty then
      FQuery.SQL.Add(' WHERE a.SituacaoEntregador = '+pStatus);
    FQuery.SQL.Add(' ORDER BY a.NomeEntregador ');
    FQuery.Open;

    // Copia os dados para o TFDMemTable
    begin
      AFDMemTable.Close;
      AFDMemTable.Data := FQuery.Data;
      AFDMemTable.Open;
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao carregar dados: ' + E.Message);
    end;
  end;
end;

function TEntregador.Excluir(const AId: Integer): Boolean;
begin
  Result := False;
  try
    FQuery.SQL.Clear;
    FQuery.SQL.Add('DELETE FROM Entregador WHERE idEntregador = :Id ');
    FQuery.ParamByName('Id').AsInteger := AId;

    FQuery.ExecSQL;

    Result := True;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao excluir Entregador: ' + E.Message);
    end;
  end;
end;

end.
