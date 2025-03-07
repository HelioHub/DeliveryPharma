unit Interfaces.IOrdemEntrega;

interface

uses
  System.SysUtils, FireDAC.Comp.Client;

type
  IOrdemEntrega = interface
    ['{D1D68163-7A50-482E-AA0D-1EFB6A650784}']

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

    // Propriedades
    property IdOrdemEntrega: Integer read GetIdOrdemEntrega write SetIdOrdemEntrega;
    property EntregadorOrdenEntrega: Integer read GetEntregadorOrdenEntrega write SetEntregadorOrdenEntrega;
    property EmissaoOrdemEntrega: TDateTime read GetEmissaoOrdemEntrega write SetEmissaoOrdemEntrega;
    property SaidaOrdemEntrega: TDateTime read GetSaidaOrdemEntrega write SetSaidaOrdemEntrega;
    property ChegadaOrdemEntrega: TDateTime read GetChegadaOrdemEntrega write SetChegadaOrdemEntrega;
    property StatusOrdemEntrega: SmallInt read GetStatusOrdemEntrega write SetStatusOrdemEntrega;
    property OBSOrdemEntrega: string read GetOBSOrdemEntrega write SetOBSOrdemEntrega;

    function Salvar: Boolean;
    function Excluir(const AId: Integer): Boolean;
    procedure CarregarDados(const AFDMemTable: TFDMemTable;
      pidOrdemEntrega, pNomeEntregador, pLimite: String;
      pDtIni, pDtFin : TDate; pStatus : Integer);
    function GerarOrdemEntregaHTML(const pOrdemEntrega: String): string;
  end;

implementation

end.
