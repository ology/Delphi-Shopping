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
  FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.FormTabsBar, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    DataSource1: TDataSource;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    TabControl1: TTabControl;
    Label1: TLabel;
    Edit1: TEdit;
    FDQuery2: TFDQuery;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure show_stores(Sender: TObject);
    procedure new_store(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    sql: string;
    list_names: TStringList;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.new_store(Sender: TObject);
var
  StoreTabs: TStringList;
begin
  if Edit1.Text <> '' then
  begin
    sql := 'INSERT INTO list (name) VALUES ("' + Edit1.Text + '")';
    //showmessage(sql);
    FDConnection1.ExecSQL(sql);
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
  caption: string;
begin
  index := TabControl1.TabIndex;
  caption := TabControl1.Tabs[index];
  sql := 'DELETE FROM list WHERE name = "' + caption + '"';
  showmessage(sql);
  FDConnection1.ExecSQL(sql);
  TabControl1.Tabs.Delete(TabControl1.TabIndex);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  try
    if not FDConnection1.Connected then
      FDConnection1.Open;

    sql := 'CREATE TABLE IF NOT EXISTS list (' +
           'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
           'name TEXT)';
    FDConnection1.ExecSQL(sql);
    sql := 'CREATE TABLE IF NOT EXISTS item (' +
           'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
           'name TEXT, ' +
           'note TEXT, ' +
           'category TEXT, ' +
           'cost NUMBER, ' +
           'quantity INTEGER, ' +
           'list_id INTEGER, ' +
           'assigned INTEGER)';
    FDConnection1.ExecSQL(sql);
  except
    // on E: Exception do
      // Memo1.Lines.Add('Error creating tables: ' + E.Message);
  end;
end;

procedure TForm1.show_stores(Sender: TObject);
var
  i: integer;
begin
  FDQuery1.Close;
  FDQuery1.Open;
  if FDQuery1.RecordCount > 0 then
  begin
    list_names := TStringList.Create;
    try
      list_names.Add('+');
      i := 0;
      FDQuery1.First;
      while not FDQuery1.Eof do
      begin
        list_names.Add(FDQuery1.FieldByName('name').AsString);
        Inc(i);
        FDQuery1.Next;
      end;
      TabControl1.Tabs := list_names;
    finally
      list_names.Free;
    end;
  end;
  Form1.FDQuery1.Close;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  i: integer;
begin
  show_stores(Sender);
end;

procedure TForm1.TabControl1Change(Sender: TObject);
begin
  if TabControl1.TabIndex = 0  then
  begin
    Label1.Visible := True;
    Edit1.Visible := True;
    Button1.Visible := True;
    Button2.Visible := False;
  end
  else
  begin
    Label1.Visible := False;
    Edit1.Visible := False;
    Button1.Visible := False;
    Button2.Visible := True;
  end;
end;

end.
