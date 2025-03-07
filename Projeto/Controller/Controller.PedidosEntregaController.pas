unit Controller.PedidosEntregaController;

interface

uses
  Interfaces.IPedidosEntrega, Model.PedidosEntrega, FireDAC.Comp.Client;

type
  TPedidosEntregaController = class
  private
    FPedidosEntrega: IPedidosEntrega;
  public
    constructor Create;
    destructor Destroy; override;

    function GetOrdemEntrega: IPedidosEntrega;
    function SalvarPedidosEntrega(APedidosEntrega: IPedidosEntrega) : Boolean;
    function ExcluirPedidosEntrega(const AId: Integer): Boolean;
    procedure CarregarDadosPedidosEntrega(const AFDMemTable: TFDMemTable;
      pOrdemEntrega: String);
  end;

implementation

{ TPedidosEntregaController }

uses Utils.Consts;

constructor TPedidosEntregaController.Create;
begin
  FPedidosEntrega := TPedidosEntrega.Create;
end;

destructor TPedidosEntregaController.Destroy;
begin
  FPedidosEntrega := nil;
  inherited;
end;

function TPedidosEntregaController.GetOrdemEntrega: IPedidosEntrega;
begin
  Result := FPedidosEntrega;
end;

function TPedidosEntregaController.SalvarPedidosEntrega(APedidosEntrega: IPedidosEntrega) : Boolean;
begin
   result := APedidosEntrega.Salvar;
end;

procedure TPedidosEntregaController.CarregarDadosPedidosEntrega(const AFDMemTable: TFDMemTable; pOrdemEntrega: String);
begin
  FPedidosEntrega.CarregarDados(AFDMemTable, pOrdemEntrega);
end;

function TPedidosEntregaController.ExcluirPedidosEntrega(const AId: Integer): Boolean;
begin
  Result := FPedidosEntrega.Excluir(AId);
end;

end.
