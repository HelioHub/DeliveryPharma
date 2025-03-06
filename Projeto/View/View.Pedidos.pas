unit View.Pedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, Data.DB, Vcl.Mask, System.UITypes,
  Interfaces.IPedido, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.StorageBin,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Menus,
  Controller.PedidoController,
  Controller.ItemPedidoController,
  CXConst, Winapi.ShellAPI, Vcl.ComCtrls;

type
  TFViewPedidos = class(TForm)
    PHead: TPanel;
    PRodape: TPanel;
    PViewPedidos: TPanel;
    BBIncluir: TBitBtn;
    BBAlterar: TBitBtn;
    BBExcluir: TBitBtn;
    BBSair: TBitBtn;
    LNR: TLabel;
    ENR: TEdit;
    DBGView: TDBGrid;
    DSViewPedidos: TDataSource;
    PFiltrar: TPanel;
    LEFiltroNumeroPedido: TLabeledEdit;
    LEFiltroNomeCliente: TLabeledEdit;
    BBAtualizar: TBitBtn;
    PViewItensPedido: TPanel;
    DBGViewItens: TDBGrid;
    PedidosMemTable: TFDMemTable;
    PMOptions: TPopupMenu;
    PMAtualizarItensdoPedido: TMenuItem;
    N1: TMenuItem;
    PMValorTotaldoPedido: TMenuItem;
    DSItensPedido: TDataSource;
    ItensMemTable: TFDMemTable;
    PedidosMemTableNumeroPedidos: TIntegerField;
    PedidosMemTableClientePedidos: TIntegerField;
    PedidosMemTableNomeClientes: TStringField;
    ItensMemTableidItensPedido: TIntegerField;
    ItensMemTablePedidoItensPedido: TIntegerField;
    ItensMemTableProdutoItensPedido: TIntegerField;
    N2: TMenuItem;
    PMProdutoMaisVendido: TMenuItem;
    BBProdutoMaisVendido: TBitBtn;
    ItensMemTableDescricaoProdutos: TStringField;
    BBRelatorio: TBitBtn;
    DTPDEIni: TDateTimePicker;
    LDT: TLabel;
    Label1: TLabel;
    DTPDEFin: TDateTimePicker;
    SBClearPedido: TSpeedButton;
    SBClearNomeCliente: TSpeedButton;
    BBGrafico: TBitBtn;
    PMGrafico: TPopupMenu;
    MIGraficoBarra: TMenuItem;
    MenuItem2: TMenuItem;
    MIGraficoPizza: TMenuItem;
    MenuItem4: TMenuItem;
    PedidosMemTableDataEmissaoPedidos: TSQLTimeStampField;
    PedidosMemTableValorTotalPedidos: TFMTBCDField;
    ItensMemTableQuantidadeItensPedido: TFMTBCDField;
    ItensMemTableVlrUnitarioItensPedido: TFMTBCDField;
    ItensMemTableVlrTotalItensPedido: TFMTBCDField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BBSairClick(Sender: TObject);
    procedure BBIncluirClick(Sender: TObject);
    procedure DBGViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGViewDblClick(Sender: TObject);
    procedure BBExcluirClick(Sender: TObject);
    procedure BBAtualizarClick(Sender: TObject);
    procedure BBAlterarClick(Sender: TObject);
    procedure PMValorTotaldoPedidoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DSViewPedidosDataChange(Sender: TObject; Field: TField);
    procedure PMAtualizarItensdoPedidoClick(Sender: TObject);
    procedure PMProdutoMaisVendidoClick(Sender: TObject);
    procedure BBProdutoMaisVendidoClick(Sender: TObject);
    procedure BBRelatorioClick(Sender: TObject);
    procedure SBClearPedidoClick(Sender: TObject);
    procedure SBClearNomeClienteClick(Sender: TObject);
    procedure BBGraficoClick(Sender: TObject);
    procedure MIGraficoBarraClick(Sender: TObject);
    procedure MIGraficoPizzaClick(Sender: TObject);
  private
    { Private declarations }
    FPedidoController: TPedidoController;
    FItemPedidoController: TItemPedidoController;

    procedure TratarDelete;
    procedure pCRUD(pAcao: TAcao);
    procedure pAtualizacao;
    procedure CallProdutoMaisVendido;
    procedure pValorTotaldoPedido;
    procedure GerarEExibirRelatorio;
    procedure GerarGraficoHTML;
    procedure GerarGraficoPizzaHTML;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

var
  FViewPedidos: TFViewPedidos;

implementation

{$R *.dfm}

uses View.Dados.Pedidos, View.Show.MaisVendido, Utils.DMUtils;

constructor TFViewPedidos.Create(AOwner: TComponent);
begin
  inherited;
  FPedidoController := TPedidoController.Create;
  FItemPedidoController := TItemPedidoController.Create;
end;

destructor TFViewPedidos.Destroy;
begin
  FPedidoController.Free;
  FItemPedidoController.Free;
  inherited;
end;

procedure TFViewPedidos.FormShow(Sender: TObject);
begin
  DTPDEIni.DateTime := Date-1;
  DTPDEFin.DateTime := Date;
  pAtualizacao;
end;

procedure TFViewPedidos.BBIncluirClick(Sender: TObject);
begin
  pCRUD(acIncluir);
end;

procedure TFViewPedidos.BBAlterarClick(Sender: TObject);
begin
  pCRUD(acAlterar);
end;

procedure TFViewPedidos.DBGViewDblClick(Sender: TObject);
begin
  BBAlterar.Click;
end;

procedure TFViewPedidos.BBExcluirClick(Sender: TObject);
begin
  TratarDelete;
end;

procedure TFViewPedidos.BBGraficoClick(Sender: TObject);
var
  P: TPoint;
begin
  // Obter a posi��o do bot�o na tela
  P := BBGrafico.ClientToScreen(Point(0, BBGrafico.Height));

  // Exibir o PopupMenu na posi��o do bot�o
  PMGrafico.Popup(P.X, P.Y);
end;

procedure TFViewPedidos.BBAtualizarClick(Sender: TObject);
begin
  pAtualizacao;
end;

procedure TFViewPedidos.DBGViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Verifica se a tecla DELETE foi pressionada
  if Key = VK_DELETE then
  begin
    TratarDelete;
    Key := 0; // Evita que o DBGrid processe o DELETE automaticamente
  end
  else if key = VK_RETURN then
    pCRUD(acAlterar);
end;

procedure TFViewPedidos.DSViewPedidosDataChange(Sender: TObject; Field: TField);
begin
  FItemPedidoController.CarregarDadosItensPedido(ItensMemTable,
    DSViewPedidos.DataSet.FieldByName('NumeroPedidos').AsString);
end;

procedure TFViewPedidos.PMAtualizarItensdoPedidoClick(Sender: TObject);
begin
  pAtualizacao;
end;

procedure TFViewPedidos.PMValorTotaldoPedidoClick(Sender: TObject);
begin
  pValorTotaldoPedido;
end;

procedure TFViewPedidos.PMProdutoMaisVendidoClick(Sender: TObject);
begin
  CallProdutoMaisVendido;
end;

procedure TFViewPedidos.BBProdutoMaisVendidoClick(Sender: TObject);
begin
  CallProdutoMaisVendido;
end;

procedure TFViewPedidos.BBRelatorioClick(Sender: TObject);
begin
  GerarEExibirRelatorio;
end;

procedure TFViewPedidos.GerarEExibirRelatorio;
var
  HTML: string;
  FileName: string;
begin
   HTML := FItemPedidoController.GerarRelatorioHTML(DTPDEIni.Date, DTPDEFin.Date);

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
end;

procedure TFViewPedidos.GerarGraficoHTML;
var
  HTML: string;
  FileName: string;
begin
   HTML := FItemPedidoController.GerarGraficoHTML('');

  // Salva o HTML em um arquivo tempor�rio
  FileName := ExtractFilePath(Application.ExeName) + 'grafico_maisvendido.html';
  with TStringList.Create do
  try
    Text := HTML;
    SaveToFile(FileName);
  finally
    Free;
  end;

  // Abre o arquivo no navegador padr�o
  ShellExecute(0, 'open', PChar(FileName), nil, nil, SW_SHOWNORMAL);
end;

procedure TFViewPedidos.GerarGraficoPizzaHTML;
var
  HTML: string;
  FileName: string;
begin
   HTML := FItemPedidoController.GerarGraficoPizzaHTML('');

  // Salva o HTML em um arquivo tempor�rio
  FileName := ExtractFilePath(Application.ExeName) + 'graficopizza_maisvendido.html';
  with TStringList.Create do
  try
    Text := HTML;
    SaveToFile(FileName);
  finally
    Free;
  end;

  // Abre o arquivo no navegador padr�o
  ShellExecute(0, 'open', PChar(FileName), nil, nil, SW_SHOWNORMAL);
end;

procedure TFViewPedidos.MIGraficoBarraClick(Sender: TObject);
begin
  GerarGraficoHTML;
end;

procedure TFViewPedidos.MIGraficoPizzaClick(Sender: TObject);
begin
  GerarGraficoPizzaHTML;
end;

procedure TFViewPedidos.pCRUD(pAcao: TAcao);
var
  FormPedido: TFDadosPedidos;
begin
  if (DSViewPedidos.DataSet.FieldByName('NumeroPedidos').IsNull) and
     (pAcao <> acIncluir) then
  begin
    Beep;
    ShowMessage('Selecione um registro v�lido '+cEOL+'para efetuar opera��o desejada!');
    Exit;
  end;

  if (pAcao = acExcluir) then
  begin
    if FPedidoController.ExcluirPedido(
       DSViewPedidos.DataSet.FieldByName('NumeroPedidos').AsInteger) then
      ShowMessage('Pedido exclu�do com sucesso!')
    else
      ShowMessage('Erro ao excluir pedido.');
  end
  else
  begin
    FormPedido := TFDadosPedidos.Create(Application);
    if (pAcao = acIncluir) then
    begin
      FormPedido.Caption := FormPedido.Caption + '-' + cAcaoIncluir;
      FormPedido.LENumeroPedido.Clear;
      FormPedido.DTPDataEmissao.DateTime := Now;
    end
    else
    begin
      FormPedido.Caption := FormPedido.Caption + '-' + cAcaoAlterar;
      FormPedido.LENumeroPedido.Text := DSViewPedidos.DataSet.FieldByName('NumeroPedidos').AsString;
      FormPedido.DTPDataEmissao.DateTime := DSViewPedidos.DataSet.FieldByName('DataEmissaoPedidos').AsDateTime;
      FormPedido.LECodigoCliente.Text := DSViewPedidos.DataSet.FieldByName('ClientePedidos').AsString;
      FormPedido.EDescCliente.Text := DSViewPedidos.DataSet.FieldByName('NomeClientes').AsString;
      FormPedido.LETotalPedido.Text := DSViewPedidos.DataSet.FieldByName('ValorTotalPedidos').AsString;
    end;
    FormPedido.ShowModal;
  end;
  pAtualizacao;
end;

procedure TFViewPedidos.TratarDelete;
begin
  // Exibe uma mensagem de confirma��o antes de deletar o registro
  if MessageDlg('Deseja realmente Cancelar(Exclu�ndo) este Pedido '+
     DSViewPedidos.DataSet.FieldByName('NumeroPedidos').AsString+' e seus Itens?',
     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    pCRUD(acExcluir);
end;

procedure TFViewPedidos.pAtualizacao;
begin
  FPedidoController.CarregarDadosPedidos(PedidosMemTable,
    LEFiltroNumeroPedido.Text,
    LEFiltroNomeCliente.Text,
    ENR.Text,
    DTPDEIni.Date,
    DTPDEFin.Date);
end;

procedure TFViewPedidos.pValorTotaldoPedido;
var
  IdPedido: Integer;
  TotalItens: Double;
begin
  // Obt�m o ID do pedido
  IdPedido := DSViewPedidos.DataSet.FieldByName('NumeroPedidos').AsInteger;

  if IdPedido > cZero then
  begin
    // Calcula o total dos itens do pedido
    TotalItens := FItemPedidoController.CalcularTotalItens(IdPedido);
    ShowMessage('Valor Total do Pedido '+
                  DSViewPedidos.DataSet.FieldByName('NumeroPedidos').AsString+
                    ': ' + FormatFloat('###,##0.00',TotalItens));
  end
  else
    ShowMessage('Id do Pedido inv�lido.');
end;

procedure TFViewPedidos.SBClearNomeClienteClick(Sender: TObject);
begin
  LEFiltroNomeCliente.Clear;
end;

procedure TFViewPedidos.SBClearPedidoClick(Sender: TObject);
begin
  LEFiltroNumeroPedido.Clear;
end;

procedure TFViewPedidos.CallProdutoMaisVendido;
begin
  FViewMaisVendido := TFViewMaisVendido.Create(Application);
  FViewMaisVendido.ShowModal;
end;

procedure TFViewPedidos.BBSairClick(Sender: TObject);
begin
  DSViewPedidos.DataSet.Close;
  Close;
end;

procedure TFViewPedidos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := CaFree;
end;

end.
