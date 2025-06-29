object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Shopping'
  ClientHeight = 605
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object TabControl1: TTabControl
    Left = 0
    Top = 0
    Width = 624
    Height = 605
    Align = alClient
    TabOrder = 0
    OnChange = TabControl1Change
    object Label1: TLabel
      Left = 32
      Top = 40
      Width = 56
      Height = 15
      Caption = 'New store:'
    end
    object Label7: TLabel
      Left = 32
      Top = 64
      Width = 32
      Height = 15
      Caption = 'Items:'
    end
    object Edit1: TEdit
      Left = 94
      Top = 37
      Width = 121
      Height = 23
      TabOrder = 0
      OnEnter = new_store
    end
    object Button1: TButton
      Left = 221
      Top = 36
      Width = 75
      Height = 25
      Caption = 'Submit'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 488
      Top = 36
      Width = 99
      Height = 25
      Caption = 'Remove store'
      TabOrder = 2
      Visible = False
      OnClick = Button2Click
    end
    object DBGrid1: TDBGrid
      Left = 32
      Top = 88
      Width = 555
      Height = 321
      DataSource = DataSource1
      TabOrder = 3
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
    end
    object Panel1: TPanel
      Left = 32
      Top = 415
      Width = 555
      Height = 162
      TabOrder = 4
      object Label2: TLabel
        Left = 24
        Top = 44
        Width = 54
        Height = 15
        Caption = 'New item:'
      end
      object Label3: TLabel
        Left = 24
        Top = 77
        Width = 51
        Height = 15
        Caption = 'Category:'
      end
      object Label4: TLabel
        Left = 312
        Top = 44
        Width = 49
        Height = 15
        Caption = 'Quantity:'
      end
      object Label5: TLabel
        Left = 312
        Top = 77
        Width = 29
        Height = 15
        Caption = 'Price:'
      end
      object Label6: TLabel
        Left = 24
        Top = 109
        Width = 29
        Height = 15
        Caption = 'Note:'
      end
      object Label8: TLabel
        Left = 24
        Top = 16
        Width = 47
        Height = 15
        Caption = 'Selected:'
      end
      object Edit2: TEdit
        Left = 96
        Top = 44
        Width = 165
        Height = 23
        TabOrder = 0
      end
      object Edit3: TEdit
        Left = 96
        Top = 77
        Width = 168
        Height = 23
        TabOrder = 1
      end
      object Edit4: TEdit
        Left = 376
        Top = 44
        Width = 57
        Height = 23
        TabOrder = 2
      end
      object Edit5: TEdit
        Left = 376
        Top = 77
        Width = 57
        Height = 23
        TabOrder = 3
      end
      object Memo1: TMemo
        Left = 96
        Top = 106
        Width = 337
        Height = 38
        TabOrder = 4
      end
      object Button3: TButton
        Left = 456
        Top = 117
        Width = 75
        Height = 25
        Caption = 'Submit'
        TabOrder = 5
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 96
        Top = 9
        Width = 105
        Height = 25
        Caption = 'Remove item'
        TabOrder = 6
      end
      object ComboBox1: TComboBox
        Left = 288
        Top = 9
        Width = 145
        Height = 23
        ItemIndex = 0
        TabOrder = 7
        Text = 'To store'
        Items.Strings = (
          'To store')
      end
    end
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=SQLite'
      
        'Database=C:\cygwin64\home\diamo\repos\Delphi-Shopping\Shopping.d' +
        'b')
    Left = 88
    Top = 176
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT name FROM stores ORDER BY LOWER(name)')
    Left = 304
    Top = 319
  end
  object DataSource1: TDataSource
    DataSet = FDQuery6
    Left = 176
    Top = 176
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 296
    Top = 176
  end
  object FDQuery2: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'INSERT INTO stores (name) VALUES (:name)')
    Left = 456
    Top = 319
    ParamData = <
      item
        Name = 'NAME'
        ParamType = ptInput
      end>
  end
  object FDQuery3: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'DELETE FROM stores WHERE name = :name')
    Left = 528
    Top = 319
    ParamData = <
      item
        Name = 'NAME'
        ParamType = ptInput
      end>
  end
  object FDQuery4: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'CREATE TABLE IF NOT EXISTS stores ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'name VARCHAR(20))')
    Left = 72
    Top = 320
  end
  object FDQuery5: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'CREATE TABLE IF NOT EXISTS items ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT,'
      'name VARCHAR(20),'
      'note VARCHAR(255),'
      'category VARCHAR(20),'
      'price CURRENCY,'
      'quantity INTEGER,'
      'store_id INTEGER,'
      'assigned INTEGER)')
    Left = 144
    Top = 320
  end
  object FDQuery6: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select'
      '  i.name,'
      '  i.category,'
      '  i.price,'
      '  i.quantity,'
      '  i.note'
      ''
      'from items as i'
      ''
      'join store_items as si'
      '  on i.id = si.item_id'
      ''
      'join stores as s'
      '  on s.id = si.store_id'
      ''
      'where s.name = :store')
    Left = 368
    Top = 248
    ParamData = <
      item
        Name = 'STORE'
        ParamType = ptInput
      end>
  end
  object FDQuery7: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'insert into items ('
      'name,'
      'category,'
      'price,'
      'quantity,'
      'note)'
      'values ('
      ':name,'
      ':cat,'
      ':price,'
      ':quant,'
      ':note'
      ')')
    Left = 456
    Top = 248
    ParamData = <
      item
        Name = 'NAME'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'CAT'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PRICE'
        DataType = ftCurrency
        ParamType = ptInput
      end
      item
        Name = 'QUANT'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'NOTE'
        DataType = ftString
        ParamType = ptInput
      end>
  end
  object FDQuery8: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'CREATE TABLE IF NOT EXISTS store_items ('
      'store_id INTEGER, '
      'item_id INTEGER)')
    Left = 216
    Top = 320
  end
  object FDQuery9: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      
        'INSERT INTO store_items (store_id, item_id) VALUES (:store, :ite' +
        'm)')
    Left = 456
    Top = 176
    ParamData = <
      item
        Name = 'STORE'
        ParamType = ptInput
      end
      item
        Name = 'ITEM'
        ParamType = ptInput
      end>
  end
  object FDQuery10: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'DELETE FROM store_items WHERE store_id=:store OR item_id=:item')
    Left = 528
    Top = 176
    ParamData = <
      item
        Name = 'STORE'
        ParamType = ptInput
      end
      item
        Name = 'ITEM'
        ParamType = ptInput
      end>
  end
  object FDQuery11: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'DELETE FROM items WHERE id = :id')
    Left = 528
    Top = 248
    ParamData = <
      item
        Name = 'ID'
        ParamType = ptInput
      end>
  end
  object FDQuery12: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT id FROM stores where name =  :name')
    Left = 368
    Top = 319
    ParamData = <
      item
        Name = 'NAME'
        ParamType = ptInput
      end>
  end
  object FDQuery13: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select'
      '  name,'
      '  category,'
      '  price,'
      '  quantity,'
      '  note'
      'from items')
    Left = 304
    Top = 248
  end
end
