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
    procedure CarregarDadosEntregadors(const AFDMemTable: TFDMemTable; pIdEntregador, pStatus: String);
  end;

implementation

{ TEntregadorController }

uses Utils.Consts;

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
  pIdEntregador, pStatus: String);
begin
  FEntregador.CarregarDados(AFDMemTable, pIdEntregador, pStatus);
end;

end.
