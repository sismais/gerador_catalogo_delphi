object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Gerador de Catalogos e Cupons'
  ClientHeight = 563
  ClientWidth = 753
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  DesignSize = (
    753
    563)
  TextHeight = 15
  object lblReportFileName: TLabel
    Left = 260
    Top = 495
    Width = 359
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = '...'
    ExplicitWidth = 372
  end
  object btnAbrirDados: TButton
    Left = 8
    Top = 8
    Width = 281
    Height = 32
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Abrir .csv'
    TabOrder = 0
    OnClick = btnAbrirDadosClick
  end
  object Button2: TButton
    Left = 8
    Top = 523
    Width = 737
    Height = 32
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Preview'
    TabOrder = 1
    OnClick = Button2Click
    ExplicitWidth = 750
  end
  object JvDBGrid1: TJvDBGrid
    Left = 8
    Top = 56
    Width = 737
    Height = 413
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = DataSource1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    AutoSizeColumns = True
    SelectColumnsDialogStrings.Caption = 'Select columns'
    SelectColumnsDialogStrings.OK = '&OK'
    SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
    CanDelete = False
    EditControls = <>
    RowsHeight = 19
    TitleRowHeight = 19
  end
  object btnCriarReport: TButton
    Left = 8
    Top = 489
    Width = 120
    Height = 24
    Anchors = [akLeft, akBottom]
    Caption = 'Criar Report'
    TabOrder = 3
    OnClick = btnCriarReportClick
  end
  object btnCarregarReport: TButton
    Left = 134
    Top = 489
    Width = 120
    Height = 24
    Anchors = [akLeft, akBottom]
    Caption = 'Carregar Report'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Carregar'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnCarregarReportClick
  end
  object btnEditarReport: TButton
    Left = 625
    Top = 489
    Width = 120
    Height = 24
    Anchors = [akRight, akBottom]
    Caption = 'Editar Report'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Carregar'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = btnEditarReportClick
    ExplicitLeft = 638
  end
  object edtSobre: TButton
    Left = 670
    Top = 8
    Width = 75
    Height = 32
    Caption = 'Sobre'
    TabOrder = 6
    OnClick = edtSobreClick
  end
  object OpenDialog1: TOpenDialog
    Filter = 'CSV Files (*.csv)|*.csv'
    Left = 224
    Top = 256
  end
  object frxReport1: TfrxReport
    Version = '2023.1.3'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Padr'#227'o'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 45616.760404444450000000
    ReportOptions.LastChange = 45616.760404444450000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 400
    Top = 304
    Datasets = <>
    Variables = <>
    Style = <>
  end
  object frxPDFExport1: TfrxPDFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = True
    DataOnly = False
    Compressed = False
    EmbeddedFonts = True
    EmbedFontsIfProtected = False
    InteractiveFormsFontSubset = 'A-Z,a-z,0-9,#43-#47 '
    OpenAfterExport = False
    PrintOptimized = False
    Outline = False
    Background = False
    HTMLTags = True
    Quality = 95
    Author = 'FastReport'
    Subject = 'FastReport PDF export'
    Creator = 'Maicon Saraiva'
    ProtectionFlags = [ePrint, eModify, eCopy, eAnnot]
    HideToolbar = False
    HideMenubar = False
    HideWindowUI = False
    FitWindow = False
    CenterWindow = False
    PrintScaling = False
    PdfA = False
    PDFStandard = psNone
    PDFVersion = pv17
    Left = 584
    Top = 296
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 336
    Top = 120
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 432
    Top = 128
  end
  object frxDadosCSV: TfrxDBDataset
    UserName = 'Dados do CSV'
    CloseDataSource = False
    DataSet = ClientDataSet1
    BCDToCurrency = False
    DataSetOptions = []
    Left = 576
    Top = 120
  end
  object SaveDialog1: TSaveDialog
    Filter = 'CSV Files (*.csv)|*.csv'
    Left = 264
    Top = 416
  end
  object frxBarCodeObject1: TfrxBarCodeObject
    Left = 544
    Top = 368
  end
  object frxRichObject1: TfrxRichObject
    Left = 544
    Top = 432
  end
  object frxChartObject1: TfrxChartObject
    Left = 648
    Top = 416
  end
end
