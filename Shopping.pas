unit Shopping;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Phys.SQLiteWrapper.Stat, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.FormTabsBar, Vcl.ComCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.Menus;

type
  TForm1 = class(TForm)
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDQuery2: TFDQuery;
    FDQuery3: TFDQuery;
    FDQuery4: TFDQuery;
    FDQuery5: TFDQuery;
    DataSource1: TDataSource;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    TabControl1: TTabControl;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    DBGrid1: TDBGrid;
    FDQuery6: TFDQuery;
    Panel1: TPanel;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    Edit5: TEdit;
    Label6: TLabel;
    Memo1: TMemo;
    Button3: TButton;
    FDQuery7: TFDQuery;
    FDQuery8: TFDQuery;
    FDQuery9: TFDQuery;
    FDQuery10: TFDQuery;
    FDQuery11: TFDQuery;
    FDQuery12: TFDQuery;
    FDQuery13: TFDQuery;
    Label7: TLabel;
    Label8: TLabel;
    Button4: TButton;
    Button5: TButton;
    ComboBox1: TComboBox;
    FDQuery14: TFDQuery;
    FDQuery15: TFDQuery;
    Button6: TButton;
    Button7: TButton;
    FDQuery16: TFDQuery;
    procedure ShowFirstTab();
    procedure ShowStoreTab(name: string);
    procedure FormCreate(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure show_stores(Sender: TObject);
    procedure new_store(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    function CurrentRowNumber(): integer;
    function GetFieldValue(colnum : integer): string;
    procedure Button7Click(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
    store_names: TStringList;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

type
  THackDBGrid = class(TDBGrid);

implementation

{$R *.dfm}

function TForm1.CurrentRowNumber: integer;
begin
  Result := THackDBGrid(DBGrid1).Row;
end;

function TForm1.GetFieldValue(colnum : integer): string;
begin
  Result := THackDBGrid(DBGrid1).GetFieldValue(colnum);
end;

procedure TForm1.ShowFirstTab();
begin
  DBGrid1.DataSource.DataSet := FDQuery13;
  FDQuery13.Close;
  FDQuery13.Open;
  Visible := True;
  Label1.Caption := 'New store:';
  Edit1.SetFocus;
  Button2.Visible := False;
end;

procedure TForm1.ShowStoreTab(name: string);
begin
  DBGrid1.DataSource.DataSet := FDQuery6;
  FDQuery6.Close;
  FDQuery6.ParamByName('store').AsString := name;
  FDQuery6.Open;
  Label1.Caption := 'Rename store:';
  Button2.Visible := True;
end;

// new store
procedure TForm1.new_store(Sender: TObject);
var
  StoreTabs: TStringList;
begin
  if Edit1.Text <> '' then
  try
    FDQuery2.ParamByName('name').AsString := Edit1.Text;
    FDQuery2.ExecSQL;
    StoreTabs := TStringList.Create;
    StoreTabs.Sorted := True;
    StoreTabs.Assign(TabControl1.Tabs);
    StoreTabs.Add(Edit1.Text);
    TabControl1.Tabs := StoreTabs;
    TabControl1.TabIndex := TabControl1.Tabs.IndexOf(Edit1.Text);
    Edit1.Text := '';
    ShowStoreTab(Edit1.Text);
    StoreTabs.Free;
  except
    on E: Exception do
      ShowMessage('Error creating record: ' + E.Message);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  new_store(Sender);
end;

// delete store
procedure TForm1.Button2Click(Sender: TObject);
var
  index: integer;
begin
  index := TabControl1.TabIndex;
  if MessageDlg('Delete store ' + TabControl1.Tabs[index] + '?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  try
    FDQuery3.ParamByName('name').AsString := TabControl1.Tabs[index];
    FDQuery3.ExecSQL;
    FDQuery12.Close;
    FDQuery12.ParamByName('name').AsString := TabControl1.Tabs[index];
    FDQuery12.Open;
    FDQuery10.ParamByName('store_id').AsInteger := FDQuery12.FieldByName('id').AsInteger;
    FDQuery10.ParamByName('item_id').AsInteger := 0;
    FDQuery10.ExecSQL;
    TabControl1.Tabs.Delete(index);
    TabControl1.TabIndex := 0;
    ShowFirstTab();
  except
    on E: Exception do
      ShowMessage('Error deleting record: ' + E.Message);
  end;
end;

// new item
procedure TForm1.Button3Click(Sender: TObject);
var
  NewID: Variant;
begin
  if Edit2.Text = '' then Exit;
  if MessageDlg('Add a new item?', mtConfirmation, [mbYes, mbNo], 0) in [mrNo, mrCancel] then Exit;
  FDQuery16.Close;
  FDQuery16.ParamByName('name').AsString := Edit2.Text;
  FDQuery16.Open;
  if FDQuery16.RecordCount > 0 then
  begin
    ShowMessage('An item called "' + Edit2.Text + '" already exists.');
    Exit;
  end;
  try
    FDQuery7.ParamByName('name').AsString := Edit2.Text;
    FDQuery7.ParamByName('cat').AsString := Edit3.Text;
    FDQuery7.ParamByName('price').AsFloat := StrToFloat(Edit5.Text);
    FDQuery7.ParamByName('quant').AsInteger := StrToInt(Edit4.Text);
    FDQuery7.ParamByName('note').AsString := Memo1.Lines.Text;
    FDQuery7.ExecSQL;
    NewID := FDQuery7.Connection.GetLastAutoGenValue('items');
    if TabControl1.TabIndex > 0 then
    begin
      FDQuery12.Close;
      FDQuery12.ParamByName('name').AsString := TabControl1.Tabs[TabControl1.TabIndex];
      FDQuery12.Open;
      FDQuery9.ParamByName('store').AsInteger := FDQuery12.FieldByName('id').AsInteger;
      FDQuery9.ParamByName('item').AsInteger := NewID;
      FDQuery9.ExecSQL;
    end;
    Edit2.Text := '';
    Edit3.Text := '';
    Edit4.Text := '';
    Edit5.Text := '';
    Memo1.Lines.Text := '';
    FDQuery6.Close;
    FDQuery6.ParamByName('store').AsString := TabControl1.Tabs[TabControl1.TabIndex];
    FDQuery6.Open;
  except
    on E: Exception do
      ShowMessage('Error inserting item: ' + E.Message);
  end;
end;

// delete item
procedure TForm1.Button4Click(Sender: TObject);
begin
  if TabControl1.TabIndex = 0 then
  begin
    if MessageDlg('Delete item id ' + GetFieldValue(0) + '?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    try
      FDQuery11.ParamByName('id').AsInteger := StrToInt(GetFieldValue(0));
      FDQuery11.ExecSQL;
      FDQuery13.Close;
      FDQuery13.Open;
    except
      on E: Exception do
        ShowMessage('Error deleting item: ' + E.Message);
    end;
  end
  else
  begin
    if MessageDlg('Remove item id ' + GetFieldValue(0) + ' from store?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    try
      FDQuery10.ParamByName('store').AsInteger := 0;
      FDQuery10.ParamByName('item').AsInteger := StrToInt(GetFieldValue(0));
      FDQuery10.ExecSQL;
      FDQuery6.Close;
      FDQuery6.ParamByName('store').AsString := TabControl1.Tabs[TabControl1.TabIndex];
      FDQuery6.Open;
    except
      on E: Exception do
        ShowMessage('Error removing item: ' + E.Message);
    end;
  end;
end;

// update item
procedure TForm1.Button6Click(Sender: TObject);
var
  price: String;
  id: Integer;
begin
  if Edit2.Text = '' then Exit;
  if MessageDlg('Update item?', mtConfirmation, [mbYes, mbNo], 0) in [mrNo, mrCancel] then Exit;
  try
    id := StrToInt(GetFieldValue(0));
    FDQuery14.ParamByName('name').AsString := Edit2.Text;
    FDQuery14.ParamByName('cat').AsString := Edit3.Text;
    FDQuery14.ParamByName('quant').AsInteger := StrToInt(Edit4.Text);
    if Copy(Edit5.Text, 1, 1) = '$' then
      price := Copy(Edit5.Text, 2, Length(Edit4.Text))
    else
      price := Edit5.Text;
    FDQuery14.ParamByName('price').AsFloat := StrToFloat(price);
    FDQuery14.ParamByName('note').AsString := Memo1.Text;
    FDQuery14.ParamByName('id').AsInteger := id;
    FDQuery14.ExecSQL;
    if ComboBox1.ItemIndex >= 0 then
    begin
      FDQuery12.Close;
      FDQuery12.ParamByName('name').AsString := ComboBox1.Items[ComboBox1.ItemIndex];
      FDQuery12.Open;
      FDQuery15.Close;
      FDQuery15.ParamByName('store').AsInteger := FDQuery12.FieldByName('id').AsInteger;
      FDQuery15.ParamByName('item').AsInteger := id;
      FDQuery15.Open;
      if FDQuery12.RecordCount >= 1 then
        ShowMessage('Item already exists in store.')
      else
      begin
        FDQuery9.ParamByName('store').AsInteger := FDQuery12.FieldByName('id').AsInteger;
        FDQuery9.ParamByName('item').AsInteger := id;
        FDQuery9.ExecSQL;
      end;
    end;
  except
      on E: Exception do
        ShowMessage('Error updating item: ' + E.Message);
  end;
  if TabControl1.TabIndex = 0 then
  begin
    FDQuery13.Close;
    FDQuery13.Open;
  end
  else
  begin
    FDQuery6.Close;
    FDQuery6.ParamByName('store').AsString := TabControl1.Tabs[TabControl1.TabIndex];
    FDQuery6.Open;
  end;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  if MessageDlg('Clear form?', mtConfirmation, [mbYes, mbNo], 0) in [mrNo, mrCancel] then Exit;
  Edit2.Clear;
  Edit3.Clear;
  Edit4.Clear;
  Edit5.Clear;
  Memo1.Clear;
end;

procedure TForm1.DBGrid1CellClick(Column: TColumn);
begin
  Edit2.Text := GetFieldValue(1);
  Edit3.Text := GetFieldValue(2);
  Edit4.Text := GetFieldValue(3);
  Edit5.Text := GetFieldValue(4);
  Memo1.Text := GetFieldValue(5);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  try
    if not FDConnection1.Connected then FDConnection1.Open;
    FDQuery4.ExecSQL; // stores
    FDQuery5.ExecSQL; // items
    FDQuery8.ExecSQL; // store_items
    store_names := TStringList.Create;
    store_names.Add('+');
    TabControl1.Tabs := store_names;
    ShowFirstTab();
    show_stores(Sender);
  except
    on E: Exception do
      ShowMessage('Error creating tables: ' + E.Message);
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  store_names.Free;
end;

procedure TForm1.show_stores(Sender: TObject);
begin
  FDQuery1.Close;
  FDQuery1.Open;
  if FDQuery1.RecordCount > 0 then
  try
    FDQuery1.First;
    while not FDQuery1.Eof do
    begin
      ComboBox1.Items.Add(FDQuery1.FieldByName('name').AsString);
      store_names.Add(FDQuery1.FieldByName('name').AsString);
      FDQuery1.Next;
    end;
    TabControl1.Tabs := store_names;
    FDQuery1.Close;
  except
    on E: Exception do
      ShowMessage('Error showing store: ' + E.Message);
  end;
end;

procedure TForm1.TabControl1Change(Sender: TObject);
begin
  if TabControl1.TabIndex = 0 then
    ShowFirstTab()
  else
    ShowStoreTab(TabControl1.Tabs[TabControl1.TabIndex]);
end;

end.
