unit DeliveryPharma;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Winapi.ShellApi;

type
  TFDeliveryPharma = class(TForm)
    BBCadPedidos: TBitBtn;
    BBFechar: TBitBtn;
    PHost: TPanel;
    EHostName: TEdit;
    LWK: TLabel;
    BExecFolder: TButton;
    BBCadClientes: TBitBtn;
    BBOrdemEntrega: TBitBtn;
    procedure BBFecharClick(Sender: TObject);
    procedure LWKClick(Sender: TObject);
    procedure BBCadPedidosClick(Sender: TObject);
    procedure BExecFolderClick(Sender: TObject);
    procedure BBCadClientesClick(Sender: TObject);
    procedure BBOrdemEntregaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FDeliveryPharma: TFDeliveryPharma;

implementation

{$R *.dfm}

uses View.Show.MaisVendido, View.Show.Atencao, Utils.Consts, View.Pedidos,
  Utils.DMUtils, View.Clientes, View.OrdemEntrega;


procedure TFDeliveryPharma.BBCadClientesClick(Sender: TObject);
begin
  FViewClientes := TFViewClientes.Create(Application);
  FViewClientes.ShowModal;
end;

procedure TFDeliveryPharma.BBCadPedidosClick(Sender: TObject);
begin
  FViewPedidos := TFViewPedidos.Create(Application);
  FViewPedidos.ShowModal;
end;

procedure TFDeliveryPharma.BBFecharClick(Sender: TObject);
begin
  FViewAtencao := TFViewAtencao.Create(Application);
  FViewAtencao.ShowModal;
  Application.Terminate;
end;

procedure TFDeliveryPharma.BBOrdemEntregaClick(Sender: TObject);
begin
  FViewOrdemEntrega := TFViewOrdemEntrega.Create(Application);
  FViewOrdemEntrega.ShowModal;
end;

procedure TFDeliveryPharma.BExecFolderClick(Sender: TObject);
var
  ExecutablePath, ExecutableDir: string;
begin
  ExecutablePath := ParamStr(0); // Obt�m o caminho completo do execut�vel
  ExecutableDir := ExtractFileDir(ExecutablePath); // Extrai o diret�rio do caminho
  ShowMessage('O execut�vel est� sendo executado na pasta: ' + ExecutableDir);
end;

procedure TFDeliveryPharma.LWKClick(Sender: TObject);
begin
  ShellExecute(Handle, nil, PChar(curlWK), nil, nil, SW_SHOWNORMAL);
end;

end.
