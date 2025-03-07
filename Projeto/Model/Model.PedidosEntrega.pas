unit Model.PedidosEntrega;

interface

uses
  Interfaces.IPedidosEntrega, FireDAC.Comp.Client, Data.DB, Utils.DatabaseConnection;

type
  TPedidosEntrega = class(TInterfacedObject, IPedidosEntrega)
  private
    FIdPedidosEntrega: Integer;
    FPedidoPedidosEntrega: Integer;
    FOrdemEntregaPedidosEntrega: Integer;
    FStatusPedidosEntrega: SmallInt;
    FOBSPedidosEntrega: string;

    FQuery: TFDQuery;
    FDatabaseConnection: TDatabaseConnection;

    procedure SetIdPedidosEntrega(const Value: Integer);
    function GetIdPedidosEntrega: Integer;

    procedure SetPedidoPedidosEntrega(const Value: Integer);
    function GetPedidoPedidosEntrega: Integer;

    procedure SetOrdemEntregaPedidosEntrega(const Value: Integer);
    function GetOrdemEntregaPedidosEntrega: Integer;

    procedure SetStatusPedidosEntrega(const Value: SmallInt);
    function GetStatusPedidosEntrega: SmallInt;

    procedure SetOBSPedidosEntrega(const Value: string);
    function GetOBSPedidosEntrega: string;
  public
    constructor Create;
    destructor Destroy; override;

    property IdPedidosEntrega: Integer read GetIdPedidosEntrega write SetIdPedidosEntrega;
    property PedidoPedidosEntrega: Integer read GetPedidoPedidosEntrega write SetPedidoPedidosEntrega;
    property OrdemEntregaPedidosEntrega: Integer read GetOrdemEntregaPedidosEntrega write SetOrdemEntregaPedidosEntrega;
    property StatusPedidosEntrega: SmallInt read GetStatusPedidosEntrega write SetStatusPedidosEntrega;
    property OBSPedidosEntrega: string read GetOBSPedidosEntrega write SetOBSPedidosEntrega;

    function Salvar: Boolean; // Implementa��o do m�todo Salvar
    function Excluir(const AId: Integer): Boolean; // Implementa��o do m�todo Excluir

    procedure CarregarDados(const AFDMemTable: TFDMemTable; pOrdemEntrega: String); // Implementa��o do m�todo CarregarDados
    procedure CarregarDadosRotas(const AFDMemTable: TFDMemTable; pPedido: String);
    procedure CarregarDadosPedidosOrdem(const AFDMemTable: TFDMemTable;
      pidOrdem: String);
    function PedidoEmOrdem(const pPedido: String) : Integer;
end;

implementation

uses
  FireDAC.DApt, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, System.SysUtils, System.Classes, Vcl.Dialogs, Utils.ErrorLogger;

{ TPedidosEntrega }


procedure TPedidosEntrega.CarregarDadosPedidosOrdem(const AFDMemTable: TFDMemTable;
  pidOrdem: String);
begin
  try
    // Prepara a query para selecionar os dados
    FQuery.SQL.Clear;
    FQuery.SQL.Add('  SELECT c.idPedidosEntrega, '+
    '      c.PedidoPedidosEntrega, '+
    '      c.OrdemEntregaPedidosEntrega, '+
    '      c.OBSPedidosEntrega, '+
    '      a.NumeroPedidos, '+
    '      b.CodigoClientes, '+
    '      b.NomeClientes, '+
    '      b.RuaClientes, '+
    '      b.CEPClientes, '+
    '      b.NumeroRuaClientes, '+
    '      b.BairroClientes, '+
    '      a.DataEmissaoPedidos, '+
    '      a.ValorTotalPedidos, '+
    '      CASE                  '+
    '        WHEN a.StatusPedidos = 0 THEN '+QuotedStr('Em Aberto')+
    '        WHEN a.StatusPedidos = 1 THEN '+QuotedStr('Fechado')+
    '        ELSE '+QuotedStr('Desconhecido')+
    '      END AS Status, '+
    '      COALESCE( '+
    '          (SELECT MIN(tp.PrioridadeTipoProduto) '+
    '          FROM ItensPedido ip '+
    '          JOIN Produtos p ON p.idProdutos = ip.ProdutoItensPedido '+
    '          JOIN TipoProduto tp ON tp.idTipoProduto = p.TipoProdutoProdutos '+
    '          WHERE ip.PedidoItensPedido = a.NumeroPedidos '+
    '      ), 9) AS Prioridade, '+ //Retorna a maior prioridade (1 � a maior, 9 � a menor)
    '      CASE '+
    '          WHEN EXISTS ( '+
    '              SELECT 1 '+
    '              FROM ItensPedido ip '+
    '              JOIN Produtos p ON p.idProdutos = ip.ProdutoItensPedido '+
    '              WHERE ip.PedidoItensPedido = a.NumeroPedidos '+
    '                AND p.CuidadosArmProdutos IS NOT NULL '+
    '                AND p.CuidadosArmProdutos <> '+QuotedStr('')+
    '          ) THEN '+QuotedStr('SIM')+' '+
    '          ELSE '+QuotedStr('N�O')+' '+
    '      END AS Cuidados, '+ //Verifica se h� produtos com cuidados especiais
    '      CASE '+
    '          WHEN EXISTS ( '+
    '              SELECT 1 '+
    '              FROM ItensPedido ip '+
    '              JOIN Produtos p ON p.idProdutos = ip.ProdutoItensPedido '+
    '              WHERE ip.PedidoItensPedido = a.NumeroPedidos '+
    '                AND p.DataValidadeProdutos < CURRENT_DATE '+
    '          ) THEN '+QuotedStr('SIM')+' '+
    '          ELSE '+QuotedStr('N�O')+' '+
    '      END AS ValidadeVencida '+ //Verifica se h� produtos com validade vencida
    '  FROM Pedidos a '+
    '  JOIN Clientes b ON b.CodigoClientes = a.ClientePedidos '+
    '  JOIN PedidosEntrega c ON c.PedidoPedidosEntrega = a.NumeroPedidos '+
    '  WHERE 0 = 0 ');
    if not pidOrdem.IsEmpty then
      FQuery.SQL.Add(' AND c.OrdemEntregaPedidosEntrega = '+pidOrdem);
    FQuery.SQL.Add(' ORDER BY Prioridade, a.DataEmissaoPedidos ');
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


procedure TPedidosEntrega.CarregarDadosRotas(const AFDMemTable: TFDMemTable;
  pPedido: String);
begin
  try
    // Prepara a query para selecionar os dados
    FQuery.SQL.Clear;
    FQuery.SQL.Add('  SELECT '+
    '      a.NumeroPedidos, '+
    '      b.NomeClientes, '+
    '      a.DataEmissaoPedidos, '+
    '      a.ValorTotalPedidos, '+
    '      '+QuotedStr('Em Aberto')+' AS Status, '+
    '      COALESCE( '+
    '          (SELECT MIN(tp.PrioridadeTipoProduto) '+
    '          FROM ItensPedido ip '+
    '          JOIN Produtos p ON p.idProdutos = ip.ProdutoItensPedido '+
    '          JOIN TipoProduto tp ON tp.idTipoProduto = p.TipoProdutoProdutos '+
    '          WHERE ip.PedidoItensPedido = a.NumeroPedidos '+
    '      ), 9) AS MaiorPrioridade, '+ //Retorna a maior prioridade (1 � a maior, 9 � a menor)
    '      CASE '+
    '          WHEN EXISTS ( '+
    '              SELECT 1 '+
    '              FROM ItensPedido ip '+
    '              JOIN Produtos p ON p.idProdutos = ip.ProdutoItensPedido '+
    '              WHERE ip.PedidoItensPedido = a.NumeroPedidos '+
    '                AND p.CuidadosArmProdutos IS NOT NULL '+
    '                AND p.CuidadosArmProdutos <> '+QuotedStr('')+
    '          ) THEN '+QuotedStr('SIM')+' '+
    '          ELSE '+QuotedStr('N�O')+' '+
    '      END AS Cuidados, '+ //Verifica se h� produtos com cuidados especiais
    '      CASE '+
    '          WHEN EXISTS ( '+
    '              SELECT 1 '+
    '              FROM ItensPedido ip '+
    '              JOIN Produtos p ON p.idProdutos = ip.ProdutoItensPedido '+
    '              WHERE ip.PedidoItensPedido = a.NumeroPedidos '+
    '                AND p.DataValidadeProdutos < CURRENT_DATE '+
    '          ) THEN '+QuotedStr('SIM')+' '+
    '          ELSE '+QuotedStr('N�O')+' '+
    '      END AS ValidadeVencida '+ //Verifica se h� produtos com validade vencida
    '  FROM Pedidos a '+
    '  JOIN Clientes b ON b.CodigoClientes = a.ClientePedidos '+
    '  WHERE a.StatusPedidos = 0 '); //Filtra apenas pedidos em aberto
    if not pPedido.IsEmpty then
      FQuery.SQL.Add(' AND a.NumeroPedidos = '+pPedido);
    FQuery.SQL.Add(' ORDER BY MaiorPrioridade, a.DataEmissaoPedidos ');
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


constructor TPedidosEntrega.Create;
begin
  // Usa a conex�o centralizada com par�metros do arquivo .INI
  FDatabaseConnection := TDatabaseConnection.Create;
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FDatabaseConnection.Connection;
end;

destructor TPedidosEntrega.Destroy;
begin
  FQuery.Free;
  FDatabaseConnection.Free;
  inherited;
end;

// M�todos Set e Get
procedure TPedidosEntrega.SetIdPedidosEntrega(const Value: Integer);
begin
  if Value < 0 then
    raise Exception.Create('ID do pedido de entrega n�o pode ser negativo.');
  FIdPedidosEntrega := Value;
end;

function TPedidosEntrega.GetIdPedidosEntrega: Integer;
begin
  Result := FIdPedidosEntrega;
end;

procedure TPedidosEntrega.SetPedidoPedidosEntrega(const Value: Integer);
begin
  if Value < 0 then
    raise Exception.Create('Pedido n�o pode ser negativo.');
  FPedidoPedidosEntrega := Value;
end;

function TPedidosEntrega.GetPedidoPedidosEntrega: Integer;
begin
  Result := FPedidoPedidosEntrega;
end;

procedure TPedidosEntrega.SetOrdemEntregaPedidosEntrega(const Value: Integer);
begin
  if Value < 0 then
    raise Exception.Create('Ordem de entrega n�o pode ser negativa.');
  FOrdemEntregaPedidosEntrega := Value;
end;

function TPedidosEntrega.GetOrdemEntregaPedidosEntrega: Integer;
begin
  Result := FOrdemEntregaPedidosEntrega;
end;

procedure TPedidosEntrega.SetStatusPedidosEntrega(const Value: SmallInt);
begin
  if not (Value in [0, 1, 2, 3]) then
    raise Exception.Create('Status inv�lido! Valores permitidos: 0, 1, 2, 3.');
  FStatusPedidosEntrega := Value;
end;

function TPedidosEntrega.GetStatusPedidosEntrega: SmallInt;
begin
  Result := FStatusPedidosEntrega;
end;

function TPedidosEntrega.PedidoEmOrdem(const pPedido: String) : Integer;
begin
  try
    // Prepara a query para selecionar os dados
    FQuery.SQL.Clear;
    FQuery.SQL.Add(' SELECT OrdemEntregaPedidosEntrega FROM PedidosEntrega WHERE  PedidoPedidosEntrega = '+pPedido);
    FQuery.Open;

    Result := FQuery.FieldByName('OrdemEntregaPedidosEntrega').AsInteger;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao carregar dados: ' + E.Message);
    end;
  end;
end;

procedure TPedidosEntrega.SetOBSPedidosEntrega(const Value: string);
begin
  if Length(Value) > 1000 then
    raise Exception.Create('Observa��o n�o pode ter mais de 1000 caracteres.');
  FOBSPedidosEntrega := Value;
end;

function TPedidosEntrega.GetOBSPedidosEntrega: string;
begin
  Result := FOBSPedidosEntrega;
end;


function TPedidosEntrega.Salvar: Boolean;
var
  Logger: TErrorLogger;
begin
  Result := False;
  Logger := TErrorLogger.Create; // Usa o caminho padr�o 'error.log'
  try

  FDatabaseConnection.Connection.StartTransaction;
  try
    FQuery.SQL.Clear;
    if FIdPedidosEntrega = 0 then
    begin
      FQuery.SQL.Add('INSERT INTO PedidosEntrega ' +
                     '(idPedidosEntrega, PedidoPedidosEntrega, OrdemEntregaPedidosEntrega, StatusPedidosEntrega, OBSPedidosEntrega) ' +
                     'VALUES ' +
                     '(GEN_ID(GEN_PedidosEntrega_ID, 1), :Pedido, :OrdemEntrega, :Status, :OBS)');
    end
    else
    begin
      FQuery.SQL.Add('UPDATE PedidosEntrega SET ' +
                     'PedidoPedidosEntrega = :Pedido, ' +
                     'OrdemEntregaPedidosEntrega = :OrdemEntrega, ' +
                     'StatusPedidosEntrega = :Status, ' +
                     'OBSPedidosEntrega = :OBS ' +
                     'WHERE idPedidosEntrega = :Id');
      FQuery.ParamByName('idPedidosEntrega').AsInteger := FIdPedidosEntrega;
    end;

    // Define os par�metros da query
    FQuery.ParamByName('Pedido').Value := FPedidoPedidosEntrega;
    FQuery.ParamByName('OrdemEntrega').Value := FOrdemEntregaPedidosEntrega;
    FQuery.ParamByName('Status').Value := FStatusPedidosEntrega;
    FQuery.ParamByName('OBS').Value := FOBSPedidosEntrega;

    // Executa a query
    FQuery.ExecSQL;

    // Se for uma inser��o, recupera o ID gerado
    if FIdPedidosEntrega = 0 then
    begin
      FQuery.SQL.Clear;
      FQuery.SQL.Add('SELECT GEN_ID(GEN_PedidosEntrega_ID, 0) AS LastID FROM RDB$DATABASE ');
      FQuery.Open;
      FIdPedidosEntrega := FQuery.FieldByName('LastID').AsInteger;
    end;

    FDatabaseConnection.Connection.Commit;
    Result := True;
  except
    on E: Exception do
    begin
      FDatabaseConnection.Connection.Rollback;
      Logger.LogError(E);
      raise Exception.Create('Erro ao salvar item de pedido: ' + E.Message);
    end;
  end;

  finally
    Logger.Free;
  end;
end;

procedure TPedidosEntrega.CarregarDados(const AFDMemTable: TFDMemTable; pOrdemEntrega: String);
begin
  try
    // Prepara a query para selecionar os dados
    FQuery.SQL.Clear;
    FQuery.SQL.Add(' SELECT a.idPedidosEntrega, a.OrdemEntregaPedidosEntrega, a.PedidoPedidosEntrega,');
    FQuery.SQL.Add('        c.CodigoClientes, c.NomeClientes, c.BairroClientes ');
    FQuery.SQL.Add('        b.ValorTotalPedidos  ');
    FQuery.SQL.Add('        a.OBSPedidosEntrega ');
    FQuery.SQL.Add(' CASE                  ');
    FQuery.SQL.Add('   WHEN a.StatusOrdemEntrega = 0 THEN '+QuotedStr('Pendente'));
    FQuery.SQL.Add('   WHEN a.StatusOrdemEntrega = 1 THEN '+QuotedStr('Em Andamento'));
    FQuery.SQL.Add('   WHEN a.StatusOrdemEntrega = 2 THEN '+QuotedStr('Entregue Total'));
    FQuery.SQL.Add('   WHEN a.StatusOrdemEntrega = 3 THEN '+QuotedStr('Entregue Total'));
    FQuery.SQL.Add('   ELSE '+QuotedStr('Desconhecido'));
    FQuery.SQL.Add(' END AS Status ');
    FQuery.SQL.Add(' FROM PedidosEntrega a ');
    FQuery.SQL.Add(' JOIN Pedidos b ON b.NumeroPedidos = a.PedidoPedidosEntrega ');
    FQuery.SQL.Add(' JOIN Clientes c ON c.CodigoClientes = b.ClientePedidos ');
    if not pOrdementrega.IsEmpty then
      FQuery.SQL.Add(' WHERE a.idPedidosEntrega = '+pOrdemEntrega);
    FQuery.SQL.Add(' ORDER BY a.idPedidosEntrega ');
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

function TPedidosEntrega.Excluir(const AId: Integer): Boolean;
begin
  Result := False;
  try
    FQuery.SQL.Clear;
    FQuery.SQL.Add('DELETE FROM PedidosEntrega WHERE idPedidosEntrega = :Id ');
    FQuery.ParamByName('Id').AsInteger := AId;

    FQuery.ExecSQL;

    Result := True;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao excluir Pedido da Entrega: ' + E.Message);
    end;
  end;
end;

end.
