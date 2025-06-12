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
  Vcl.DBGrids, Vcl.ExtCtrls;

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
    procedure ShowFirstTab();
    procedure ShowStoreTab(id: integer);
    procedure FormCreate(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure show_stores(Sender: TObject);
    procedure new_store(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    sql: string;
    store_names: TStringList;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ShowFirstTab();
begin
  Visible := True;
  Label1.Visible := True;
  Edit1.Visible := True;
  Edit1.SetFocus();
  Button1.Visible := True;
  Button2.Visible := False;
  DBGrid1.Visible := False;
  Panel1.Visible := True;
end;

procedure TForm1.ShowStoreTab(id: integer);
begin
  Label1.Visible := False;
  Edit1.Visible := False;
  Button1.Visible := False;
  Button2.Visible := True;
  DBGrid1.Visible := True;
  Panel1.Visible := True;
  FDQuery6.Close;
  FDQuery6.open;
end;

// new store
procedure TForm1.new_store(Sender: TObject);
var
  StoreTabs: TStringList;
begin
  if Edit1.Text <> '' then
  begin
    try
      FDQuery2.ParamByName('name').AsString := Edit1.Text;
      FDQuery2.ExecSQL;
    except
      on E: Exception do
      ShowMessage('Error creating record: ' + E.Message);
    end;
    StoreTabs := TStringList.Create;
    StoreTabs.Sorted := True;
    StoreTabs.Assign(TabControl1.Tabs);
    StoreTabs.Add(Edit1.Text);
    TabControl1.Tabs := StoreTabs;
    TabControl1.TabIndex := TabControl1.Tabs.IndexOf(Edit1.Text);
    Edit1.Text := '';
    ShowStoreTab(TabControl1.TabIndex);
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
  try
    FDQuery3.ParamByName('name').AsString := TabControl1.Tabs[index];
    FDQuery3.ExecSQL;
  except
    on E: Exception do
    ShowMessage('Error deleting record: ' + E.Message);
  end;
  TabControl1.Tabs.Delete(index);
  TabControl1.TabIndex := 0;
  ShowFirstTab();
end;

// new item
procedure TForm1.Button3Click(Sender: TObject);
var
  NewID: Variant;
begin
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
      FDQuery9.ParamByName('store').AsInteger := TabControl1.TabIndex;
      FDQuery9.ParamByName('item').AsInteger := NewID;
      FDQuery9.ExecSQL;
    end;
    Edit2.Text := '';
    Edit3.Text := '';
    Edit4.Text := '';
    Edit5.Text := '';
    Memo1.Lines.Text := '';
    FDQuery6.Close;
    FDQuery6.Open;
  except
    on E: Exception do
    ShowMessage('Error inserting item: ' + E.Message);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  try
    if not FDConnection1.Connected then
      FDConnection1.Open;
    FDQuery4.ExecSQL; // stores
    FDQuery5.ExecSQL; // items
    FDQuery8.ExecSQL; // store_items
  except
    on E: Exception do
    ShowMessage('Error creating tables: ' + E.Message);
  end;
  store_names := TStringList.Create;
  store_names.Add('+');
  TabControl1.Tabs := store_names;
  ShowFirstTab();
  show_stores(Sender);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  store_names.Free;
end;

procedure TForm1.show_stores(Sender: TObject);
var
  i: integer;
begin
  FDQuery1.Close;
  FDQuery1.Open;
  if FDQuery1.RecordCount > 0 then
  begin
    try
      i := 0;
      FDQuery1.First;
      while not FDQuery1.Eof do
      begin
        store_names.Add(FDQuery1.FieldByName('name').AsString);
        Inc(i);
        FDQuery1.Next;
      end;
      TabControl1.Tabs := store_names;
    except
      on E: Exception do
      ShowMessage('Error showing record: ' + E.Message);
    end;
  end;
  FDQuery1.Close;
end;

procedure TForm1.TabControl1Change(Sender: TObject);
begin
  if TabControl1.TabIndex = 0 then
    ShowFirstTab()
  else
    ShowStoreTab(TabControl1.TabIndex);
end;

end.
