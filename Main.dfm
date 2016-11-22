object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Fractal Fantasy'
  ClientHeight = 473
  ClientWidth = 895
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
  object ImgView: TImgView32
    Left = 0
    Top = 41
    Width = 895
    Height = 407
    Align = alClient
    Bitmap.DrawMode = dmBlend
    Bitmap.CombineMode = cmMerge
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baCustom
    Color = clBlack
    ParentColor = False
    ParentShowHint = False
    Scale = 1.000000000000000000
    ScaleMode = smScale
    ScrollBars.ShowHandleGrip = True
    ScrollBars.Style = rbsDefault
    ScrollBars.Size = 17
    ShowHint = False
    OverSize = 0
    TabOrder = 0
    ExplicitLeft = 8
    ExplicitTop = -31
    ExplicitWidth = 720
    ExplicitHeight = 426
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 895
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = -8
    ExplicitTop = 64
    object Label1: TLabel
      Left = 147
      Top = 0
      Width = 69
      Height = 13
      Caption = 'Approximation'
    end
    object Label2: TLabel
      Left = 85
      Top = 0
      Width = 19
      Height = 13
      Caption = 'Size'
    end
    object Label3: TLabel
      Left = 223
      Top = 0
      Width = 54
      Height = 13
      Caption = 'Antialiasing'
    end
    object Label4: TLabel
      Left = 302
      Top = 0
      Width = 64
      Height = 13
      Caption = 'Color scheme'
    end
    object SpeedButton1: TSpeedButton
      Left = 379
      Top = 13
      Width = 23
      Height = 22
      Caption = '...'
      OnClick = SpeedButton1Click
    end
    object Label9: TLabel
      Left = 422
      Top = 0
      Width = 33
      Height = 13
      Caption = 'Depth:'
    end
    object SpeedButton2: TSpeedButton
      Left = 8
      Top = 13
      Width = 57
      Height = 22
      Caption = 'Settings'
    end
    object cbResolution: TComboBox
      Left = 60
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
      Left = 148
      Top = 14
      Width = 68
      Height = 21
      Style = csDropDownList
      ItemIndex = 1
      TabOrder = 1
      Text = '2'
      OnChange = cbApproxChange
      Items.Strings = (
        '1'
        '2'
        '4'
        '8'
        '16')
    end
    object cbAntialias: TComboBox
      Left = 223
      Top = 14
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
      Left = 295
      Top = 14
      Width = 82
      Height = 21
      Style = csDropDownList
      TabOrder = 3
      OnChange = cbApproxChange
    end
    object ScrollBarDepth: TScrollBar
      Left = 422
      Top = 19
      Width = 251
      Height = 12
      LargeChange = 25
      Max = 65536
      PageSize = 0
      Position = 750
      SmallChange = 5
      TabOrder = 4
      OnChange = ScrollBarDepthChange
    end
    object Edit1: TEdit
      Left = 679
      Top = 12
      Width = 48
      Height = 21
      NumbersOnly = True
      TabOrder = 5
      Text = '750'
      OnChange = Edit1Change
    end
    object chbQuality: TCheckBox
      Left = 733
      Top = 16
      Width = 59
      Height = 17
      Caption = 'Quality'
      TabOrder = 6
      OnClick = chbQualityClick
    end
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 448
    Width = 895
    Height = 6
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 467
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 454
    Width = 895
    Height = 19
    Panels = <>
    ExplicitLeft = -8
    ExplicitTop = 467
  end
end
