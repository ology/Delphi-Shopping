object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Shopping'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object TabControl1: TTabControl
    Left = 0
    Top = 0
    Width = 624
    Height = 441
    Align = alClient
    TabOrder = 0
    OnChange = TabControl1Change
    object Label1: TLabel
      Left = 32
      Top = 48
      Width = 56
      Height = 15
      Caption = 'New store:'
    end
    object Edit1: TEdit
      Left = 94
      Top = 45
      Width = 121
      Height = 23
      TabOrder = 0
      OnEnter = new_store
    end
    object Button1: TButton
      Left = 221
      Top = 44
      Width = 75
      Height = 25
      Caption = 'Submit'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 488
      Top = 44
      Width = 99
      Height = 25
      Caption = 'Remove store'
      TabOrder = 2
      Visible = False
      OnClick = Button2Click
    end
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=SQLite'
      
        'Database=C:\Users\diamo\Documents\Embarcadero\Studio\Projects\Sh' +
        'opping\Shopping.db')
    Left = 48
    Top = 352
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT id,name FROM list ORDER BY LOWER(name)')
    Left = 384
    Top = 352
  end
  object DataSource1: TDataSource
    Left = 144
    Top = 352
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 264
    Top = 352
  end
  object FDQuery2: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'INSERT INTO list (name) VALUES (:name)')
    Left = 456
    Top = 352
    ParamData = <
      item
        Name = 'NAME'
        ParamType = ptInput
      end>
  end
  object FDQuery3: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'DELETE FROM list WHERE name = :name')
    Left = 528
    Top = 352
    ParamData = <
      item
        Name = 'NAME'
        ParamType = ptInput
      end>
  end
  object FDQuery4: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'CREATE TABLE IF NOT EXISTS list ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'name TEXT)')
    Left = 416
    Top = 296
  end
  object FDQuery5: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'CREATE TABLE IF NOT EXISTS item ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT,'
      'name TEXT,'
      'note TEXT,'
      'category TEXT,'
      'cost NUMBER,'
      'quantity INTEGER,'
      'list_id INTEGER,'
      'assigned INTEGER)')
    Left = 496
    Top = 296
  end
end
