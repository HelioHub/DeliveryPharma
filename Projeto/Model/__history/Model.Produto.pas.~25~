unit Model.Produto;

interface

uses
  Interfaces.IProduto, FireDAC.Comp.Client, Data.DB, Utils.DatabaseConnection;

type
  TProduto = class(TInterfacedObject, IProduto)
  private
    FIdProdutos: Integer;
    FTipoProdutoProdutos: Integer;
    FCodigoProdutos: string;
    FDescricaoProdutos: string;
    FQuantidadeProdutos: Double;
    FUndProdutos: string;
    FPrecoVendaProdutos: Double;
    FPrescricaoProdutos: string;
    FCuidadosArmProdutos: string;
    FDataValidadeProdutos: TDate;

    FQuery: TFDQuery; // Query para interagir com o banco de dados
    FDatabaseConnection: TDatabaseConnection; // Conexão centralizada

    function GetIdProdutos: Integer;
    function GetTipoProdutoProdutos: Integer;
    function GetCodigoProdutos: string;
    function GetDescricaoProdutos: string;
    function GetQuantidadeProdutos: Double;
    function GetUndProdutos: string;
    function GetPrecoVendaProdutos: Double;
    function GetPrescricaoProdutos: string;
    function GetCuidadosArmProdutos: string;
    function GetDataValidadeProdutos: TDate;

    procedure SetIdProdutos(const Value: Integer);
    procedure SetTipoProdutoProdutos(const Value: Integer);
    procedure SetCodigoProdutos(const Value: string);
    procedure SetDescricaoProdutos(const Value: string);
    procedure SetQuantidadeProdutos(const Value: Double);
    procedure SetUndProdutos(const Value: string);
    procedure SetPrecoVendaProdutos(const Value: Double);
    procedure SetPrescricaoProdutos(const Value: string);
    procedure SetCuidadosArmProdutos(const Value: string);
    procedure SetDataValidadeProdutos(const Value: TDate);
  public
    constructor Create;
    destructor Destroy; override;

    property IdProdutos: Integer read FIdProdutos write FIdProdutos;
    property TipoProdutoProdutos: Integer read FTipoProdutoProdutos write FTipoProdutoProdutos;
    property CodigoProdutos: string read FCodigoProdutos write FCodigoProdutos;
    property DescricaoProdutos: string read FDescricaoProdutos write FDescricaoProdutos;
    property QuantidadeProdutos: Double read FQuantidadeProdutos write FQuantidadeProdutos;
    property UndProdutos: string read FUndProdutos write FUndProdutos;
    property PrecoVendaProdutos: Double read FPrecoVendaProdutos write FPrecoVendaProdutos;
    property PrescricaoProdutos: string read FPrescricaoProdutos write FPrescricaoProdutos;
    property CuidadosArmProdutos: string read FCuidadosArmProdutos write FCuidadosArmProdutos;
    property DataValidadeProdutos: TDate read FDataValidadeProdutos write FDataValidadeProdutos;

    function CarregarNomePorId(pId: String): String;
    function CarregarPricePorId(pId: String): Double;
    procedure CarregarDados(const AFDMemTable: TFDMemTable; pDescricaoProduto: String; pIdProduto: String); // Implementação do método CarregarDados
  end;

implementation

uses
  FireDAC.DApt, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, System.SysUtils, Vcl.Dialogs, CXConst;

{ TProduto }

constructor TProduto.Create;
begin
  // Usa a conexão centralizada com parâmetros do arquivo .INI
  FDatabaseConnection := TDatabaseConnection.Create;
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FDatabaseConnection.Connection;
end;

destructor TProduto.Destroy;
begin
  FQuery.Free;
  FDatabaseConnection.Free;
  inherited;
end;

function TProduto.GetIdProdutos: Integer;
begin
  Result := FIdProdutos;
end;

function TProduto.GetCodigoProdutos: string;
begin
  Result := FCodigoProdutos;
end;

function TProduto.GetCuidadosArmProdutos: string;
begin
  Result := FCuidadosArmProdutos;
end;

function TProduto.GetDataValidadeProdutos: TDate;
begin
  Result := FDataValidadeProdutos;
end;

function TProduto.GetDescricaoProdutos: string;
begin
  Result := FDescricaoProdutos;
end;

function TProduto.GetPrecoVendaProdutos: Double;
begin
  Result := FPrecoVendaProdutos;
end;

function TProduto.GetPrescricaoProdutos: string;
begin
  Result := FPrescricaoProdutos;
end;

function TProduto.GetQuantidadeProdutos: Double;
begin
  Result := FQuantidadeProdutos;
end;

function TProduto.GetTipoProdutoProdutos: Integer;
begin
  Result := FTipoProdutoProdutos;
end;

function TProduto.GetUndProdutos: string;
begin
  Result := FUndProdutos;
end;

procedure TProduto.SetidProdutos(const Value: Integer);
begin
  FIdProdutos := Value;
end;

procedure TProduto.SetCodigoProdutos(const Value: string);
begin
  FCodigoProdutos := Value;
end;

procedure TProduto.SetCuidadosArmProdutos(const Value: string);
begin
  FCuidadosArmProdutos := Value;
end;

procedure TProduto.SetDataValidadeProdutos(const Value: TDate);
begin
  FDataValidadeProdutos := Value;
end;

procedure TProduto.SetDescricaoProdutos(const Value: string);
begin
  FDescricaoProdutos := Value;
end;

procedure TProduto.SetPrecoVendaProdutos(const Value: Double);
begin
  FPrecoVendaProdutos := Value;
end;

procedure TProduto.SetPrescricaoProdutos(const Value: string);
begin
  FPrescricaoProdutos := Value;
end;

procedure TProduto.SetQuantidadeProdutos(const Value: Double);
begin
  FQuantidadeProdutos := Value;
end;

procedure TProduto.SetTipoProdutoProdutos(const Value: Integer);
begin
  FTipoProdutoProdutos := Value;
end;

procedure TProduto.SetUndProdutos(const Value: string);
begin
  FUndProdutos := Value;
end;

procedure TProduto.CarregarDados(const AFDMemTable: TFDMemTable; pDescricaoProduto: String; pIdProduto: String);
begin
  try
    // Prepara a query para selecionar os dados
    FQuery.SQL.Clear;
    FQuery.SQL.Add('SELECT a.idprodutos, b.descricaotipoproduto, a.codigoprodutos, a.descricaoprodutos, a.quantidadeprodutos, a.undprodutos, a.precovendaprodutos ');
    FQuery.SQL.Add('FROM Produtos a ');
    FQuery.SQL.Add('JOIN          ');
    FQuery.SQL.Add(' TipoProduto b ON b.idTipoProduto = a.TipoProdutoProdutos ');
    FQuery.SQL.Add('WHERE 1=1 ');
    if pDescricaoProduto <> EmptyStr then
      FQuery.SQL.Add(' AND UPPER(DescricaoProdutos) LIKE '+QuotedStr(pDescricaoProduto+'%'));
    if pIdProduto <> EmptyStr then
      FQuery.SQL.Add(' AND a.idprodutos = '+pIdProduto);
    FQuery.SQL.Add(' ORDER BY a.TipoProdutoProdutos, a.idprodutos ');
    FQuery.Open;

    // Copia os dados para o TFDMemTable
    AFDMemTable.Close;
    AFDMemTable.Data := FQuery.Data;
    AFDMemTable.Open;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao carregar dados: ' + E.Message);
    end;
  end;
end;

function TProduto.CarregarNomePorId(pId: String) : String;
begin
  Result := '';
  try
    FQuery.SQL.Clear;
    FQuery.SQL.Add(' SELECT DescricaoProdutos ');
    FQuery.SQL.Add(' FROM Produtos ');
    if pId <> EmptyStr then
      FQuery.SQL.Add('WHERE idProdutos = '+pId);
    FQuery.Open;

    Result := FQuery.FieldByName('DescricaoProdutos').AsString;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao carregar dados: ' + E.Message);
    end;
  end;
end;

function TProduto.CarregarPricePorId(pId: String) : Double;
begin
  Result := 0;
  try
    FQuery.SQL.Clear;
    FQuery.SQL.Add(' SELECT PrecoVendaProdutos ');
    FQuery.SQL.Add(' FROM Produtos ');
    if pId <> EmptyStr then
      FQuery.SQL.Add('WHERE idProdutos = '+pId);
    FQuery.Open;

    Result := FQuery.FieldByName('PrecoVendaProdutos').AsFloat;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao carregar dados: ' + E.Message);
    end;
  end;
end;

end.
