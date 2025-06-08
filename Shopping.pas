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
  Vcl.DBGrids;

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
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure show_stores(Sender: TObject);
    procedure new_store(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
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

procedure ShowFirstTab();
begin
  Form1.Label1.Visible := True;
  Form1.Edit1.Visible := True;
  Form1.Button1.Visible := True;
  Form1.Button2.Visible := False;
  Form1.DBGrid1.Visible := False;
end;

procedure ShowStoreTab(id: integer);
begin
  Form1.Label1.Visible := False;
  Form1.Edit1.Visible := False;
  Form1.Button1.Visible := False;
  Form1.Button2.Visible := True;
  Form1.DBGrid1.Visible := True;
  Form1.FDQuery6.Close;
  Form1.FDQuery6.open;
end;

procedure TForm1.new_store(Sender: TObject);
var
  StoreTabs: TStringList;
begin
  if Edit1.Text <> '' then
  begin
    try
      FDQuery2.ParamByName('name').AsString := Edit1.Text;
      FDQuery2.ParamByName('tab').AsInteger := TabControl1.TabIndex;
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
    Edit1.Text := '';
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  new_store(Sender);
end;

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

procedure TForm1.FormCreate(Sender: TObject);
begin
  try
    if not FDConnection1.Connected then
      FDConnection1.Open;
    FDQuery4.ExecSQL;
    FDQuery5.ExecSQL;
  except
    on E: Exception do
    ShowMessage('Error creating tables: ' + E.Message);
  end;
  store_names := TStringList.Create;
  store_names.Add('+');
  TabControl1.Tabs := store_names;
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

procedure TForm1.FormShow(Sender: TObject);
var
  i: integer;
begin
  show_stores(Sender);
end;

procedure TForm1.TabControl1Change(Sender: TObject);
begin
  if TabControl1.TabIndex = 0 then
    ShowFirstTab()
  else
    ShowStoreTab(TabControl1.TabIndex);
end;

end.
