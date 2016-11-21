object ColorForm: TColorForm
  Left = 0
  Top = 0
  Caption = 'Color Sheme'
  ClientHeight = 461
  ClientWidth = 684
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    684
    461)
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 201
    Height = 461
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitHeight = 385
    object ListBox1: TListBox
      Left = 0
      Top = 0
      Width = 201
      Height = 461
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnClick = ListBox1Click
      ExplicitHeight = 435
    end
  end
  object Panel2: TPanel
    Left = 201
    Top = 0
    Width = 483
    Height = 461
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = 193
    ExplicitTop = 24
    ExplicitWidth = 516
    ExplicitHeight = 435
    DesignSize = (
      483
      461)
    object ColorTrB: TJvColorTrackBar
      Left = 5
      Top = 356
      Width = 282
      Height = 16
      BorderStyle = bsSingle
      Max = 255
      OnPosChange = ColorTrRPosChange
      Anchors = [akLeft, akBottom]
    end
    object ColorTrG: TJvColorTrackBar
      Left = 6
      Top = 328
      Width = 281
      Height = 16
      BorderStyle = bsSingle
      ColorTo = clGreen
      Max = 255
      OnPosChange = ColorTrRPosChange
      Anchors = [akLeft, akBottom]
    end
    object ColorTrR: TJvColorTrackBar
      Left = 6
      Top = 299
      Width = 281
      Height = 16
      BorderStyle = bsSingle
      ColorTo = clRed
      Max = 255
      OnPosChange = ColorTrRPosChange
      Anchors = [akLeft, akBottom]
    end
    object ColorTrA: TJvColorTrackBar
      Left = 6
      Top = 383
      Width = 281
      Height = 16
      BorderStyle = bsSingle
      ColorTo = clWhite
      Max = 255
      OnPosChange = ColorTrRPosChange
      Anchors = [akLeft, akBottom]
    end
    object Label1: TLabel
      Left = 291
      Top = 303
      Width = 11
      Height = 12
      Anchors = [akLeft, akBottom]
      Caption = 'R:'
      ExplicitTop = 276
    end
    object Label2: TLabel
      Left = 291
      Top = 332
      Width = 11
      Height = 12
      Anchors = [akLeft, akBottom]
      Caption = 'G:'
      ExplicitTop = 305
    end
    object Label4: TLabel
      Left = 291
      Top = 387
      Width = 11
      Height = 12
      Anchors = [akLeft, akBottom]
      Caption = 'A:'
    end
    object Label5: TLabel
      Left = 291
      Top = 360
      Width = 10
      Height = 12
      Anchors = [akLeft, akBottom]
      Caption = 'B:'
      ExplicitTop = 333
    end
    object Label6: TLabel
      Left = 275
      Top = 424
      Width = 32
      Height = 12
      Anchors = [akLeft, akBottom]
      Caption = 'Width:'
      ExplicitTop = 397
    end
    object ScrollBarLL: TScrollBar
      Left = 6
      Top = 422
      Width = 263
      Height = 16
      Anchors = [akLeft, akBottom]
      LargeChange = 10
      Max = 1000
      PageSize = 0
      Position = 64
      TabOrder = 0
      OnChange = ScrollBarLLChange
      ExplicitTop = 395
    end
    object ColorR: TEdit
      Left = 308
      Top = 301
      Width = 37
      Height = 16
      Anchors = [akLeft, akBottom]
      NumbersOnly = True
      TabOrder = 1
      Text = '0'
      OnChange = ColorRChange
      ExplicitTop = 274
    end
    object ColorG: TEdit
      Left = 308
      Top = 329
      Width = 37
      Height = 16
      Anchors = [akLeft, akBottom]
      NumbersOnly = True
      TabOrder = 2
      Text = '0'
      OnChange = ColorRChange
      ExplicitTop = 302
    end
    object ColorA: TEdit
      Left = 308
      Top = 384
      Width = 37
      Height = 16
      Anchors = [akLeft, akBottom]
      NumbersOnly = True
      TabOrder = 3
      Text = '0'
      OnChange = ColorRChange
    end
    object ColorL: TEdit
      Left = 308
      Top = 421
      Width = 37
      Height = 16
      Anchors = [akLeft, akBottom]
      NumbersOnly = True
      TabOrder = 4
      Text = '0'
      OnChange = ColorLChange
      ExplicitTop = 394
    end
    object chbCycle: TCheckBox
      Left = 6
      Top = 98
      Width = 57
      Height = 17
      Hint = 'Cycle colors'
      Caption = 'Cycle'
      TabOrder = 5
    end
    object edCycleCount: TEdit
      Left = 69
      Top = 98
      Width = 49
      Height = 16
      AutoSize = False
      Color = clWhite
      TabOrder = 6
      Text = '10'
    end
    object ListView1: TListView
      Left = 6
      Top = 121
      Width = 379
      Height = 120
      Columns = <
        item
          Caption = 'R'
        end
        item
          Alignment = taCenter
          Caption = 'G'
        end
        item
          Alignment = taCenter
          Caption = 'B'
        end
        item
          Alignment = taCenter
          Caption = 'A'
        end
        item
          Alignment = taCenter
          Caption = 'Depth'
        end
        item
        end>
      RowSelect = True
      TabOrder = 7
      ViewStyle = vsReport
      OnClick = ListView1Click
      OnCustomDrawSubItem = ListView1CustomDrawSubItem
    end
    object Img2: TImage32
      Left = 383
      Top = 299
      Width = 90
      Height = 80
      Bitmap.ResamplerClassName = 'TNearestResampler'
      BitmapAlign = baTopLeft
      Scale = 1.000000000000000000
      ScaleMode = smNormal
      TabOrder = 8
    end
    object Img1: TImage32
      Left = 6
      Top = 1
      Width = 467
      Height = 91
      Bitmap.ResamplerClassName = 'TNearestResampler'
      BitmapAlign = baTopLeft
      Scale = 1.000000000000000000
      ScaleMode = smNormal
      TabOrder = 9
    end
  end
  object ColorB: TEdit
    Left = 509
    Top = 357
    Width = 37
    Height = 16
    Anchors = [akLeft, akBottom]
    NumbersOnly = True
    TabOrder = 2
    Text = '0'
    OnChange = ColorRChange
    ExplicitTop = 330
  end
end
