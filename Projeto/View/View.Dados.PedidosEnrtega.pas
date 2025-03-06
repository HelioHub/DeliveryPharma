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
    PView: TPanel;
    DBGView: TDBGrid;
    PItensPedido: TPanel;
    PDados: TPanel;
    LDT: TLabel;
    LT: TLabel;
    SBF2: TSpeedButton;
    LEOrdemEntrega: TLabeledEdit;
    DTPDataEmissao: TDateTimePicker;
    LECodigoCliente: TLabeledEdit;
    EDescCliente: TEdit;
    LETotalPedido: TLabeledEdit;
    POpcoes: TPanel;
    BBInc: TBitBtn;
    BBExc: TBitBtn;
    LETotalItens: TLabeledEdit;
    PRodape: TPanel;
    BBSair: TBitBtn;
    BBGravar: TBitBtn;
    DSDadosItensPedido: TDataSource;
    ItensPedidoMemTable: TFDMemTable;
    ItensPedidoMemTableidItensPedido: TIntegerField;
    ItensPedidoMemTablePedidoItensPedido: TIntegerField;
    ItensPedidoMemTableProdutoItensPedido: TIntegerField;
    ItensPedidoMemTableDescricaoProdutos: TStringField;
    ItensPedidoMemTableQuantidadeItensPedido: TFMTBCDField;
    ItensPedidoMemTableVlrUnitarioItensPedido: TFMTBCDField;
    ItensPedidoMemTableVlrTotalItensPedido: TFMTBCDField;
    DateTimePicker1: TDateTimePicker;
    Label1: TLabel;
    DateTimePicker2: TDateTimePicker;
    Label2: TLabel;
    DBGrid1: TDBGrid;
    Label3: TLabel;
    DataSource1: TDataSource;
    FDMemTable1: TFDMemTable;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    IntegerField3: TIntegerField;
    StringField1: TStringField;
    FMTBCDField1: TFMTBCDField;
    FMTBCDField2: TFMTBCDField;
    FMTBCDField3: TFMTBCDField;
    DBRichEdit1: TDBRichEdit;
    Label4: TLabel;
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
