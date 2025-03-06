unit Model.Item.RegraAtacado;

interface

uses Interfaces.Visitor;

Type
  TModelItemRegraAtacado = class(TInterfacedObject, iItemRegras, iVisitor)
    private
      FVisit : iItem;
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iItemRegras;
      function PrecoAPrazo : Currency;
      function PrecoAVista : Currency;
      function Visit(Value : iItem) : iItemRegras; //Visitante
      function Visitor: iVisitor;
  end;

implementation

const
  cDescontoItemPrecoAVista = 0.7;
  cDescontoItemPrecoAPrazo = 0.85;

{TModelItemRegraAtacado}

constructor TModelItemRegraAtacado.Create;
begin

end;

destructor TModelItemRegraAtacado.Destroy;
begin

  inherited;
end;

class function TModelItemRegraAtacado.New : iItemRegras;
begin
  Result := Self.Create;
end;

function TModelItemRegraAtacado.PrecoAVista: Currency;
begin
  Result := (FVisit.PrecoUnitario * cDescontoItemPrecoAvista);
end;

function TModelItemRegraAtacado.PrecoAPrazo: Currency;
begin
  Result := (FVisit.PrecoUnitario * cDescontoItemPrecoAPrazo);
end;

function TModelItemRegraAtacado.Visit(Value: iItem): iItemRegras;
begin
  FVisit := Value;
  Result := Self;
end;

function TModelItemRegraAtacado.Visitor: iVisitor;
begin
  Result := Self;
end;

end.

