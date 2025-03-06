unit Controller.EntregadorController;

interface

uses
  Interfaces.IEntregador, Model.Entregador, FireDAC.Comp.Client;

type
  TEntregadorController = class
  private
    FEntregador: IEntregador;
  public
    constructor Create;
    destructor Destroy; override;

    function GetEntregador: IEntregador;
    procedure CarregarDadosEntregadors(const AFDMemTable: TFDMemTable; pIdEntregador: String);
  end;

implementation

{ TEntregadorController }

uses CXConst;

constructor TEntregadorController.Create;
begin
  FEntregador := TEntregador.Create;
end;

destructor TEntregadorController.Destroy;
begin
  FEntregador := nil;
  inherited;
end;

function TEntregadorController.GetEntregador: IEntregador;
begin
  Result := FEntregador;
end;

procedure TEntregadorController.CarregarDadosEntregadors(const AFDMemTable: TFDMemTable;
  pIdEntregador: String);
begin
  FEntregador.CarregarDados(AFDMemTable, pIdEntregador);
end;

end.
