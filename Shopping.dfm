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
  OnShow = FormShow
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
    object DBGrid1: TDBGrid
      Left = 32
      Top = 96
      Width = 555
      Height = 313
      DataSource = DataSource1
      TabOrder = 3
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      Visible = False
    end
    object Panel1: TPanel
      Left = 32
      Top = 424
      Width = 555
      Height = 161
      TabOrder = 4
      object Label2: TLabel
        Left = 24
        Top = 24
        Width = 54
        Height = 15
        Caption = 'New item:'
      end
      object Label3: TLabel
        Left = 24
        Top = 64
        Width = 51
        Height = 15
        Caption = 'Category:'
      end
      object Label4: TLabel
        Left = 296
        Top = 24
        Width = 49
        Height = 15
        Caption = 'Quantity:'
      end
      object Label5: TLabel
        Left = 296
        Top = 64
        Width = 29
        Height = 15
        Caption = 'Price:'
      end
      object Label6: TLabel
        Left = 24
        Top = 104
        Width = 29
        Height = 15
        Caption = 'Note:'
      end
      object Edit2: TEdit
        Left = 96
        Top = 24
        Width = 165
        Height = 23
        TabOrder = 0
      end
      object Edit3: TEdit
        Left = 96
        Top = 64
        Width = 168
        Height = 23
        TabOrder = 1
      end
      object Edit4: TEdit
        Left = 360
        Top = 24
        Width = 57
        Height = 23
        TabOrder = 2
      end
      object Edit5: TEdit
        Left = 360
        Top = 64
        Width = 57
        Height = 23
        TabOrder = 3
      end
      object Memo1: TMemo
        Left = 96
        Top = 104
        Width = 321
        Height = 38
        TabOrder = 4
      end
      object Button3: TButton
        Left = 456
        Top = 112
        Width = 75
        Height = 25
        Caption = 'Submit'
        TabOrder = 5
        OnClick = Button3Click
      end
    end
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=SQLite'
      
        'Database=C:\cygwin64\home\diamo\repos\Delphi-Shopping\Shopping.d' +
        'b')
    Left = 56
    Top = 352
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT id,name,tab FROM stores ORDER BY LOWER(name)')
    Left = 384
    Top = 352
  end
  object DataSource1: TDataSource
    DataSet = FDQuery6
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
      'INSERT INTO stores (name, tab) VALUES (:name, :tab)')
    Left = 456
    Top = 352
    ParamData = <
      item
        Name = 'NAME'
        ParamType = ptInput
      end
      item
        Name = 'TAB'
        ParamType = ptInput
      end>
  end
  object FDQuery3: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'DELETE FROM stores WHERE name = :name')
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
      'CREATE TABLE IF NOT EXISTS stores ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'name VARCHAR(20),'
      'tab INTEGER)')
    Left = 384
    Top = 296
  end
  object FDQuery5: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'CREATE TABLE IF NOT EXISTS items ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT,'
      'name VARCHAR(20),'
      'note VARCHAR(255),'
      'category VARCHAR(20),'
      'price NUMBER,'
      'quantity INTEGER,'
      'store_id INTEGER,'
      'assigned INTEGER)')
    Left = 456
    Top = 296
  end
  object FDQuery6: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select'
      'id,'
      'name,'
      'category,'
      'price,'
      'quantity,'
      'note'
      'from items')
    Left = 528
    Top = 296
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
    Left = 528
    Top = 240
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
end
