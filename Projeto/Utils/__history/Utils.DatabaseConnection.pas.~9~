unit Utils.DatabaseConnection;

interface

uses
  FireDAC.Comp.Client, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  System.SysUtils, Utils.IniFileHelper;

type
  TDatabaseConnection = class
  private
    FConnection: TFDConnection;
    FIniFileHelper: TIniFileHelper;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink; // Componente para registrar o driver do Firebird

    function GetConnection: TFDConnection;
  public
    constructor Create;
    destructor Destroy; override;

    property Connection: TFDConnection read GetConnection;
  end;

implementation

{ TDatabaseConnection }

uses CXConst;

constructor TDatabaseConnection.Create;
var
  IniFileName : String;
begin
  IniFileName := cPATH_INI;

  // Carrega os parâmetros do arquivo .INI
  FIniFileHelper := TIniFileHelper.Create(IniFileName);
  FDPhysFBDriverLink1 := TFDPhysFBDriverLink.Create(nil); // Cria o componente
  // Configura o caminho da DLL do Firebird (fbclient.dll)
  FDPhysFBDriverLink1.VendorLib := FIniFileHelper.ReadString('Database', 'DLLPath', 'fbclient.dll');

  FConnection := TFDConnection.Create(nil);
  try
    // Configurações básicas da conexão
    FConnection.DriverName := 'FB'; // Firebird
    FConnection.Params.Database := FIniFileHelper.ReadString('Database', 'Database', 'C:\DeliveryPharma\BD\dbDeliveryPharma.fdb');
    FConnection.Params.UserName := FIniFileHelper.ReadString('Database', 'UserName', 'SYSDBA'); // Usuário padrão do Firebird
    FConnection.Params.Password := FIniFileHelper.ReadString('Database', 'Password', 'masterkey'); // Senha padrão do Firebird

    // Parâmetros adicionais
    FConnection.Params.Add('Server=' + FIniFileHelper.ReadString('Database', 'Server', 'localhost')); // Servidor
    FConnection.Params.Add('Port=' + FIniFileHelper.ReadString('Database', 'Port', '3050')); // Porta padrão do Firebird

    // Configura o caminho da DLL do Firebird (fbclient.dll)
    FConnection.Params.Add('VendorLib=' + FIniFileHelper.ReadString('Database', 'DLLPath', 'fbclient.dll'));

    // Conecta ao banco de dados
    FConnection.Connected := True;
  except
    on E: Exception do
      raise Exception('Erro ao conectar ao Firebird: ' + E.Message);
  end;

end;

destructor TDatabaseConnection.Destroy;
begin
  FConnection.Connected := False;
  FConnection.Free;
  FIniFileHelper.Free;
  FDPhysFBDriverLink1.Free;
  inherited;
end;

function TDatabaseConnection.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;

end.
