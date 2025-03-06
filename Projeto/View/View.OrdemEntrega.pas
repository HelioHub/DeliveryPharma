unit View.OrdemEntrega;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Mask, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.StorageBin, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.DBCtrls, CXConst, Controller.OrdemEntregaController;

type
  TFViewOrdemEntrega = class(TForm)
    PViewPedidos: TPanel;
    DBGView: TDBGrid;
    PHead: TPanel;
    LNR: TLabel;
    BBIncluir: TBitBtn;
    BBAlterar: TBitBtn;
    BBExcluir: TBitBtn;
    BBSair: TBitBtn;
    ENR: TEdit;
    BBOrdens: TBitBtn;
    PFiltrar: TPanel;
    LDT: TLabel;
    Label1: TLabel;
    SBClearOrdem: TSpeedButton;
    SBClearNomeCliente: TSpeedButton;
    LEFiltroIdOrdem: TLabeledEdit;
    LEFiltroNomeEntregador: TLabeledEdit;
    BBAtualizar: TBitBtn;
    DTPDEIni: TDateTimePicker;
    DTPDEFin: TDateTimePicker;
    RGStatus: TRadioGroup;
    PRodape: TPanel;
    PViewItensPedido: TPanel;
    DBGViewItens: TDBGrid;
    OrdensEntregaMemTable: TFDMemTable;
    DSViewOrdens: TDataSource;
    DSPedidos: TDataSource;
    PedidosMemTable: TFDMemTable;
    DBREObs: TDBRichEdit;
    DBREObsPedido: TDBRichEdit;
    BitBtn1: TBitBtn;
    OrdensEntregaMemTableEmissaoOrdemEntrega: TSQLTimeStampField;
    OrdensEntregaMemTableNomeEntregador: TStringField;
    OrdensEntregaMemTableSaidaOrdemEntrega: TSQLTimeStampField;
    OrdensEntregaMemTableChegadaOrdemEntrega: TSQLTimeStampField;
    OrdensEntregaMemTableStatusOrdemEntrega: TStringField;
    OrdensEntregaMemTableOBSOrdemEntrega: TStringField;
    PedidosMemTableNomeClientes: TStringField;
    PedidosMemTableBairroClientes: TStringField;
    PedidosMemTableValorTotalPedidos: TFMTBCDField;
    OrdensEntregaMemTableidOrdemEntrega: TIntegerField;
    OrdensEntregaMemTableEntregadorOrdenEntrega: TIntegerField;
    PedidosMemTableidPedidosEntrega: TIntegerField;
    PedidosMemTableOrdemEntregaPedidosEntrega: TIntegerField;
    PedidosMemTablePedidoPedidosEntrega: TIntegerField;
    PedidosMemTableCodigoClientes: TIntegerField;
    PedidosMemTableStatus: TStringField;
    PedidosMemTableOBSPedidosEntrega: TStringField;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FOrdemEntregaController: TOrdemEntregaController;

    procedure TratarDelete;
    procedure pCRUD(pAcao: TAcao);
    procedure pAtualizacao;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

var
  FViewOrdemEntrega: TFViewOrdemEntrega;

implementation

{$R *.dfm}

{ TFViewOrdemEntrega }

constructor TFViewOrdemEntrega.Create(AOwner: TComponent);
begin
  inherited;
  FOrdemEntregaController := TOrdemEntregaController.Create;
end;

destructor TFViewOrdemEntrega.Destroy;
begin
  FOrdemEntregaController.Free;
  inherited;
end;

procedure TFViewOrdemEntrega.FormShow(Sender: TObject);
begin
  DTPDEIni.DateTime := Date-1;
  DTPDEFin.DateTime := Date;
  pAtualizacao;
end;

procedure TFViewOrdemEntrega.pAtualizacao;
begin
  FOrdemEntregaController.CarregarDadosOrdemEntregas(OrdensEntregaMemTable,
    LEFiltroIdOrdem.Text,
    LEFiltroNomeEntregador.Text,
    ENR.Text,
    DTPDEIni.Date,
    DTPDEFin.Date,
    RGStatus.ItemIndex);
end;

procedure TFViewOrdemEntrega.pCRUD(pAcao: TAcao);
begin
  //
end;

procedure TFViewOrdemEntrega.TratarDelete;
begin
  //
end;

end.
