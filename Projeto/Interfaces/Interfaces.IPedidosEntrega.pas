unit Interfaces.IPedidosEntrega;

interface

uses
  System.SysUtils, FireDAC.Comp.Client;

type
  IPedidosEntrega = interface
    ['{D153C111-7B80-4447-ACB5-3A3FE8814178}']

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

    property IdPedidosEntrega: Integer read GetIdPedidosEntrega write SetIdPedidosEntrega;
    property PedidoPedidosEntrega: Integer read GetPedidoPedidosEntrega write SetPedidoPedidosEntrega;
    property OrdemEntregaPedidosEntrega: Integer read GetOrdemEntregaPedidosEntrega write SetOrdemEntregaPedidosEntrega;
    property StatusPedidosEntrega: SmallInt read GetStatusPedidosEntrega write SetStatusPedidosEntrega;
    property OBSPedidosEntrega: string read GetOBSPedidosEntrega write SetOBSPedidosEntrega;

    function Salvar: Boolean; // Implementação do método Salvar
    function Excluir(const AId: Integer): Boolean; // Implementação do método Excluir

    procedure CarregarDados(const AFDMemTable: TFDMemTable; pOrdemEntrega: String); // Implementação do método CarregarDados
    procedure CarregarDadosRotas(const AFDMemTable: TFDMemTable; pPedido: String);
    procedure CarregarDadosPedidosOrdem(const AFDMemTable: TFDMemTable;
      pidOrdem: String);
    function PedidoEmOrdem(const pPedido: String) : Integer;
  end;

implementation

end.
