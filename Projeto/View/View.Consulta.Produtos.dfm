object FConsultaProdutos: TFConsultaProdutos
  Left = 0
  Top = 0
  ActiveControl = LEFiltroDescricaoItem
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Consulta Produtos'
  ClientHeight = 408
  ClientWidth = 696
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 13
  object PRodape: TPanel
    Left = 0
    Top = 367
    Width = 696
    Height = 41
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 251
    ExplicitWidth = 456
    DesignSize = (
      696
      41)
    object BBSair: TBitBtn
      Left = 610
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
      OnClick = BBSairClick
      ExplicitLeft = 370
    end
    object BBSelecionar: TBitBtn
      Left = 518
      Top = 6
      Width = 86
      Height = 25
      Anchors = [akRight]
      Caption = '&Selecionar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Kind = bkOK
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 0
      ExplicitLeft = 278
    end
  end
  object PDados: TPanel
    Left = 0
    Top = 41
    Width = 696
    Height = 326
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 456
    ExplicitHeight = 210
    object DBGView: TDBGrid
      Left = 1
      Top = 1
      Width = 694
      Height = 324
      Hint = 'Duplo Click para Selecionar o Produto...'
      Align = alClient
      DataSource = DSConslutaProduto
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDblClick = DBGViewDblClick
      OnKeyDown = DBGViewKeyDown
      Columns = <
        item
          Expanded = False
          FieldName = 'idProdutos'
          Title.Caption = 'Id'
          Width = 26
          Visible = True
        end
        item
          Color = 8421631
          Expanded = False
          FieldName = 'CodigoProdutos'
          Title.Caption = 'C'#243'digo'
          Width = 63
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DescricaoTipoProduto'
          Title.Caption = 'Tipo'
          Width = 161
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DescricaoProdutos'
          Title.Caption = 'Descri'#231#227'o do Produto'
          Width = 207
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'UndProdutos'
          Title.Alignment = taCenter
          Title.Caption = 'Und'
          Width = 31
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'QuantidadeProdutos'
          Title.Alignment = taRightJustify
          Title.Caption = 'Quantidade'
          Width = 72
          Visible = True
        end
        item
          Color = 8421631
          Expanded = False
          FieldName = 'PrecoVendaProdutos'
          Title.Alignment = taRightJustify
          Title.Caption = 'Pre'#231'o de Venda'
          Width = 89
          Visible = True
        end>
    end
  end
  object PHead: TPanel
    Left = 0
    Top = 0
    Width = 696
    Height = 41
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 456
    DesignSize = (
      696
      41)
    object LEFiltroDescricaoItem: TLabeledEdit
      Left = 148
      Top = 10
      Width = 213
      Height = 21
      EditLabel.Width = 137
      EditLabel.Height = 21
      EditLabel.Caption = 'Filtrar Descri'#231#227'o do Produto:'
      LabelPosition = lpLeft
      TabOrder = 0
      Text = ''
    end
    object BBFiltrar: TBitBtn
      Left = 610
      Top = 3
      Width = 75
      Height = 34
      Anchors = [akTop, akRight]
      Caption = 'Filtra&r'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = BBFiltrarClick
      ExplicitLeft = 370
    end
  end
  object DSConslutaProduto: TDataSource
    DataSet = FDMemTableProduto
    Left = 168
    Top = 121
  end
  object FDMemTableProduto: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 280
    Top = 121
    object FDMemTableProdutoidProdutos: TIntegerField
      FieldName = 'idProdutos'
    end
    object FDMemTableProdutoCodigoProdutos: TStringField
      FieldName = 'CodigoProdutos'
      Size = 10
    end
    object FDMemTableProdutoDescricaoTipoProduto: TStringField
      FieldName = 'DescricaoTipoProduto'
      Size = 50
    end
    object FDMemTableProdutoDescricaoProdutos: TStringField
      FieldName = 'DescricaoProdutos'
      Size = 80
    end
    object FDMemTableProdutoQuantidadeProdutos: TFMTBCDField
      FieldName = 'QuantidadeProdutos'
      DisplayFormat = '###,##0.00'
    end
    object FDMemTableProdutoUndProdutos: TStringField
      FieldName = 'UndProdutos'
      Size = 3
    end
    object FDMemTableProdutoPrecoVendaProdutos: TFMTBCDField
      FieldName = 'PrecoVendaProdutos'
      DisplayFormat = '###,##0.00'
    end
  end
end
