object FDadosPedidosEntrega: TFDadosPedidosEntrega
  Left = 0
  Top = 0
  Caption = 'Dados Pedidos da Entrega'
  ClientHeight = 546
  ClientWidth = 992
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object PView: TPanel
    Left = 0
    Top = 241
    Width = 992
    Height = 128
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 200
    object DBGView: TDBGrid
      Left = 1
      Top = 1
      Width = 990
      Height = 126
      Hint = 'Duplo Click para Alterar o Item do Pedido...'
      Align = alClient
      Color = 14286847
      DataSource = DSDadosItensPedido
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      Columns = <
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'idItensPedido'
          Title.Alignment = taCenter
          Title.Caption = 'Id'
          Width = 29
          Visible = True
        end
        item
          Alignment = taCenter
          Color = clSnow
          Expanded = False
          FieldName = 'ProdutoItensPedido'
          Title.Caption = 'C'#243'digo Item'
          Width = 67
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DescricaoProdutos'
          Title.Caption = 'Descri'#231#227'o do Item'
          Width = 209
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'QuantidadeItensPedido'
          Title.Alignment = taRightJustify
          Title.Caption = 'Quantidade'
          Width = 74
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'VlrUnitarioItensPedido'
          Title.Alignment = taRightJustify
          Title.Caption = 'Pre'#231'o Venda'
          Width = 90
          Visible = True
        end
        item
          Color = clSnow
          Expanded = False
          FieldName = 'VlrTotalItensPedido'
          Title.Alignment = taRightJustify
          Title.Caption = 'Valor Total'
          Width = 90
          Visible = True
        end>
    end
  end
  object PItensPedido: TPanel
    Left = 0
    Top = 226
    Width = 992
    Height = 15
    Align = alBottom
    Alignment = taLeftJustify
    Caption = 
      '  Pedidos Dispon'#237'veis conforme Prioridade de Entrega dos Produto' +
      's:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    ExplicitTop = 123
    ExplicitWidth = 599
  end
  object PDados: TPanel
    Left = 0
    Top = 0
    Width = 992
    Height = 185
    Align = alClient
    TabOrder = 2
    ExplicitHeight = 249
    object LDT: TLabel
      Left = 39
      Top = 43
      Width = 89
      Height = 15
      Caption = 'Data de Emiss'#227'o:'
    end
    object LT: TLabel
      Left = 197
      Top = 71
      Width = 5
      Height = 15
      Caption = '-'
    end
    object SBF2: TSpeedButton
      Left = 502
      Top = 68
      Width = 147
      Height = 22
      Caption = 'F2 -Concultar Entregador'
      StyleName = 'Windows'
    end
    object Label1: TLabel
      Left = 54
      Top = 129
      Width = 74
      Height = 15
      Caption = 'Data de Sa'#237'da:'
    end
    object Label2: TLabel
      Left = 35
      Top = 153
      Width = 93
      Height = 15
      Caption = 'Data de Chegada:'
    end
    object Label4: TLabel
      Left = 672
      Top = 5
      Width = 93
      Height = 15
      Caption = 'Data de Chegada:'
    end
    object LEOrdemEntrega: TLabeledEdit
      Left = 131
      Top = 11
      Width = 61
      Height = 23
      EditLabel.Width = 99
      EditLabel.Height = 23
      EditLabel.Caption = 'Ordem de Entrega:'
      Enabled = False
      LabelPosition = lpLeft
      NumbersOnly = True
      TabOrder = 0
      Text = ''
    end
    object DTPDataEmissao: TDateTimePicker
      Left = 131
      Top = 40
      Width = 192
      Height = 21
      Date = 45686.000000000000000000
      Format = 'dd/mm/yy hh:mm:ss'
      Time = 0.829977719906310100
      TabOrder = 1
    end
    object LECodigoCliente: TLabeledEdit
      Left = 131
      Top = 67
      Width = 61
      Height = 23
      EditLabel.Width = 61
      EditLabel.Height = 23
      EditLabel.Caption = 'Entregador:'
      LabelPosition = lpLeft
      NumbersOnly = True
      TabOrder = 2
      Text = ''
    end
    object EDescCliente: TEdit
      Left = 206
      Top = 67
      Width = 292
      Height = 23
      Enabled = False
      TabOrder = 3
    end
    object LETotalPedido: TLabeledEdit
      Left = 131
      Top = 97
      Width = 192
      Height = 23
      Alignment = taRightJustify
      EditLabel.Width = 85
      EditLabel.Height = 23
      EditLabel.Caption = 'Total do Pedido:'
      Enabled = False
      LabelPosition = lpLeft
      NumbersOnly = True
      TabOrder = 4
      Text = ''
    end
    object DateTimePicker1: TDateTimePicker
      Left = 131
      Top = 126
      Width = 192
      Height = 21
      Date = 45686.000000000000000000
      Format = 'dd/mm/yy hh:mm:ss'
      Time = 0.829977719906310100
      TabOrder = 5
    end
    object DateTimePicker2: TDateTimePicker
      Left = 131
      Top = 153
      Width = 192
      Height = 21
      Date = 45686.000000000000000000
      Format = 'dd/mm/yy hh:mm:ss'
      Time = 0.829977719906310100
      TabOrder = 6
    end
    object DBRichEdit1: TDBRichEdit
      Left = 672
      Top = 26
      Width = 309
      Height = 148
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      TabOrder = 7
    end
  end
  object POpcoes: TPanel
    Left = 0
    Top = 369
    Width = 992
    Height = 177
    Align = alBottom
    TabOrder = 3
    ExplicitLeft = -1
    ExplicitTop = 328
    DesignSize = (
      992
      177)
    object Label3: TLabel
      Left = 262
      Top = 8
      Width = 402
      Height = 15
      Caption = 
        '*Conforme regra estabelecida somente 5 Pedidos por Ordem de Entr' +
        'ega.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
    end
    object BBInc: TBitBtn
      Left = 10
      Top = 5
      Width = 118
      Height = 23
      Anchors = [akRight]
      Caption = '&Incluir Pedidos'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 0
    end
    object BBExc: TBitBtn
      Left = 134
      Top = 5
      Width = 118
      Height = 23
      Anchors = [akRight]
      Caption = '&Excluir Pedidos'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 1
    end
    object LETotalItens: TLabeledEdit
      Left = 894
      Top = 144
      Width = 97
      Height = 21
      Alignment = taRightJustify
      Color = clRed
      EditLabel.Width = 90
      EditLabel.Height = 21
      EditLabel.Caption = 'Total do Pedido:'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'Tahoma'
      EditLabel.Font.Style = [fsBold]
      EditLabel.ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      LabelPosition = lpLeft
      NumbersOnly = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      Text = ''
    end
    object DBGrid1: TDBGrid
      Left = 1
      Top = 33
      Width = 990
      Height = 143
      Hint = 'Duplo Click para Alterar o Item do Pedido...'
      Align = alBottom
      Color = 14013951
      DataSource = DSDadosItensPedido
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      Columns = <
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'idItensPedido'
          Title.Alignment = taCenter
          Title.Caption = 'Id'
          Width = 29
          Visible = True
        end
        item
          Alignment = taCenter
          Color = clSnow
          Expanded = False
          FieldName = 'ProdutoItensPedido'
          Title.Caption = 'C'#243'digo Item'
          Width = 67
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DescricaoProdutos'
          Title.Caption = 'Descri'#231#227'o do Item'
          Width = 209
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'QuantidadeItensPedido'
          Title.Alignment = taRightJustify
          Title.Caption = 'Quantidade'
          Width = 74
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'VlrUnitarioItensPedido'
          Title.Alignment = taRightJustify
          Title.Caption = 'Pre'#231'o Venda'
          Width = 90
          Visible = True
        end
        item
          Color = clSnow
          Expanded = False
          FieldName = 'VlrTotalItensPedido'
          Title.Alignment = taRightJustify
          Title.Caption = 'Valor Total'
          Width = 90
          Visible = True
        end>
    end
  end
  object PRodape: TPanel
    Left = 0
    Top = 185
    Width = 992
    Height = 41
    Align = alBottom
    TabOrder = 4
    ExplicitLeft = 8
    ExplicitTop = 150
    DesignSize = (
      992
      41)
    object BBSair: TBitBtn
      Left = 906
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight]
      Cancel = True
      Caption = '&Fechar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 1
      ExplicitLeft = 513
    end
    object BBGravar: TBitBtn
      Left = 704
      Top = 6
      Width = 194
      Height = 25
      Hint = 'Grava Pedido e seus Itens.'
      Anchors = [akRight]
      Caption = '&Gravar Ordem de entrega'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ImageIndex = 5
      Images = DMUtils.ILImagensSystem
      NumGlyphs = 2
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
  end
  object DSDadosItensPedido: TDataSource
    DataSet = ItensPedidoMemTable
    Left = 712
    Top = 280
  end
  object ItensPedidoMemTable: TFDMemTable
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
    Left = 856
    Top = 280
    object ItensPedidoMemTableidItensPedido: TIntegerField
      FieldName = 'idItensPedido'
    end
    object ItensPedidoMemTablePedidoItensPedido: TIntegerField
      FieldName = 'PedidoItensPedido'
    end
    object ItensPedidoMemTableProdutoItensPedido: TIntegerField
      FieldName = 'ProdutoItensPedido'
    end
    object ItensPedidoMemTableDescricaoProdutos: TStringField
      FieldName = 'DescricaoProdutos'
      Size = 80
    end
    object ItensPedidoMemTableQuantidadeItensPedido: TFMTBCDField
      FieldName = 'QuantidadeItensPedido'
      DisplayFormat = '###,##0.00'
    end
    object ItensPedidoMemTableVlrUnitarioItensPedido: TFMTBCDField
      FieldName = 'VlrUnitarioItensPedido'
      DisplayFormat = '###,##0.00'
    end
    object ItensPedidoMemTableVlrTotalItensPedido: TFMTBCDField
      FieldName = 'VlrTotalItensPedido'
      DisplayFormat = '###,##0.00'
    end
  end
  object DataSource1: TDataSource
    DataSet = FDMemTable1
    Left = 712
    Top = 448
  end
  object FDMemTable1: TFDMemTable
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
    Left = 856
    Top = 448
    object IntegerField1: TIntegerField
      FieldName = 'idItensPedido'
    end
    object IntegerField2: TIntegerField
      FieldName = 'PedidoItensPedido'
    end
    object IntegerField3: TIntegerField
      FieldName = 'ProdutoItensPedido'
    end
    object StringField1: TStringField
      FieldName = 'DescricaoProdutos'
      Size = 80
    end
    object FMTBCDField1: TFMTBCDField
      FieldName = 'QuantidadeItensPedido'
      DisplayFormat = '###,##0.00'
    end
    object FMTBCDField2: TFMTBCDField
      FieldName = 'VlrUnitarioItensPedido'
      DisplayFormat = '###,##0.00'
    end
    object FMTBCDField3: TFMTBCDField
      FieldName = 'VlrTotalItensPedido'
      DisplayFormat = '###,##0.00'
    end
  end
end
