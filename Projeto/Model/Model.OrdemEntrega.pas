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
    FDatabaseConnection: TDatabaseConnection; // Conex�o centralizada

    // M�todos Set e Get para cada campo
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

    function Salvar: Boolean; // Implementa��o do m�todo Salvar
    function Excluir(const AId: Integer): Boolean; // Implementa��o do m�todo Excluir
    procedure CarregarDados(const AFDMemTable: TFDMemTable;
      pidOrdemEntrega, pNomeEntregador, pLimite: String;
      pDtIni, pDtFin : TDate; pStatus : Integer); // Implementa��o do m�todo CarregarDados
  end;

implementation

uses
  FireDAC.DApt, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, System.SysUtils, Vcl.Dialogs,
  Utils.ErrorLogger, Utils.Consts;

{ TOrdemEntrega }

constructor TOrdemEntrega.Create;
begin
  // Usa a conex�o centralizada com par�metros do arquivo .INI
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


// M�todos Set e Get para IdOrdemEntrega
procedure TOrdemEntrega.SetIdOrdemEntrega(const Value: Integer);
begin
  if Value < 0 then
    raise Exception.Create('ID da ordem de entrega n�o pode ser negativo.');
  FIdOrdemEntrega := Value;
end;

function TOrdemEntrega.GetIdOrdemEntrega: Integer;
begin
  Result := FIdOrdemEntrega;
end;

// M�todos Set e Get para EntregadorOrdenEntrega
procedure TOrdemEntrega.SetEntregadorOrdenEntrega(const Value: Integer);
begin
  if Value < 0 then
    raise Exception.Create('ID do entregador n�o pode ser negativo.');
  FEntregadorOrdenEntrega := Value;
end;

function TOrdemEntrega.GetEntregadorOrdenEntrega: Integer;
begin
  Result := FEntregadorOrdenEntrega;
end;

// M�todos Set e Get para EmissaoOrdemEntrega
procedure TOrdemEntrega.SetEmissaoOrdemEntrega(const Value: TDateTime);
begin
  if Value > Now then
    raise Exception.Create('Data de emiss�o n�o pode ser no futuro.');
  FEmissaoOrdemEntrega := Value;
end;

function TOrdemEntrega.GetEmissaoOrdemEntrega: TDateTime;
begin
  Result := FEmissaoOrdemEntrega;
end;

// M�todos Set e Get para SaidaOrdemEntrega
procedure TOrdemEntrega.SetSaidaOrdemEntrega(const Value: TDateTime);
begin
  if (Value < FEmissaoOrdemEntrega) then
    raise Exception.Create('Data de sa�da n�o pode ser anterior � data de emiss�o.');
  FSaidaOrdemEntrega := Value;
end;

function TOrdemEntrega.GetSaidaOrdemEntrega: TDateTime;
begin
  Result := FSaidaOrdemEntrega;
end;

// M�todos Set e Get para ChegadaOrdemEntrega
procedure TOrdemEntrega.SetChegadaOrdemEntrega(const Value: TDateTime);
begin
  if (Value < FSaidaOrdemEntrega) then
    raise Exception.Create('Data de chegada n�o pode ser anterior � data de sa�da.');
  FChegadaOrdemEntrega := Value;
end;

function TOrdemEntrega.GetChegadaOrdemEntrega: TDateTime;
begin
  Result := FChegadaOrdemEntrega;
end;

// M�todos Set e Get para StatusOrdemEntrega
procedure TOrdemEntrega.SetStatusOrdemEntrega(const Value: SmallInt);
begin
  if not (Value in [0, 1, 2, 3]) then
    raise Exception.Create('Status inv�lido! Valores permitidos: 0, 1, 2, 3.');
  FStatusOrdemEntrega := Value;
end;

function TOrdemEntrega.GetStatusOrdemEntrega: SmallInt;
begin
  Result := FStatusOrdemEntrega;
end;

// M�todos Set e Get para OBSOrdemEntrega
procedure TOrdemEntrega.SetOBSOrdemEntrega(const Value: string);
begin
  if Length(Value) > 1000 then
    raise Exception.Create('Observa��o n�o pode ter mais de 1000 caracteres.');
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
  Logger := TErrorLogger.Create; // Usa o caminho padr�o 'error.log'
  try

    FDatabaseConnection.Connection.StartTransaction;
    try
      // Prepara a query para inserir ou atualizar
      FQuery.SQL.Clear;
      if FIdOrdemEntrega = 0 then
      begin
        // Inserir novo
        FQuery.SQL.Add('INSERT INTO OrdemEntrega ' +
                       '(idOrdemEntrega, EntregadorOrdenEntrega, EmissaoOrdemEntrega, SaidaOrdemEntrega, ChegadaOrdemEntrega, StatusOrdemEntrega, OBSOrdemEntrega) ' +
                       'VALUES ' +
                       '(GEN_ID(GEN_OrdemEntrega_ID, 1), :Entregador, :Emissao, :Saida, :Chegada, :Status, :OBS)');
      end
      else
      begin
        // Atualizar
        FQuery.SQL.Add( 'UPDATE OrdemEntrega SET ' +
                        'EntregadorOrdenEntrega = :Entregador, ' +
                        'EmissaoOrdemEntrega = :Emissao, ' +
                        'SaidaOrdemEntrega = :Saida, ' +
                        'ChegadaOrdemEntrega = :Chegada, ' +
                        'StatusOrdemEntrega = :Status, ' +
                        'OBSOrdemEntrega = :OBS ' +
                        'WHERE idOrdemEntrega = :Id');
        FQuery.ParamByName('Id').AsInteger := FIdOrdemEntrega;
      end;

      // Define os par�metros da query
      FQuery.ParamByName('Entregador').Value := FEntregadorOrdenEntrega;
      FQuery.ParamByName('Emissao').Value := FEmissaoOrdemEntrega;
      FQuery.ParamByName('Saida').Value := FSaidaOrdemEntrega;
      FQuery.ParamByName('Chegada').Value := FChegadaOrdemEntrega;
      FQuery.ParamByName('Status').Value := FStatusOrdemEntrega;
      FQuery.ParamByName('OBS').Value := FOBSOrdemEntrega;

      // Executa a query
      FQuery.ExecSQL;

      // Se for uma inser��o, recupera o ID gerado
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
    FQuery.SQL.Add(' CASE                  ');
    FQuery.SQL.Add('   WHEN a.StatusOrdemEntrega = 0 THEN '+QuotedStr('Pendente'));
    FQuery.SQL.Add('   WHEN a.StatusOrdemEntrega = 1 THEN '+QuotedStr('Em Andamento'));
    FQuery.SQL.Add('   WHEN a.StatusOrdemEntrega = 2 THEN '+QuotedStr('Entregue Parcial'));
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

    Result := True; // Indica que o foi exclu�do com sucesso
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao excluir Ordem de Entrega: ' + E.Message);
    end;
  end;
end;

end.
