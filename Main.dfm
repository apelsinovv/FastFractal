object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Fractal Fantasy'
  ClientHeight = 473
  ClientWidth = 895
  Color = clBtnFace
  UseDockManager = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnMouseWheel = FormMouseWheel
  OnResize = FormResize
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
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 895
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      895
      41)
    object Label1: TLabel
      Left = 69
      Top = 0
      Width = 69
      Height = 13
      Caption = 'Approximation'
    end
    object Label4: TLabel
      Left = 160
      Top = 0
      Width = 64
      Height = 13
      Caption = 'Color scheme'
    end
    object SpeedButton1: TSpeedButton
      Left = 237
      Top = 13
      Width = 23
      Height = 22
      Caption = '...'
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 5
      Top = 13
      Width = 57
      Height = 22
      Caption = 'Settings'
      OnClick = SpeedButton2Click
    end
    object btnControl: TSpeedButton
      Left = 800
      Top = 13
      Width = 79
      Height = 22
      AllowAllUp = True
      Anchors = [akTop, akRight]
      GroupIndex = 1
      Caption = 'Control panel'
      Flat = True
      OnClick = btnControlClick
    end
    object cbApprox: TComboBox
      Left = 70
      Top = 14
      Width = 68
      Height = 21
      Style = csDropDownList
      ItemIndex = 1
      TabOrder = 0
      Text = '2'
      OnChange = cbApproxChange
      Items.Strings = (
        '1'
        '2'
        '4'
        '8'
        '16')
    end
    object cbColorSheme: TComboBox
      Left = 153
      Top = 14
      Width = 82
      Height = 21
      Style = csDropDownList
      TabOrder = 1
      OnChange = cbApproxChange
    end
    object chbQuality: TCheckBox
      Left = 282
      Top = 16
      Width = 59
      Height = 17
      Caption = 'Quality'
      TabOrder = 2
      OnClick = chbQualityClick
    end
    object btnMakeVideo: TButton
      Left = 409
      Top = 10
      Width = 97
      Height = 25
      Caption = 'Make Video'
      Enabled = False
      TabOrder = 3
      OnClick = btnMakeVideoClick
    end
    object Button3: TButton
      Left = 512
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Snapshot'
      TabOrder = 4
    end
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 448
    Width = 895
    Height = 6
    Align = alBottom
    TabOrder = 2
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 454
    Width = 895
    Height = 19
    Panels = <
      item
        Width = 100
      end
      item
        Width = 100
      end
      item
        Width = 100
      end
      item
        Width = 100
      end>
  end
end
