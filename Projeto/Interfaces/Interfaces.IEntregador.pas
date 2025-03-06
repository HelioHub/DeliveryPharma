unit Interfaces.IEntregador;

interface

uses
  System.SysUtils, FireDAC.Comp.Client;

type
  IEntregador = interface
    ['{0886ADBF-A979-4BC2-A1F7-7401784F9D0B}']

    procedure SetIdEntregador(const Value: Integer);
    function GetIdEntregador: Integer;

    procedure SetNomeEntregador(const Value: string);
    function GetNomeEntregador: string;

    procedure SetSituacaoEntregador(const Value: SmallInt);
    function GetSituacaoEntregador: SmallInt;

    property IdEntregador: Integer read GetIdEntregador write SetIdEntregador;
    property NomeEntregador: string read GetNomeEntregador write SetNomeEntregador;
    property SituacaoEntregador: SmallInt read GetSituacaoEntregador write SetSituacaoEntregador;

    function Salvar: Boolean; // Implementa��o do m�todo Salvar
    function Excluir(const AId: Integer): Boolean; // Implementa��o do m�todo Excluir

    procedure CarregarDados(const AFDMemTable: TFDMemTable; pEntregador: String); // Implementa��o do m�todo CarregarDados
  end;

implementation

end.
