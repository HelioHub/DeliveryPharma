object FViewOrdemEntrega: TFViewOrdemEntrega
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Ordens de Entrega'
  ClientHeight = 558
  ClientWidth = 879
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 13
  object PViewPedidos: TPanel
    Left = 0
    Top = 116
    Width = 879
    Height = 264
    Align = alClient
    TabOrder = 0
    object DBGView: TDBGrid
      Left = 1
      Top = 1
      Width = 877
      Height = 213
      Hint = 'Duplo Click para Alterar a Ordem...'
      Align = alClient
      DataSource = DSViewOrdens
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Alignment = taCenter
          Color = clWheat
          Expanded = False
          FieldName = 'idOrdemEntrega'
          Title.Alignment = taCenter
          Title.Caption = 'Ordem de Entrega'
          Width = 95
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'EmissaoOrdemEntrega'
          Title.Alignment = taCenter
          Title.Caption = 'Data de Emiss'#227'o'
          Width = 136
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'EntregadorOrdenEntrega'
          Title.Alignment = taCenter
          Title.Caption = 'Id'
          Width = 27
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NomeEntregador'
          Title.Caption = 'Entregador'
          Width = 171
          Visible = True
        end
        item
          Alignment = taCenter
          Color = clWheat
          Expanded = False
          FieldName = 'SaidaOrdemEntrega'
          Title.Alignment = taCenter
          Title.Caption = 'Data de Sa'#237'da'
          Width = 143
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'ChegadaOrdemEntrega'
          Title.Alignment = taCenter
          Title.Caption = 'Data Chegada'
          Width = 122
          Visible = True
        end
        item
          Color = 8454143
          Expanded = False
          FieldName = 'Status'
          Width = 139
          Visible = True
        end>
    end
    object DBREObs: TDBRichEdit
      Left = 1
      Top = 214
      Width = 877
      Height = 49
      Align = alBottom
      Color = 16777088
      DataField = 'OBSOrdemEntrega'
      DataSource = DSViewOrdens
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ReadOnly = True
      TabOrder = 1
    end
  end
  object PHead: TPanel
    Left = 0
    Top = 0
    Width = 879
    Height = 44
    Align = alTop
    TabOrder = 1
    DesignSize = (
      879
      44)
    object LNR: TLabel
      Left = 765
      Top = 16
      Width = 73
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'N'#186' Registros:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 527
    end
    object BBIncluir: TBitBtn
      Left = 3
      Top = 8
      Width = 63
      Height = 30
      Hint = 'Incluir Pedido'
      Caption = '&Incluir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ImageIndex = 0
      Images = DMUtils.ILImagensSystem
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = BBIncluirClick
    end
    object BBAlterar: TBitBtn
      Left = 72
      Top = 8
      Width = 63
      Height = 30
      Hint = 'Alterar Pedido'
      Caption = '&Alterar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ImageIndex = 1
      Images = DMUtils.ILImagensSystem
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = BBAlterarClick
    end
    object BBExcluir: TBitBtn
      Left = 136
      Top = 8
      Width = 63
      Height = 30
      Hint = 'Cancela o Pedido e seus Itens deletandos'
      Caption = '&Excluir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ImageIndex = 2
      Images = DMUtils.ILImagensSystem
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = BBExcluirClick
    end
    object BBSair: TBitBtn
      Left = 200
      Top = 8
      Width = 63
      Height = 30
      Hint = 'Fechar tela de Pedidos'
      Cancel = True
      Caption = '&Fechar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ImageIndex = 8
      Images = DMUtils.ILImagensSystem
      NumGlyphs = 2
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = BBSairClick
    end
    object ENR: TEdit
      Left = 840
      Top = 13
      Width = 33
      Height = 21
      Hint = 'Limite de registros da Consulta. Colocando zero desconsidera.'
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      NumbersOnly = True
      ParentFont = False
      TabOrder = 5
      Text = '100'
    end
    object BBOrdens: TBitBtn
      Left = 385
      Top = 8
      Width = 152
      Height = 30
      Hint = 'Rota de Entrega Considerando Prioridade do Produto.'
      Cancel = True
      Caption = 'Sa'#237'da da Entrega'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ImageIndex = 4
      Images = DMUtils.ILImagensSystem
      NumGlyphs = 2
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
    end
    object BitBtn1: TBitBtn
      Left = 543
      Top = 8
      Width = 152
      Height = 30
      Hint = 'Estabalece o Retorno da Rota.'
      Cancel = True
      Caption = 'Retorno da Rota'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ImageIndex = 4
      Images = DMUtils.ILImagensSystem
      NumGlyphs = 2
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
    end
  end
  object PFiltrar: TPanel
    Left = 0
    Top = 44
    Width = 879
    Height = 72
    Align = alTop
    TabOrder = 2
    DesignSize = (
      879
      72)
    object LDT: TLabel
      Left = 28
      Top = 51
      Width = 133
      Height = 13
      Caption = 'Filtrar por Data de Emiss'#227'o:'
    end
    object Label1: TLabel
      Left = 254
      Top = 52
      Width = 6
      Height = 13
      Caption = 'a'
    end
    object SBClearOrdem: TSpeedButton
      Left = 212
      Top = 1
      Width = 23
      Height = 22
      Hint = 'Limpar Ordem de Entrega'
      ImageIndex = 7
      Images = DMUtils.ILImagensSystem
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = SBClearOrdemClick
    end
    object SBClearNomeCliente: TSpeedButton
      Left = 385
      Top = 25
      Width = 23
      Height = 22
      Hint = 'Limpar Nome do Entregador'
      ImageIndex = 7
      Images = DMUtils.ILImagensSystem
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = SBClearNomeClienteClick
    end
    object LEFiltroIdOrdem: TLabeledEdit
      Left = 164
      Top = 3
      Width = 46
      Height = 21
      EditLabel.Width = 146
      EditLabel.Height = 21
      EditLabel.Caption = 'Filtrar por Ordem de Entregar:'
      LabelPosition = lpLeft
      NumbersOnly = True
      TabOrder = 0
      Text = ''
    end
    object LEFiltroNomeEntregador: TLabeledEdit
      Left = 164
      Top = 25
      Width = 219
      Height = 21
      EditLabel.Width = 153
      EditLabel.Height = 21
      EditLabel.Caption = 'Filtrar por Nome do Entregador:'
      LabelPosition = lpLeft
      TabOrder = 1
      Text = ''
    end
    object BBAtualizar: TBitBtn
      Left = 788
      Top = 5
      Width = 80
      Height = 61
      Anchors = [akTop, akRight]
      Caption = 'Filtra&r'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ImageIndex = 3
      Images = DMUtils.ILImagensSystem
      ParentFont = False
      TabOrder = 4
      OnClick = BBAtualizarClick
    end
    object DTPDEIni: TDateTimePicker
      Left = 164
      Top = 47
      Width = 85
      Height = 21
      Date = 45686.000000000000000000
      Time = 0.829977719906310100
      TabOrder = 2
    end
    object DTPDEFin: TDateTimePicker
      Left = 264
      Top = 47
      Width = 85
      Height = 21
      Date = 45686.000000000000000000
      Time = 0.829977719906310100
      TabOrder = 3
    end
    object RGStatus: TRadioGroup
      Left = 424
      Top = 2
      Width = 321
      Height = 65
      Caption = 'Status'
      Columns = 3
      ItemIndex = 4
      Items.Strings = (
        'Pendente'
        'Em Andamento'
        'Entregue Parcial'
        'Entregue Total'
        'Todos')
      TabOrder = 5
    end
  end
  object PRodape: TPanel
    Left = 0
    Top = 380
    Width = 879
    Height = 24
    Align = alBottom
    Alignment = taLeftJustify
    Caption = '  Pedidos da Ordem:'
    TabOrder = 3
  end
  object PViewItensPedido: TPanel
    Left = 0
    Top = 404
    Width = 879
    Height = 154
    Align = alBottom
    TabOrder = 4
    object DBGViewItens: TDBGrid
      Left = 1
      Top = 1
      Width = 877
      Height = 103
      Align = alClient
      DataSource = DSPedidos
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'idPedidosEntrega'
          Title.Alignment = taCenter
          Title.Caption = 'Id'
          Width = 31
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'OrdemEntregaPedidosEntrega'
          Title.Alignment = taCenter
          Title.Caption = 'Ordem'
          Width = 46
          Visible = True
        end
        item
          Alignment = taCenter
          Color = clSnow
          Expanded = False
          FieldName = 'PedidoPedidosEntrega'
          Title.Alignment = taCenter
          Title.Caption = 'Pedido'
          Width = 61
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'CodigoClientes'
          Title.Alignment = taCenter
          Title.Caption = 'Cliente'
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NomeClientes'
          Title.Caption = 'Nome do Cliente'
          Width = 219
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'BairroClientes'
          Title.Caption = 'Bairro do Cliente'
          Width = 173
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ValorTotalPedidos'
          Title.Alignment = taRightJustify
          Title.Caption = 'Valor do Pedido'
          Width = 85
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Status'
          Width = 170
          Visible = True
        end>
    end
    object DBREObsPedido: TDBRichEdit
      Left = 1
      Top = 104
      Width = 877
      Height = 49
      Align = alBottom
      Color = 14145535
      DataField = 'OBSPedidosEntrega'
      DataSource = DSPedidos
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      TabOrder = 1
    end
  end
  object OrdensEntregaMemTable: TFDMemTable
    FieldDefs = <>
    CachedUpdates = True
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvPersistent, rvSilentMode]
    ResourceOptions.Persistent = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 424
    Top = 160
    object OrdensEntregaMemTableidOrdemEntrega: TIntegerField
      FieldName = 'idOrdemEntrega'
    end
    object OrdensEntregaMemTableEmissaoOrdemEntrega: TSQLTimeStampField
      FieldName = 'EmissaoOrdemEntrega'
    end
    object OrdensEntregaMemTableEntregadorOrdenEntrega: TIntegerField
      FieldName = 'EntregadorOrdenEntrega'
    end
    object OrdensEntregaMemTableNomeEntregador: TStringField
      FieldName = 'NomeEntregador'
      Size = 50
    end
    object OrdensEntregaMemTableSaidaOrdemEntrega: TSQLTimeStampField
      FieldName = 'SaidaOrdemEntrega'
    end
    object OrdensEntregaMemTableChegadaOrdemEntrega: TSQLTimeStampField
      FieldName = 'ChegadaOrdemEntrega'
    end
    object OrdensEntregaMemTableStatusOrdemEntrega: TStringField
      FieldName = 'Status'
      Size = 30
    end
    object OrdensEntregaMemTableOBSOrdemEntrega: TStringField
      FieldName = 'OBSOrdemEntrega'
      Size = 1000
    end
  end
  object DSViewOrdens: TDataSource
    DataSet = OrdensEntregaMemTable
    OnDataChange = DSViewOrdensDataChange
    Left = 307
    Top = 160
  end
  object DSPedidos: TDataSource
    DataSet = PedidosMemTable
    Left = 307
    Top = 232
  end
  object PedidosMemTable: TFDMemTable
    FieldDefs = <>
    CachedUpdates = True
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvPersistent, rvSilentMode]
    ResourceOptions.Persistent = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 424
    Top = 232
    object PedidosMemTableidPedidosEntrega: TIntegerField
      FieldName = 'idPedidosEntrega'
    end
    object PedidosMemTableOrdemEntregaPedidosEntrega: TIntegerField
      FieldName = 'OrdemEntregaPedidosEntrega'
    end
    object PedidosMemTablePedidoPedidosEntrega: TIntegerField
      FieldName = 'PedidoPedidosEntrega'
    end
    object PedidosMemTableCodigoClientes: TIntegerField
      FieldName = 'CodigoClientes'
    end
    object PedidosMemTableNomeClientes: TStringField
      FieldName = 'NomeClientes'
      Size = 80
    end
    object PedidosMemTableBairroClientes: TStringField
      FieldName = 'BairroClientes'
      Size = 50
    end
    object PedidosMemTableValorTotalPedidos: TFMTBCDField
      FieldName = 'ValorTotalPedidos'
    end
    object PedidosMemTableStatus: TStringField
      FieldName = 'Status'
      Size = 30
    end
    object PedidosMemTableOBSPedidosEntrega: TStringField
      FieldName = 'OBSPedidosEntrega'
      Size = 1000
    end
  end
end
