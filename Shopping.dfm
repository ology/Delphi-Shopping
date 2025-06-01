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
      Visible = False
    end
    object Edit1: TEdit
      Left = 94
      Top = 45
      Width = 121
      Height = 23
      TabOrder = 0
      Visible = False
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
end
