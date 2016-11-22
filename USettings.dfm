object SetFrm: TSetFrm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 283
  ClientWidth = 331
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 184
    Width = 80
    Height = 13
    Caption = 'Snapshot folder:'
  end
  object Label2: TLabel
    Left = 16
    Top = 211
    Width = 61
    Height = 13
    Caption = 'Video folder:'
  end
  object edFileSpan: TJvFilenameEdit
    Left = 102
    Top = 181
    Width = 187
    Height = 21
    TabOrder = 0
    Text = 'edFileSpan'
  end
  object edFileVideo: TJvFilenameEdit
    Left = 102
    Top = 208
    Width = 187
    Height = 21
    TabOrder = 1
    Text = 'edFileSpan'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 297
    Height = 145
    Caption = 'Fractal Draw options'
    TabOrder = 2
    object Label3: TLabel
      Left = 41
      Top = 38
      Width = 74
      Height = 13
      Caption = 'Out image size:'
    end
    object Label4: TLabel
      Left = 41
      Top = 62
      Width = 58
      Height = 13
      Caption = 'Antialiasing:'
    end
    object Label9: TLabel
      Left = 41
      Top = 87
      Width = 33
      Height = 13
      Caption = 'Depth:'
    end
    object cbResolution: TComboBox
      Left = 118
      Top = 35
      Width = 138
      Height = 21
      Style = csDropDownList
      ItemIndex = 1
      TabOrder = 0
      Text = '1024x768'
      Items.Strings = (
        '800x600'
        '1024x768'
        '1600x1200'
        '2272x1704'
        '3264x2448'
        '4096x3072'
        '9600x7200')
    end
    object cbAntialias: TComboBox
      Left = 118
      Top = 59
      Width = 138
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 1
      Text = '1'
      Items.Strings = (
        '1'
        '2'
        '4'
        '8'
        '16'
        '32'
        '64'
        '128')
    end
    object ScrollBarDepth: TScrollBar
      Left = 41
      Top = 111
      Width = 215
      Height = 12
      LargeChange = 25
      Max = 65536
      PageSize = 0
      Position = 750
      SmallChange = 5
      TabOrder = 2
      OnChange = ScrollBarDepthChange
    end
    object Edit1: TEdit
      Left = 118
      Top = 84
      Width = 138
      Height = 21
      NumbersOnly = True
      TabOrder = 3
      Text = '750'
      OnChange = Edit1Change
    end
  end
  object Button1: TButton
    Left = 62
    Top = 250
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object Button2: TButton
    Left = 165
    Top = 250
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 4
  end
end
