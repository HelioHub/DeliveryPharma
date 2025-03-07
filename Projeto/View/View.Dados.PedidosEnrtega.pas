unit View.Dados.PedidosEnrtega;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.StorageBin,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ComCtrls, Vcl.Mask, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls;

type
  TFDadosPedidosEntrega = class(TForm)
    PPedidosDisponivel: TPanel;
    DBGView: TDBGrid;
    PLabelPedidoDisponivel: TPanel;
    PDados: TPanel;
    LDT: TLabel;
    LT: TLabel;
    LEOrdemEntrega: TLabeledEdit;
    DTPDataEmissao: TDateTimePicker;
    LECodigoEntregador: TLabeledEdit;
    LEStatus: TLabeledEdit;
    POpcoes: TPanel;
    BBInc: TBitBtn;
    BBExc: TBitBtn;
    PRodape: TPanel;
    BBSair: TBitBtn;
    BBGravar: TBitBtn;
    DSPedidosDisp: TDataSource;
    PedidosDispMemTable: TFDMemTable;
    DTPSaida: TDateTimePicker;
    LDTSaida: TLabel;
    DTPChegada: TDateTimePicker;
    LDTChegada: TLabel;
    DBGPedidosEntrega: TDBGrid;
    L5Pedidos: TLabel;
    DSPedidosEntrega: TDataSource;
    PedidosEntregaMemTable: TFDMemTable;
    DBREObsOrdemEntrega: TDBRichEdit;
    LObsOrdemEntrega: TLabel;
    DBLCBEntregador: TDBLookupComboBox;
    PRodFinal: TPanel;
    DBREObsPedidoEntrega: TDBRichEdit;
    PedidosDispMemTableNumeroPedidos: TIntegerField;
    PedidosDispMemTableNomeClientes: TStringField;
    PedidosDispMemTableDataEmissaoPedidos: TSQLTimeStampField;
    PedidosDispMemTableValorTotalPedidos: TFMTBCDField;
    PedidosDispMemTableStatus: TStringField;
    PedidosDispMemTableMaiorPrioridade: TStringField;
    PedidosDispMemTableCuidados: TStringField;
    PedidosDispMemTableValidadeVencido: TStringField;
    BBGeracaoAutomatica: TBitBtn;
    PedidosEntregaMemTableidPedidosEntrega: TIntegerField;
    PedidosEntregaMemTablePedidoPedidosEntrega: TIntegerField;
    PedidosEntregaMemTableNomeClientes: TStringField;
    PedidosEntregaMemTableRuaClientes: TStringField;
    PedidosEntregaMemTableCEPClientes: TStringField;
    PedidosEntregaMemTableNumeroRuaClientes: TIntegerField;
    PedidosEntregaMemTableBairroClientes: TStringField;
    PedidosEntregaMemTablePrioridade: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FDadosPedidosEntrega: TFDadosPedidosEntrega;

implementation

{$R *.dfm}

end.
