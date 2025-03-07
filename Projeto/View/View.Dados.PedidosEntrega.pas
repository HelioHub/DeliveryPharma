unit View.Dados.PedidosEntrega;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.StorageBin,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ComCtrls, Vcl.Mask, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls,
  Interfaces.IEntregador, Interfaces.IOrdemEntrega, Interfaces.IPedidosEntrega,
  Controller.EntregadorController, Controller.OrdemEntregaController, Controller.PedidosEntregaController,
  Utils.Consts;

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
    LObsOrdemEntrega: TLabel;
    DBLCBEntregador: TDBLookupComboBox;
    PRodFinal: TPanel;
    DBREObsPedidoEntrega: TDBRichEdit;
    PedidosDispMemTableNumeroPedidos: TIntegerField;
    PedidosDispMemTableNomeClientes: TStringField;
    PedidosDispMemTableDataEmissaoPedidos: TSQLTimeStampField;
    PedidosDispMemTableValorTotalPedidos: TFMTBCDField;
    PedidosDispMemTableStatus: TStringField;
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
    MObsOrdem: TMemo;
    EntregadorMemTable: TFDMemTable;
    DSEntregador: TDataSource;
    EntregadorMemTableidEntregador: TIntegerField;
    EntregadorMemTableNomeEntregador: TStringField;
    EntregadorMemTableStatus: TStringField;
    Label1: TLabel;
    PedidosDispMemTableMaiorPrioridade: TIntegerField;
    Label2: TLabel;
    PedidosEntregaMemTablePrioridade: TIntegerField;
    PedidosEntregaMemTableOBSPedidosEntrega: TStringField;
    procedure BBGravarClick(Sender: TObject);
    procedure BBSairClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure DBLCBEntregadorClick(Sender: TObject);
    procedure BBGeracaoAutomaticaClick(Sender: TObject);
    procedure BBIncClick(Sender: TObject);
    procedure BBExcClick(Sender: TObject);
  private
    { Private declarations }
    FOrdemEntregaController: TOrdemEntregaController;
    FPedidosOrdemController: TPedidosEntregaController;
    FEntregadorController: TEntregadorController;

    procedure pAtualizaPedidosOrdem;
    procedure pAtualizaOrdem;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

var
  FDadosPedidosEntrega: TFDadosPedidosEntrega;

implementation

{$R *.dfm}

{ TFDadosPedidosEntrega }

procedure TFDadosPedidosEntrega.BBGeracaoAutomaticaClick(Sender: TObject);
begin
  Beep;
  ShowMessage('Projeto para gera��o das Rotas Automaticamente para os Entregadores:'+cEol+
      ' 1) Considerando a Prioridades dos Produtos + Data de Emiss�o do Pedido;'+cEOL+
      ' 2) Distruir entre os Entregadores de forma inteligente considerando proximidade e prioridade;'+cEOL+
      ' 3) Respeitando o quantitativo de 5 Pedidos por Entrega.'+cEOL+
      ' '+cEOL+
      'Em Desenvolvimento!!')
end;

procedure TFDadosPedidosEntrega.BBGravarClick(Sender: TObject);
var
  OrdemEntrega: IOrdemEntrega;
begin
  OrdemEntrega := FOrdemEntregaController.GetOrdemEntrega;

  OrdemEntrega.IdOrdemEntrega := StrToIntDef(LEOrdemEntrega.Text, 0);
  OrdemEntrega.EmissaoOrdemEntrega := DTPDataEmissao.DateTime;
  OrdemEntrega.EntregadorOrdenEntrega := StrToIntDef(LECodigoEntregador.Text, 0);
  OrdemEntrega.OBSOrdemEntrega := MObsOrdem.Text;

  if FOrdemEntregaController.SalvarOrdemEntrega(OrdemEntrega) then
  begin
    // Atualiza o campo com o ID gerado
    LEOrdemEntrega.Text := IntToStr(OrdemEntrega.IdOrdemEntrega);

    ShowMessage('Sucesso na Grava��o da Ordem de Entrega '+LEOrdemEntrega.Text+'.');
  end
  else
    ShowMessage('Sem Sucesso na Grava��o da Ordem '+LEOrdemEntrega.Text+'.'+cEOL+
      'Falta informar o C�digo do Entregador!');
  pAtualizaPedidosOrdem;
end;

procedure TFDadosPedidosEntrega.BBIncClick(Sender: TObject);
var
  PedidosEntrega : IPedidosEntrega;
begin
  if PedidosEntregaMemTable.Locate('PedidoPedidosEntrega', DSPedidosDisp.DataSet.FieldByName('NumeroPedidos').AsInteger, []) then
  begin
    Beep;
    ShowMessage('Pedido j� existente!!');
    exit;
  end;
  if PedidosEntregaMemTable.RecordCount >= cFive then
  begin
    Beep;
    ShowMessage('Aten��o!! Somente 5 Pedidos por Ordem de Entrega.');
    exit;
  end;

  PedidosEntrega := FPedidosOrdemController.GetOrdemEntrega;

  PedidosEntrega.IdPedidosEntrega := 0;
  PedidosEntrega.PedidoPedidosEntrega := DSPedidosDisp.DataSet.FieldByName('NumeroPedidos').AsInteger;
  PedidosEntrega.OrdemEntregaPedidosEntrega := StrToIntDef(LEOrdemEntrega.Text, 0);
  PedidosEntrega.StatusPedidosEntrega := 0;
  PedidosEntrega.OBSPedidosEntrega := '<< Observa��es sobre o Pedido: >>'+cEOL+
                                      ' '+cEOL+
                                      'Prioridade do Pedido N�mero '+DSPedidosDisp.DataSet.FieldByName('MaiorPrioridade').AsString+cEOL+
                                      'Requer Cuidados de Armazenamento: '+DSPedidosDisp.DataSet.FieldByName('Cuidados').AsString+cEOL+
                                      'Produto(s) com Validade vencida: '+DSPedidosDisp.DataSet.FieldByName('ValidadeVencida').AsString;

  FPedidosOrdemController.SalvarPedidosEntrega(PedidosEntrega);
  pAtualizaPedidosOrdem;
end;

procedure TFDadosPedidosEntrega.BBExcClick(Sender: TObject);
begin
  if Not DSPedidosEntrega.DataSet.FieldByName('idPedidosEntrega').IsNull then
  begin
    FPedidosOrdemController.ExcluirPedidosEntrega(DSPedidosEntrega.DataSet.FieldByName('idPedidosEntrega').AsInteger);
    pAtualizaPedidosOrdem;
  end;
end;

procedure TFDadosPedidosEntrega.BBSairClick(Sender: TObject);
begin
  Close;
end;

constructor TFDadosPedidosEntrega.Create(AOwner: TComponent);
begin
  inherited;
  FOrdemEntregaController := TOrdemEntregaController.Create;
  FPedidosOrdemController := TPedidosEntregaController.Create;
  FEntregadorController := TEntregadorController.Create;
end;

procedure TFDadosPedidosEntrega.DBLCBEntregadorClick(Sender: TObject);
begin
  LECodigoEntregador.Text := DSEntregador.DataSet.FieldByName('idEntregador').AsString;
end;

destructor TFDadosPedidosEntrega.Destroy;
begin
  FOrdemEntregaController.Free;
  FPedidosOrdemController.Free;
  FEntregadorController.Free;
  inherited;
end;

procedure TFDadosPedidosEntrega.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := CaFree;
end;

procedure TFDadosPedidosEntrega.FormShow(Sender: TObject);
begin
  pAtualizaOrdem;
end;

procedure TFDadosPedidosEntrega.pAtualizaPedidosOrdem;
begin
  BBInc.Enabled := False;
  BBExc.Enabled := False;
  if LEOrdemEntrega.Text <> '' then
  begin
    FPedidosOrdemController.CarregarDadosPedidosOrdem(PedidosEntregaMemTable, LEOrdemEntrega.Text);
    if LEStatus.Text = cStatusPendenteOrdemEntrega then
    begin
      BBInc.Enabled := True;
      BBExc.Enabled := True;
    end;
  end;
end;

procedure TFDadosPedidosEntrega.pAtualizaOrdem;
begin
  FEntregadorController.CarregarDadosEntregadors(EntregadorMemTable, '', '');
  FPedidosOrdemController.CarregarDadosRotas(PedidosDispMemTable, '');
  pAtualizaPedidosOrdem;
end;

end.
