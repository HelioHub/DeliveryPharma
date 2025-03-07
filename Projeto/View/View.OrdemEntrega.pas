unit View.OrdemEntrega;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Mask, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.StorageBin, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.DBCtrls, Utils.Consts, Controller.OrdemEntregaController;

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
    procedure BBIncluirClick(Sender: TObject);
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

uses View.Dados.PedidosEnrtega;

{ TFViewOrdemEntrega }

procedure TFViewOrdemEntrega.BBIncluirClick(Sender: TObject);
begin
  pCRUD(acIncluir);
end;

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
var
  FormPedidosEntrega: TFDadosPedidosEntrega;
begin
  if (DSViewOrdens.DataSet.FieldByName('idOrdemEntrega').IsNull) and
     (pAcao <> acIncluir) then
  begin
    Beep;
    ShowMessage('Selecione um registro v�lido '+cEOL+'para efetuar opera��o desejada!');
    Exit;
  end;

  if (pAcao = acExcluir) then
  begin
    if FOrdemEntregaController.ExcluirOrdemEntrega(
       DSViewOrdens.DataSet.FieldByName('idOrdemEntrega').AsInteger) then
      ShowMessage('Ordem de Entrega exclu�do com sucesso!')
    else
      ShowMessage('Erro ao excluir Ordem de Entrega.');
  end
  else
  begin
    FormPedidosEntrega := TFDadosPedidosEntrega.Create(Application);
    if (pAcao = acIncluir) then
    begin
      FormPedidosEntrega.Caption := FormPedidosEntrega.Caption + '-' + cAcaoIncluir;
      FormPedidosEntrega.LEOrdemEntrega.Clear;
      FormPedidosEntrega.DTPDataEmissao.DateTime := Now;
    end
    else
    begin
      FormPedidosEntrega.Caption := FormPedidosEntrega.Caption + '-' + cAcaoAlterar;
      FormPedidosEntrega.LEOrdemEntrega.Text := DSViewOrdens.DataSet.FieldByName('idOrdemEntrega').AsString;
      FormPedidosEntrega.DTPDataEmissao.DateTime := DSViewOrdens.DataSet.FieldByName('DataEmissaoPedidos').AsDateTime;
      FormPedidosEntrega.LECodigoEntregador.Text := DSViewOrdens.DataSet.FieldByName('EntregadorOrdenEntrega').AsString;
      FormPedidosEntrega.DTPSaida.DateTime := DSViewOrdens.DataSet.FieldByName('SaidaOrdemEntrega').AsDateTime;
      FormPedidosEntrega.DTPChegada.DateTime := DSViewOrdens.DataSet.FieldByName('ChegadaOrdemEntrega').AsDateTime;
      FormPedidosEntrega.LEStatus.Text := DSViewOrdens.DataSet.FieldByName('Status').AsString;
      FormPedidosEntrega.DBREObsOrdemEntrega.Text := DSViewOrdens.DataSet.FieldByName('OBSOrdemEntrega').AsString;
    end;
    FormPedidosEntrega.ShowModal;
  end;
  pAtualizacao;
end;

procedure TFViewOrdemEntrega.TratarDelete;
begin
  //
end;

end.
