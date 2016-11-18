object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Fractal Fantasy'
  ClientHeight = 473
  ClientWidth = 889
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnMouseWheel = FormMouseWheel
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ImgView321: TImgView32
    Left = 0
    Top = 41
    Width = 720
    Height = 432
    Align = alClient
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baCustom
    Scale = 1.000000000000000000
    ScaleMode = smScale
    ScrollBars.ShowHandleGrip = True
    ScrollBars.Style = rbsDefault
    ScrollBars.Size = 17
    OverSize = 0
    TabOrder = 0
    OnMouseDown = ImgView321MouseDown
    OnMouseMove = ImgView321MouseMove
    OnMouseUp = ImgView321MouseUp
    ExplicitLeft = 161
    ExplicitTop = 161
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 889
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 99
      Top = 2
      Width = 69
      Height = 13
      Caption = 'Approximation'
    end
    object Label2: TLabel
      Left = 33
      Top = 2
      Width = 19
      Height = 13
      Caption = 'Size'
    end
    object Label3: TLabel
      Left = 175
      Top = 2
      Width = 54
      Height = 13
      Caption = 'Antialiasing'
    end
    object Label4: TLabel
      Left = 262
      Top = 2
      Width = 64
      Height = 13
      Caption = 'Color scheme'
    end
    object SpeedButton1: TSpeedButton
      Left = 339
      Top = 15
      Width = 23
      Height = 22
      Caption = '...'
    end
    object Label5: TLabel
      Left = 373
      Top = 2
      Width = 62
      Height = 13
      Caption = 'Interpolation'
    end
    object cbResolution: TComboBox
      Left = 13
      Top = 14
      Width = 81
      Height = 21
      Style = csDropDownList
      ItemIndex = 1
      TabOrder = 0
      Text = '1024x768'
      OnChange = cbApproxChange
      Items.Strings = (
        '800x600'
        '1024x768'
        '1600x1200'
        '2272x1704'
        '3264x2448'
        '4096x3072'
        '9600x7200')
    end
    object cbApprox: TComboBox
      Left = 100
      Top = 16
      Width = 68
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 1
      Text = '1'
      OnChange = cbApproxChange
      Items.Strings = (
        '1'
        '2'
        '4'
        '8'
        '16')
    end
    object cbAntialias: TComboBox
      Left = 175
      Top = 16
      Width = 54
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 2
      Text = '1'
      OnChange = cbApproxChange
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
    object cbColorSheme: TComboBox
      Left = 255
      Top = 16
      Width = 82
      Height = 21
      Style = csDropDownList
      TabOrder = 3
      OnChange = cbApproxChange
    end
    object ComboBox5: TComboBox
      Left = 370
      Top = 16
      Width = 71
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 4
      Text = 'Linear'
      OnChange = cbApproxChange
      Items.Strings = (
        'Linear'
        'Cosine')
    end
  end
  object Panel2: TPanel
    Left = 720
    Top = 41
    Width = 169
    Height = 432
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
    object Label6: TLabel
      Left = 6
      Top = 24
      Width = 10
      Height = 13
      Caption = 'X:'
    end
    object Label7: TLabel
      Left = 6
      Top = 51
      Width = 10
      Height = 13
      Caption = 'Y:'
    end
    object Label8: TLabel
      Left = 6
      Top = 73
      Width = 30
      Height = 13
      Caption = 'Zoom:'
    end
    object Label9: TLabel
      Left = 6
      Top = 101
      Width = 33
      Height = 13
      Caption = 'Depth:'
    end
    object XSpin: TJvSpinEdit
      Left = 42
      Top = 16
      Width = 121
      Height = 21
      Decimal = 8
      ValueType = vtFloat
      Value = -2.600000000000000000
      TabOrder = 0
      OnChange = XSpinChange
    end
    object YSpin: TJvSpinEdit
      Left = 42
      Top = 43
      Width = 121
      Height = 21
      Decimal = 8
      ValueType = vtFloat
      Value = -2.000000000000000000
      TabOrder = 1
      OnChange = YSpinChange
    end
    object ZSpin: TJvSpinEdit
      Left = 42
      Top = 70
      Width = 121
      Height = 21
      Decimal = 8
      ValueType = vtFloat
      Value = 0.100000000000000000
      TabOrder = 2
      OnChange = ZSpinChange
    end
    object ScrollBarDepth: TScrollBar
      Left = 6
      Top = 120
      Width = 153
      Height = 17
      LargeChange = 25
      Max = 65536
      PageSize = 0
      Position = 750
      SmallChange = 5
      TabOrder = 3
      OnChange = ScrollBarDepthChange
    end
    object Edit1: TEdit
      Left = 42
      Top = 97
      Width = 119
      Height = 21
      NumbersOnly = True
      TabOrder = 4
      Text = '750'
      OnChange = Edit1Change
    end
    object chbQuality: TCheckBox
      Left = 6
      Top = 151
      Width = 59
      Height = 17
      Caption = 'Quality'
      TabOrder = 5
      OnClick = chbQualityClick
    end
  end
end
