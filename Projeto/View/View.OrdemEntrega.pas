unit View.OrdemEntrega;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Mask, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.StorageBin, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.DBCtrls, Utils.Consts, Controller.OrdemEntregaController,
  Controller.PedidosEntregaController, Winapi.ShellAPI;

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
    procedure BBAlterarClick(Sender: TObject);
    procedure BBSairClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BBExcluirClick(Sender: TObject);
    procedure BBAtualizarClick(Sender: TObject);
    procedure SBClearOrdemClick(Sender: TObject);
    procedure SBClearNomeClienteClick(Sender: TObject);
    procedure DSViewOrdensDataChange(Sender: TObject; Field: TField);
    procedure BBOrdensClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    FOrdemEntregaController: TOrdemEntregaController;
    FPedidosEntregaController: TPedidosEntregaController;

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

uses View.Dados.PedidosEntrega;

{ TFViewOrdemEntrega }

procedure TFViewOrdemEntrega.BBAlterarClick(Sender: TObject);
begin
  pCRUD(acAlterar);
end;

procedure TFViewOrdemEntrega.BBAtualizarClick(Sender: TObject);
begin
  pAtualizacao;
end;

procedure TFViewOrdemEntrega.BBExcluirClick(Sender: TObject);
begin
  pCRUD(acExcluir);
end;

procedure TFViewOrdemEntrega.BBIncluirClick(Sender: TObject);
begin
  pCRUD(acIncluir);
end;

procedure TFViewOrdemEntrega.BBOrdensClick(Sender: TObject);
var
  HTML: string;
  FileName: string;
begin
  if (DSViewOrdens.DataSet.FieldByName('idOrdemEntrega').IsNull) then
  begin
    beep;
    ShowMessage('Sem Ordem de Entrega Selecionada!');
    Exit;
  end;
  if (DSViewOrdens.DataSet.FieldByName('StatusOrdemEntrega').AsInteger > cZero) then
  begin
    beep;
    ShowMessage('Ordem de Entrega j� Enviada!');
    Exit;
  end;
  Beep;
  ShowMessage('Aten��o!! Ap�s o Envio o Pedido n�o ser� mais permitido Alterar');

  HTML := FOrdemEntregaController.GerarOrdemEntregaHTML(DSViewOrdens.DataSet.FieldByName('idOrdemEntrega').AsString);

  // Salva o HTML em um arquivo tempor�rio
  FileName := ExtractFilePath(Application.ExeName) + 'relatorio_pedido.html';
  with TStringList.Create do
  try
    Text := HTML;
    SaveToFile(FileName);
  finally
    Free;
  end;

  // Abre o arquivo no navegador padr�o
  ShellExecute(0, 'open', PChar(FileName), nil, nil, SW_SHOWNORMAL);

  FOrdemEntregaController.SalvarOrdemEmProcesso(DSViewOrdens.DataSet.FieldByName('idOrdemEntrega').AsString, cProcessoSaida);
end;

procedure TFViewOrdemEntrega.BBSairClick(Sender: TObject);
begin
  DSViewOrdens.DataSet.Close;
  Close;
end;

procedure TFViewOrdemEntrega.BitBtn1Click(Sender: TObject);
begin
  if (DSViewOrdens.DataSet.FieldByName('StatusOrdemEntrega').AsInteger > cZero+1) then
  begin
    beep;
    ShowMessage('Ordem de Entrega j� Retornada!');
    Exit;
  end;

  FOrdemEntregaController.SalvarOrdemEmProcesso(DSViewOrdens.DataSet.FieldByName('idOrdemEntrega').AsString, cProcessoRetorno);
end;

constructor TFViewOrdemEntrega.Create(AOwner: TComponent);
begin
  inherited;
  FOrdemEntregaController := TOrdemEntregaController.Create;
  FPedidosEntregaController := TPedidosEntregaController.Create;
end;

destructor TFViewOrdemEntrega.Destroy;
begin
  FOrdemEntregaController.Free;
  FPedidosEntregaController.Free;
  inherited;
end;

procedure TFViewOrdemEntrega.DSViewOrdensDataChange(Sender: TObject;
  Field: TField);
begin
  FPedidosEntregaController.CarregarDadosPedidosOrdem(PedidosMemTable,
    DSViewOrdens.DataSet.FieldByName('idOrdemEntrega').AsString);
end;

procedure TFViewOrdemEntrega.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := CaFree;
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
      ShowMessage('Ordem de Entrega exclu�da com sucesso!')
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
      FormPedidosEntrega.LEStatus.Text := cStatusPendenteOrdemEntrega;
    end
    else
    begin
      if DSViewOrdens.DataSet.FieldByName('Status').AsString <> cStatusPendenteOrdemEntrega then
      begin
        FormPedidosEntrega.BBGravar.Enabled := False;
        FormPedidosEntrega.BBGeracaoAutomatica.Enabled := False;
        FormPedidosEntrega.BBInc.Enabled := False;
        FormPedidosEntrega.BBExc.Enabled := False;
        ShowMessage('Altera��o somente poss�vel para Ordem de Entrega '+cStatusPendenteOrdemEntrega+'!');
      end;
      FormPedidosEntrega.Caption := FormPedidosEntrega.Caption + '-' + cAcaoAlterar;
      FormPedidosEntrega.LEOrdemEntrega.Text := DSViewOrdens.DataSet.FieldByName('idOrdemEntrega').AsString;
      FormPedidosEntrega.DTPDataEmissao.DateTime := DSViewOrdens.DataSet.FieldByName('EmissaoOrdemEntrega').AsDateTime;
      FormPedidosEntrega.LECodigoEntregador.Text := DSViewOrdens.DataSet.FieldByName('EntregadorOrdenEntrega').AsString;
      FormPedidosEntrega.DBLCBEntregador.KeyValue := DSViewOrdens.DataSet.FieldByName('EntregadorOrdenEntrega').AsInteger;
      FormPedidosEntrega.DTPSaida.DateTime := DSViewOrdens.DataSet.FieldByName('SaidaOrdemEntrega').AsDateTime;
      FormPedidosEntrega.DTPChegada.DateTime := DSViewOrdens.DataSet.FieldByName('ChegadaOrdemEntrega').AsDateTime;
      FormPedidosEntrega.LEStatus.Text := DSViewOrdens.DataSet.FieldByName('Status').AsString;
      FormPedidosEntrega.MObsOrdem.Text := DSViewOrdens.DataSet.FieldByName('OBSOrdemEntrega').AsString;
    end;
    FormPedidosEntrega.ShowModal;
  end;
  pAtualizacao;
end;

procedure TFViewOrdemEntrega.SBClearNomeClienteClick(Sender: TObject);
begin
  LEFiltroNomeEntregador.Clear;
end;

procedure TFViewOrdemEntrega.SBClearOrdemClick(Sender: TObject);
begin
  LEFiltroIdOrdem.Clear;
end;

end.
