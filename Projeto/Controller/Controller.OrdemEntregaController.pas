unit Controller.OrdemEntregaController;

interface

uses
  Interfaces.IOrdemEntrega, Model.OrdemEntrega, FireDAC.Comp.Client;

type
  TOrdemEntregaController = class
  private
    FOrdemEntrega: IOrdemEntrega;
  public
    constructor Create;
    destructor Destroy; override;

    function GetOrdemEntrega: IOrdemEntrega;
    function SalvarOrdemEntrega(AOrdemEntrega: IOrdemEntrega) : Boolean;
    function ExcluirOrdemEntrega(const AId: Integer): Boolean;
    procedure CarregarDadosOrdemEntregas(const AFDMemTable: TFDMemTable;
      pidOrdemEntrega, pNomeEntregador, pLimite: String;
      pDtIni, pDtFin : TDate; pStatus : Integer);
    function GerarOrdemEntregaHTML(const pOrdemEntrega: String): string;
    function SalvarOrdemEmProcesso(pOrdemEntrega, pProcesso: String): Boolean;
  end;

implementation

{ TOrdemEntregaController }

uses Utils.Consts;

constructor TOrdemEntregaController.Create;
begin
  FOrdemEntrega := TOrdemEntrega.Create;
end;

destructor TOrdemEntregaController.Destroy;
begin
  FOrdemEntrega := nil;
  inherited;
end;

function TOrdemEntregaController.GerarOrdemEntregaHTML(
  const pOrdemEntrega: String): string;
begin
  result := FOrdemEntrega.GerarOrdemEntregaHTML(pOrdemEntrega);
end;

function TOrdemEntregaController.GetOrdemEntrega: IOrdemEntrega;
begin
  Result := FOrdemEntrega;
end;

function TOrdemEntregaController.SalvarOrdemEmProcesso(pOrdemEntrega,
  pProcesso: String): Boolean;
begin
  Result := FOrdemEntrega.SalvarOrdemEmProcesso(pOrdemEntrega, pProcesso);
end;

function TOrdemEntregaController.SalvarOrdemEntrega(AOrdemEntrega: IOrdemEntrega) : Boolean;
begin
  if AOrdemEntrega.EntregadorOrdenEntrega = cZero then
    result := false
  else
    result := AOrdemEntrega.Salvar;
end;

procedure TOrdemEntregaController.CarregarDadosOrdemEntregas(
  const AFDMemTable: TFDMemTable;
  pidOrdemEntrega, pNomeEntregador, pLimite: String;
  pDtIni, pDtFin : TDate; pStatus : Integer);
begin
  FOrdemEntrega.CarregarDados(AFDMemTable, pidOrdemEntrega, pNomeEntregador, pLimite, pDtIni, pDtFin, pStatus);
end;

function TOrdemEntregaController.ExcluirOrdemEntrega(const AId: Integer): Boolean;
begin
  Result := FOrdemEntrega.Excluir(AId);
end;

end.
