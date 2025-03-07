unit Model.OrdemEntrega;

interface

uses
  Interfaces.IOrdemEntrega, FireDAC.Comp.Client, Data.DB, Utils.DatabaseConnection;

type
  TOrdemEntrega = class(TInterfacedObject, IOrdemEntrega)
  private
    FIdOrdemEntrega: Integer;
    FEntregadorOrdenEntrega: Integer;
    FEmissaoOrdemEntrega: TDateTime;
    FSaidaOrdemEntrega: TDateTime;
    FChegadaOrdemEntrega: TDateTime;
    FStatusOrdemEntrega: SmallInt;
    FOBSOrdemEntrega: string;

    FQuery: TFDQuery; // Query para interagir com o banco de dados
    FDatabaseConnection: TDatabaseConnection; // Conexão centralizada

    // Métodos Set e Get para cada campo
    procedure SetIdOrdemEntrega(const Value: Integer);
    function GetIdOrdemEntrega: Integer;

    procedure SetEntregadorOrdenEntrega(const Value: Integer);
    function GetEntregadorOrdenEntrega: Integer;

    procedure SetEmissaoOrdemEntrega(const Value: TDateTime);
    function GetEmissaoOrdemEntrega: TDateTime;

    procedure SetSaidaOrdemEntrega(const Value: TDateTime);
    function GetSaidaOrdemEntrega: TDateTime;

    procedure SetChegadaOrdemEntrega(const Value: TDateTime);
    function GetChegadaOrdemEntrega: TDateTime;

    procedure SetStatusOrdemEntrega(const Value: SmallInt);
    function GetStatusOrdemEntrega: SmallInt;

    procedure SetOBSOrdemEntrega(const Value: string);
    function GetOBSOrdemEntrega: string;

  public
    constructor Create;
    destructor Destroy; override;

    property IdOrdemEntrega: Integer read GetIdOrdemEntrega write SetIdOrdemEntrega;
    property EntregadorOrdenEntrega: Integer read GetEntregadorOrdenEntrega write SetEntregadorOrdenEntrega;
    property EmissaoOrdemEntrega: TDateTime read GetEmissaoOrdemEntrega write SetEmissaoOrdemEntrega;
    property SaidaOrdemEntrega: TDateTime read GetSaidaOrdemEntrega write SetSaidaOrdemEntrega;
    property ChegadaOrdemEntrega: TDateTime read GetChegadaOrdemEntrega write SetChegadaOrdemEntrega;
    property StatusOrdemEntrega: SmallInt read GetStatusOrdemEntrega write SetStatusOrdemEntrega;
    property OBSOrdemEntrega: string read GetOBSOrdemEntrega write SetOBSOrdemEntrega;

    function Salvar: Boolean; // Implementação do método Salvar
    function Excluir(const AId: Integer): Boolean; // Implementação do método Excluir
    function GerarOrdemEntregaHTML(const pOrdemEntrega: String): string;
    function SalvarOrdemEmProcesso(pOrdemEntrega, pProcesso: String): Boolean;

    procedure CarregarDados(const AFDMemTable: TFDMemTable;
      pidOrdemEntrega, pNomeEntregador, pLimite: String;
      pDtIni, pDtFin : TDate; pStatus : Integer); // Implementação do método CarregarDados
  end;

implementation

uses
  FireDAC.DApt, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, System.SysUtils, Vcl.Dialogs,
  Utils.ErrorLogger, Utils.Consts, System.Classes;

{ TOrdemEntrega }

constructor TOrdemEntrega.Create;
begin
  // Usa a conexão centralizada com parâmetros do arquivo .INI
  FDatabaseConnection := TDatabaseConnection.Create;
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FDatabaseConnection.Connection;
end;

destructor TOrdemEntrega.Destroy;
begin
  FQuery.Free;
  FDatabaseConnection.Free;
  inherited;
end;


// Métodos Set e Get para IdOrdemEntrega
procedure TOrdemEntrega.SetIdOrdemEntrega(const Value: Integer);
begin
  if Value < 0 then
    raise Exception.Create('ID da ordem de entrega não pode ser negativo.');
  FIdOrdemEntrega := Value;
end;

function TOrdemEntrega.GetIdOrdemEntrega: Integer;
begin
  Result := FIdOrdemEntrega;
end;

// Métodos Set e Get para EntregadorOrdenEntrega
procedure TOrdemEntrega.SetEntregadorOrdenEntrega(const Value: Integer);
begin
  if Value < 0 then
    raise Exception.Create('ID do entregador não pode ser negativo.');
  FEntregadorOrdenEntrega := Value;
end;

function TOrdemEntrega.GetEntregadorOrdenEntrega: Integer;
begin
  Result := FEntregadorOrdenEntrega;
end;

// Métodos Set e Get para EmissaoOrdemEntrega
procedure TOrdemEntrega.SetEmissaoOrdemEntrega(const Value: TDateTime);
begin
  if Value > Now then
    raise Exception.Create('Data de emissão não pode ser no futuro.');
  FEmissaoOrdemEntrega := Value;
end;

function TOrdemEntrega.GetEmissaoOrdemEntrega: TDateTime;
begin
  Result := FEmissaoOrdemEntrega;
end;

// Métodos Set e Get para SaidaOrdemEntrega
procedure TOrdemEntrega.SetSaidaOrdemEntrega(const Value: TDateTime);
begin
  if (Value < FEmissaoOrdemEntrega) then
    raise Exception.Create('Data de saída não pode ser anterior à data de emissão.');
  FSaidaOrdemEntrega := Value;
end;

function TOrdemEntrega.GetSaidaOrdemEntrega: TDateTime;
begin
  Result := FSaidaOrdemEntrega;
end;

// Métodos Set e Get para ChegadaOrdemEntrega
procedure TOrdemEntrega.SetChegadaOrdemEntrega(const Value: TDateTime);
begin
  if (Value < FSaidaOrdemEntrega) then
    raise Exception.Create('Data de chegada não pode ser anterior à data de saída.');
  FChegadaOrdemEntrega := Value;
end;

function TOrdemEntrega.GetChegadaOrdemEntrega: TDateTime;
begin
  Result := FChegadaOrdemEntrega;
end;

// Métodos Set e Get para StatusOrdemEntrega
procedure TOrdemEntrega.SetStatusOrdemEntrega(const Value: SmallInt);
begin
  if not (Value in [0, 1, 2, 3]) then
    raise Exception.Create('Status inválido! Valores permitidos: 0, 1, 2, 3.');
  FStatusOrdemEntrega := Value;
end;

function TOrdemEntrega.GetStatusOrdemEntrega: SmallInt;
begin
  Result := FStatusOrdemEntrega;
end;

// Métodos Set e Get para OBSOrdemEntrega
procedure TOrdemEntrega.SetOBSOrdemEntrega(const Value: string);
begin
  if Length(Value) > 1000 then
    raise Exception.Create('Observação não pode ter mais de 1000 caracteres.');
  FOBSOrdemEntrega := Value;
end;

function TOrdemEntrega.GetOBSOrdemEntrega: string;
begin
  Result := FOBSOrdemEntrega;
end;

function TOrdemEntrega.Salvar: Boolean;
var
  Logger: TErrorLogger;
begin
  Result := False;
  Logger := TErrorLogger.Create; // Usa o caminho padrão 'error.log'
  try

    FDatabaseConnection.Connection.StartTransaction;
    try
      // Prepara a query para inserir ou atualizar
      FQuery.SQL.Clear;
      if FIdOrdemEntrega = 0 then
      begin
        // Inserir novo
        FQuery.SQL.Add('INSERT INTO OrdemEntrega ' +
                       '(idOrdemEntrega, EntregadorOrdenEntrega, EmissaoOrdemEntrega, StatusOrdemEntrega, OBSOrdemEntrega) ' +
                       'VALUES ' +
                       '(GEN_ID(GEN_OrdemEntrega_ID, 1), :Entregador, :Emissao, :Status, :OBS)');
      end
      else
      begin
        // Atualizar
        FQuery.SQL.Add( 'UPDATE OrdemEntrega SET ' +
                        'EntregadorOrdenEntrega = :Entregador, ' +
                        'EmissaoOrdemEntrega = :Emissao, ' +
                        'StatusOrdemEntrega = :Status, ' +
                        'OBSOrdemEntrega = :OBS ' +
                        'WHERE idOrdemEntrega = :Id');

        FQuery.ParamByName('Id').AsInteger := FIdOrdemEntrega;
      end;

      // Define os parâmetros da query
      FQuery.ParamByName('Entregador').Value := FEntregadorOrdenEntrega;
      FQuery.ParamByName('Emissao').Value := FEmissaoOrdemEntrega;
      FQuery.ParamByName('Status').Value := FStatusOrdemEntrega;
      FQuery.ParamByName('OBS').Value := FOBSOrdemEntrega;

      // Executa a query
      FQuery.ExecSQL;

      // Se for uma inserção, recupera o ID gerado
      if FIdOrdemEntrega = 0 then
      begin
        FQuery.SQL.Clear;
        FQuery.SQL.Add('SELECT GEN_ID(GEN_OrdemEntrega_ID, 0) AS LastID FROM RDB$DATABASE ');
        FQuery.Open;
        FIdOrdemEntrega := FQuery.FieldByName('LastID').AsInteger;
      end;

      FDatabaseConnection.Connection.Commit;
      Result := True; // Indica que foi salvo com sucesso
    except
      on E: Exception do
      begin
        FDatabaseConnection.Connection.Rollback;
        Logger.LogError(E);
        raise Exception.Create('Erro ao salvar Ordem de Entrega: ' + E.Message);
      end;
    end;

  finally
    Logger.Free;
  end;
end;


function TOrdemEntrega.SalvarOrdemEmProcesso(pOrdemEntrega, pProcesso: String): Boolean;
var
  Logger: TErrorLogger;
begin
  Result := False;
  Logger := TErrorLogger.Create; // Usa o caminho padrão 'error.log'
  try

    FDatabaseConnection.Connection.StartTransaction;
    try
      FQuery.SQL.Clear;
      if pProcesso = cProcessoSaida then
        FQuery.SQL.Add( 'UPDATE OrdemEntrega SET ' +
                        'SaidaOrdemEntrega = :DataNow, ' +
                        'StatusOrdemEntrega = :Status ' +
                        'WHERE idOrdemEntrega = :Id')
      else
        FQuery.SQL.Add( 'UPDATE OrdemEntrega SET ' +
                        'ChegadaOrdemEntrega = :DataNow, ' +
                        'StatusOrdemEntrega = :Status ' +
                        'WHERE idOrdemEntrega = :Id');

      FQuery.ParamByName('DataNow').Value := Now;
      FQuery.ParamByName('Id').AsString := pOrdemEntrega;
      FQuery.ParamByName('Status').Value := pProcesso;
      FQuery.ExecSQL;


      FQuery.SQL.Clear;
      FQuery.SQL.Add( 'UPDATE Pedidos SET ' +
                      'StatusPedidos = :Status ' +
                      'WHERE NumeroPedidos in (SELECT PedidoPedidosEntrega FROM PedidosEntrega WHERE OrdemEntregaPedidosEntrega = :Id) ');
      FQuery.ParamByName('Id').AsString := pOrdemEntrega;
      FQuery.ParamByName('Status').Value := 1;
      FQuery.ExecSQL;

      FDatabaseConnection.Connection.Commit;
      Result := True; // Indica que foi salvo com sucesso
    except
      on E: Exception do
      begin
        FDatabaseConnection.Connection.Rollback;
        Logger.LogError(E);
        raise Exception.Create('Erro ao salvar Ordem de Entrega: ' + E.Message);
      end;
    end;

  finally
    Logger.Free;
  end;
end;



procedure TOrdemEntrega.CarregarDados(const AFDMemTable: TFDMemTable;
  pidOrdemEntrega, pNomeEntregador, pLimite: String;
  pDtIni, pDtFin : TDate; pStatus : Integer);
begin
  try
    // Prepara a query para selecionar os dados
    FQuery.SQL.Clear;
    FQuery.SQL.Add(' SELECT ');
    FQuery.SQL.Add(' 	a.idOrdemEntrega,     ');
    FQuery.SQL.Add(' 	a.EmissaoOrdemEntrega,');
    FQuery.SQL.Add('  a.EntregadorOrdenEntrega, ');
    FQuery.SQL.Add('  b.NomeEntregador, ');
    FQuery.SQL.Add('  a.SaidaOrdemEntrega, ');
    FQuery.SQL.Add('  a.ChegadaOrdemEntrega, ');
    FQuery.SQL.Add('  a.OBSOrdemEntrega, ');
    FQuery.SQL.Add('  a.StatusOrdemEntrega, ');
    FQuery.SQL.Add(' CASE                  ');
    FQuery.SQL.Add('   WHEN a.StatusOrdemEntrega = 0 THEN '+QuotedStr('Pendente'));
    FQuery.SQL.Add('   WHEN a.StatusOrdemEntrega = 1 THEN '+QuotedStr('Em Andamento'));
    FQuery.SQL.Add('   WHEN a.StatusOrdemEntrega = 2 THEN '+QuotedStr('Entregue Total'));
    FQuery.SQL.Add('   WHEN a.StatusOrdemEntrega = 3 THEN '+QuotedStr('Entregue Total'));
    FQuery.SQL.Add('   ELSE '+QuotedStr('Desconhecido'));
    FQuery.SQL.Add(' END AS Status ');
    FQuery.SQL.Add('	FROM                   ');
    FQuery.SQL.Add('		OrdemEntrega a ');
    FQuery.SQL.Add('	JOIN                   ');
    FQuery.SQL.Add('		Entregador b ON b.idEntregador = a.EntregadorOrdenEntrega');
    FQuery.SQL.Add('	WHERE a.EmissaoOrdemEntrega BETWEEN :pDtIni AND :pDtFin ');
    if Not pidOrdemEntrega.IsEmpty then
      FQuery.SQL.Add('	AND a.idOrdemEntrega = '+pidOrdemEntrega);
    if Not pNomeEntregador.IsEmpty then
      FQuery.SQL.Add('	AND UPPER(b.NomeEntregador) LIKE '+QuotedStr(UpperCase(pNomeEntregador)+'%'));
    if pStatus <> cFour then
      FQuery.SQL.Add('	AND a.StatusOrdemEntrega = '+IntToStr(pStatus));
    FQuery.SQL.Add('	ORDER BY');
    FQuery.SQL.Add('		a.EmissaoOrdemEntrega DESC');
    if Not pLimite.IsEmpty then
      FQuery.SQL.Add(' ROWS 1 TO '+pLimite+' ');
    FQuery.ParamByName('pDtIni').AsDate := pDtIni;
    FQuery.ParamByName('pDtFin').AsDate := pDtFin+1;
    FQuery.Open;

    if FQuery.RecordCount > 0 then
    begin
      // Copia os dados para o TFDMemTable
      AFDMemTable.Close;
      AFDMemTable.Data := FQuery.Data;
      AFDMemTable.Open;
    end
    else
      AFDMemTable.Close;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao carregar dados: ' + E.Message);
    end;
  end;
end;

function TOrdemEntrega.Excluir(const AId: Integer): Boolean;
begin
  Result := False;
  try
    // Prepara a query para excluir
    FQuery.SQL.Clear;
    FQuery.SQL.Add('DELETE FROM OrdemEntrega WHERE idOrdemEntrega = :Id');
    FQuery.ParamByName('Id').AsInteger := AId;

    // Executa a query
    FQuery.ExecSQL;

    Result := True; // Indica que o foi excluído com sucesso
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao excluir Ordem de Entrega: ' + E.Message);
    end;
  end;
end;

function TOrdemEntrega.GerarOrdemEntregaHTML(const pOrdemEntrega: String): string;
var
  HTML: TStringList;
  PedidoAtual: Integer;
begin
  HTML := TStringList.Create;
  try
    // Executa a consulta SQL
    FQuery.SQL.Text :=
        'SELECT ' +
      '  oe.idOrdemEntrega, ' +
      '  oe.EmissaoOrdemEntrega, ' +
      '  e.NomeEntregador, ' +
      '  pe.PedidoPedidosEntrega, ' +
      '  c.NomeClientes, ' +
      '  c.RuaClientes, ' +
      '  c.NumeroRuaClientes, ' +
      '  c.BairroClientes, ' +
      '  c.CidadeClientes, ' +
      '  c.UFClientes, ' +
      '  c.CEPClientes, ' +
      '  c.LongitudeClientes, ' +
      '  c.LatitudeClientes, ' +
      '  p.DescricaoProdutos, ' +
      '  pd.DataEmissaoPedidos, ' +
      '  ip.QuantidadeItensPedido, ' +
      '  tp.PrioridadeTipoProduto, ' +
      '  p.CuidadosArmProdutos, ' +
      '  CASE WHEN p.DataValidadeProdutos < CURRENT_DATE THEN ''SIM'' ELSE ''NÃO'' END AS ValidadeVencida ' +
      'FROM PedidosEntrega pe ' +
      'JOIN OrdemEntrega oe ON oe.idOrdemEntrega = pe.OrdemEntregaPedidosEntrega ' +
      'JOIN Entregador e ON e.idEntregador = oe.EntregadorOrdenEntrega ' +
      'JOIN Pedidos pd ON pd.NumeroPedidos = pe.PedidoPedidosEntrega ' +
      'JOIN Clientes c ON c.CodigoClientes = pd.ClientePedidos ' +
      'JOIN ItensPedido ip ON ip.PedidoItensPedido = pd.NumeroPedidos ' +
      'JOIN Produtos p ON p.idProdutos = ip.ProdutoItensPedido ' +
      'JOIN TipoProduto tp ON tp.idTipoProduto = p.TipoProdutoProdutos ' +
      'WHERE oe.idOrdemEntrega = :OrdemEntregaID ' +
      'ORDER BY pe.PedidoPedidosEntrega, p.DescricaoProdutos';
    FQuery.ParamByName('OrdemEntregaID').AsString := pOrdemEntrega;
    FQuery.Open;

    // Cabeçalho do HTML
    HTML.Add('<html>');
    HTML.Add('<head>');
    HTML.Add('<title>Ordem de Entrega</title>');
    HTML.Add('<style>');
    HTML.Add('  body { font-family: Arial, sans-serif; margin: 20px; }');
    HTML.Add('  h1 { color: #333; }');
    HTML.Add('  h2 { color: #555; }');
    HTML.Add('  table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }');
    HTML.Add('  th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }');
    HTML.Add('  th { background-color: #f2f2f2; }');
    HTML.Add('  .endereco { margin-bottom: 20px; }');
    HTML.Add('  .assinatura { margin-top: 40px; display: flex; justify-content: space-between; }');
    HTML.Add('</style>');
    HTML.Add('</head>');
    HTML.Add('<body>');

    // Título da Ordem de Entrega
    HTML.Add('<h1>ORDEM DE ENTREGA ' + FQuery.FieldByName('idOrdemEntrega').AsString + '</h1>');
    HTML.Add('<p>Data de Emissão: ' + FormatDateTime('dd/mm/yyyy hh:nn', FQuery.FieldByName('EmissaoOrdemEntrega').AsDateTime) + '</p>');
    HTML.Add('<h2>Entregador: ' + FQuery.FieldByName('NomeEntregador').AsString + '</h2>');
    HTML.Add('<hr>');

    // Loop pelos pedidos
    PedidoAtual := -1; // Inicializa com um valor inválido
    while not FQuery.Eof do
    begin
      // Verifica se é um novo pedido
      if FQuery.FieldByName('PedidoPedidosEntrega').AsInteger <> PedidoAtual then
      begin
        // Fecha a tabela do pedido anterior (se houver)
        if PedidoAtual <> -1 then
        begin
          HTML.Add('</table>');
          HTML.Add('</div>');
          HTML.Add('<hr>');
        end;

        // Inicia um novo pedido
        PedidoAtual := FQuery.FieldByName('PedidoPedidosEntrega').AsInteger;
        HTML.Add('<div class="pedido">');
        HTML.Add('<h3>Pedido: ' + FQuery.FieldByName('PedidoPedidosEntrega').AsString +' - Data de Emissão do Pedido: '+ FormatDateTime('dd/mm/yyyy hh:nn', FQuery.FieldByName('DataEmissaoPedidos').AsDateTime) +'</h3>');
        HTML.Add('<div class="endereco">');
        HTML.Add('<p><strong>Cliente:</strong> ' + FQuery.FieldByName('NomeClientes').AsString + '</p>');
        HTML.Add('<p><strong>Endereço:</strong> ' +
          FQuery.FieldByName('RuaClientes').AsString + ', ' +
          FQuery.FieldByName('NumeroRuaClientes').AsString + ' - ' +
          FQuery.FieldByName('BairroClientes').AsString + ', ' +
          FQuery.FieldByName('CidadeClientes').AsString + ' - ' +
          FQuery.FieldByName('UFClientes').AsString + ', ' +
          FQuery.FieldByName('CEPClientes').AsString + '</p>');
        HTML.Add('<p><strong>Coordenadas:</strong> Longitude: ' +
          FQuery.FieldByName('LongitudeClientes').AsString + ', Latitude: ' +
          FQuery.FieldByName('LatitudeClientes').AsString + '</p>');
        HTML.Add('</div>');

        // Inicia a tabela de produtos
        HTML.Add('<h4>Produtos:</h4>');
        HTML.Add('<table>');
        HTML.Add('<tr><th>Produto</th><th>Quantidade</th><th>Prioridade</th><th>Cuidados</th><th>Validade Vencida</th></tr>');
      end;

      // Adiciona os produtos do pedido atual
      HTML.Add('<tr>');
      HTML.Add('<td>' + FQuery.FieldByName('DescricaoProdutos').AsString + '</td>');
      HTML.Add('<td>' + FQuery.FieldByName('QuantidadeItensPedido').AsString + '</td>');
      HTML.Add('<td>' + FQuery.FieldByName('PrioridadeTipoProduto').AsString + '</td>');
      HTML.Add('<td>' + FQuery.FieldByName('CuidadosArmProdutos').AsString + '</td>');
      HTML.Add('<td>' + FQuery.FieldByName('ValidadeVencida').AsString + '</td>');
      HTML.Add('</tr>');

      FQuery.Next;
    end;

    // Fecha o último pedido
    if PedidoAtual <> -1 then
    begin
      HTML.Add('</table>');
      HTML.Add('</div>');
      HTML.Add('<hr>');
    end;

    // Assinaturas
    HTML.Add('<div class="assinatura">');
    HTML.Add('<div><strong>Responsável pela Ordem:_________________________________________</strong></div>');
    HTML.Add('</div>');
    HTML.Add('<div class="assinatura">');
    HTML.Add('<div><strong>Entregador:_________________________________________</strong></div>');
    HTML.Add('</div>');

    // Fecha o HTML
    HTML.Add('</body>');
    HTML.Add('</html>');
    Result := HTML.Text;

  finally
    HTML.Free;
  end;

end;


end.
