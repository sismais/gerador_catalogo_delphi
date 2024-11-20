unit View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  //IMPORTANTE
  MidasLib,
  //IMPORTANTE
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, frxClass, frxExportBaseDialog, frxExportPDF, Vcl.StdCtrls, Data.DB,
  Datasnap.DBClient, Vcl.DBGrids, frxDBSet, JvExDBGrids, JvDBGrid, frxDesgn, frxChart, frxRich,
  frxBarcode;

type
  TForm1 = class(TForm)
    btnAbrirDados: TButton;
    OpenDialog1: TOpenDialog;
    frxReport1: TfrxReport;
    frxPDFExport1: TfrxPDFExport;
    Button2: TButton;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    frxDadosCSV: TfrxDBDataset;
    JvDBGrid1: TJvDBGrid;
    btnCriarReport: TButton;
    SaveDialog1: TSaveDialog;
    btnCarregarReport: TButton;
    btnEditarReport: TButton;
    frxBarCodeObject1: TfrxBarCodeObject;
    frxRichObject1: TfrxRichObject;
    frxChartObject1: TfrxChartObject;
    lblReportFileName: TLabel;
    edtSobre: TButton;
    procedure btnAbrirDadosClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnCriarReportClick(Sender: TObject);
    procedure btnCarregarReportClick(Sender: TObject);
    procedure btnEditarReportClick(Sender: TObject);
    procedure edtSobreClick(Sender: TObject);
  private
    FCurrentReportFile: String;
    { Private declarations }
    procedure LoadCSVToClientDataSet(const FileName: string);
    procedure LoadClientDataSetToStringGrid;
    procedure SetCurrentReportFile(const Value: String);
    procedure CheckDados;
  public
    { Public declarations }
    property CurrentReportFile: String read FCurrentReportFile write SetCurrentReportFile;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function GetReportsPath: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'reports\';
  if not DirectoryExists(Result) then
    CreateDir(Result);
end;

procedure ResetClientDataSet(AClientDataSet: TClientDataSet);
begin
  if AClientDataSet.Active then
    AClientDataSet.Close; // Fecha o DataSet se estiver ativo

  AClientDataSet.Fields.Clear;  // Remove todos os campos
  AClientDataSet.FieldDefs.Clear; // Remove todas as definições de campos
end;

procedure TForm1.btnAbrirDadosClick(Sender: TObject);
begin
  ShowMessage('IMPORTANTE: O arquivo .csv tem que estar usando o ";" (ponto e vírgula) como separados de dados.');
  if OpenDialog1.Execute then
    LoadCSVToClientDataSet(OpenDialog1.FileName);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  CheckDados;

  if (Self.CurrentReportFile) = '' then
  begin
    ShowMessage('É preciso Criar ou Carregar um Report primeiro.');
  end;

  frxReport1.LoadFromFile(Self.CurrentReportFile);
  frxReport1.ShowReport;
end;

procedure TForm1.CheckDados;
begin
  if ClientDataSet1.IsEmpty then
  begin
    ShowMessage('Antes é preciso ter dados carregados.' + SLineBreak +
      'Clique em "' + btnAbrirDados.Caption + '" para iniciar.');
    Abort;
  end;
end;

procedure TForm1.edtSobreClick(Sender: TObject);
begin
  ShowMessage('Desenvolvido por Maicon Saraiva: @maiconsaraiva' + SLineBreak +
    'Projeto no github: https://github.com/sismais/gerador_catalogo_delphi ');
end;

procedure TForm1.btnCarregarReportClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
  Report: TfrxReport;
begin
  CheckDados;
  OpenDialog := TOpenDialog.Create(nil);
  Report := TfrxReport.Create(nil);
  try
    OpenDialog.InitialDir := GetReportsPath;
    OpenDialog.Filter := 'Arquivo Report do FastReport (*.fr3)|*.fr3';
    if OpenDialog.Execute then
    begin
      try
        Report.LoadFromFile(OpenDialog.FileName);
      except
        on E: Exception do
        begin
          E.Message := Format('O arquivo %s não parece ser um arquivo Report (do Fast Report ".fr3") válido.',
            [OpenDialog.FileName]) + SLineBreak +
            E.Message;
          Raise;
        end;
      end;
      Self.CurrentReportFile := OpenDialog.FileName;
    end;
  finally
    OpenDialog.Free;
    Report.Free;
  end;
end;

procedure TForm1.btnCriarReportClick(Sender: TObject);
var
  SaveDialog: TSaveDialog;
  Report: TfrxReport;
begin
  CheckDados;
  ShowMessage('Antes de iniciar. Escolha um Nome e Local para salvar o Report.');
  SaveDialog := TSaveDialog.Create(nil);
  Report := TfrxReport.Create(nil);
  try
    SaveDialog.InitialDir := GetReportsPath;
    SaveDialog.Filter := 'Arquivo Report do FastReport (*.fr3)|*.fr3';
    SaveDialog.DefaultExt := 'fr3';
    SaveDialog.Title := 'Salvar Novo Relatório';
    if SaveDialog.Execute then
    begin
      // Verifica se o arquivo já existe e solicita confirmação para sobrescrever
      if FileExists(SaveDialog.FileName) then
      begin
        if MessageDlg('O arquivo já existe. Deseja sobrescrevê-lo?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
          Exit;
      end;

      // Cria um novo relatório em branco
      Report.Clear;
      Report.FileName := SaveDialog.FileName;

      // Abre o designer para edição do relatório
      Report.DesignReport;

      // Salva o relatório após a edição
      Report.SaveToFile(SaveDialog.FileName);
    end;
  finally
    SaveDialog.Free;
    Report.Free;
  end;
end;

procedure TForm1.btnEditarReportClick(Sender: TObject);
var
  Report: TfrxReport;
begin
  CheckDados;
  if Self.CurrentReportFile = '' then
  begin
    ShowMessage('Crie ou Carregue um Report primeiro!');
    Exit;
  end;
  Report := TfrxReport.Create(nil);
  try
    Report.LoadFromFile(Self.CurrentReportFile);
    Report.FileName := Self.CurrentReportFile;
    // Abre o designer para edição do relatório
    Report.DesignReport;

    // Salva o relatório após a edição
    Report.SaveToFile(SaveDialog1.FileName);
  finally
    Report.Free;
  end;
end;

procedure TForm1.LoadCSVToClientDataSet(const FileName: string);
var
  CSVLines: TStringList;
  Line: string;
  Fields: TArray<string>;
  I: Integer;
begin
  ResetClientDataSet(ClientDataSet1);
  CSVLines := TStringList.Create;
  try
    // Carregar o arquivo com suporte a UTF-8
    CSVLines.LoadFromFile(FileName, TEncoding.UTF8);

    if CSVLines.Count > 0 then
    begin
      Line := CSVLines[0];
      if Line.EndsWith(';') then
        Line := Copy(Line, 1, Line.Length - 1);
      Fields := Line.Split([';']);

      for I := 0 to High(Fields) do
      begin
        ClientDataSet1.FieldDefs.Add(Fields[I], ftString, 255);
      end;

      ClientDataSet1.CreateDataSet;
    end;

    // Adicionar dados
    for I := 1 to CSVLines.Count - 1 do
    begin
      Line := CSVLines[I];
      if Line.EndsWith(';') then
        Line := Copy(Line, 1, Line.Length - 1);
      Fields := Line.Split([';']);
      ClientDataSet1.Append;

      for var J := 0 to High(Fields) do
        ClientDataSet1.Fields[J].AsString := Fields[J];

      ClientDataSet1.Post;
    end;

  finally
    CSVLines.Free;
  end;

  ClientDataSet1.First;
  DataSource1.DataSet := ClientDataSet1;
end;

procedure TForm1.SetCurrentReportFile(const Value: String);
begin
  if Value <> FCurrentReportFile then
  begin
    FCurrentReportFile := Value;

    lblReportFileName.Caption := Value;
  end;
end;

procedure TForm1.LoadClientDataSetToStringGrid;
var
  I, J: Integer;
begin
  {StringGrid1.RowCount := ClientDataSet1.RecordCount + 1;
  StringGrid1.ColCount := ClientDataSet1.Fields.Count;

  // Configurar os títulos
  for I := 0 to ClientDataSet1.Fields.Count - 1 do
    StringGrid1.Cells[I, 0] := ClientDataSet1.Fields[I].FieldName;

  // Adicionar os dados
  ClientDataSet1.First;
  I := 1;
  while not ClientDataSet1.Eof do
  begin
    for J := 0 to ClientDataSet1.Fields.Count - 1 do
    begin
      StringGrid1.Cells[J, I] := ClientDataSet1.Fields[J].AsString;
    end;

    Inc(I);
    ClientDataSet1.Next;
  end; }
end;

end.
