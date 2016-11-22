object ColorForm: TColorForm
  Left = 0
  Top = 0
  Caption = 'Color Sheme'
  ClientHeight = 471
  ClientWidth = 661
  Color = clBtnFace
  Constraints.MinWidth = 677
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    661
    471)
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 201
    Height = 471
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitHeight = 461
    DesignSize = (
      201
      471)
    object ListBox1: TListBox
      Left = 0
      Top = 0
      Width = 201
      Height = 443
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      TabOrder = 0
      OnClick = ListBox1Click
      ExplicitHeight = 446
    end
    object Button1: TButton
      Left = 0
      Top = 443
      Width = 65
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Add '
      TabOrder = 1
      OnClick = Button1Click
      ExplicitTop = 447
    end
    object Button2: TButton
      Left = 64
      Top = 443
      Width = 41
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Delete'
      TabOrder = 2
    end
    object Button3: TButton
      Left = 105
      Top = 443
      Width = 40
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Save'
      TabOrder = 3
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 145
      Top = 443
      Width = 40
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Load'
      TabOrder = 4
      OnClick = Button4Click
    end
  end
  object Panel2: TPanel
    Left = 201
    Top = 0
    Width = 460
    Height = 471
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 483
    ExplicitHeight = 461
    DesignSize = (
      460
      471)
    object ColorTrB: TJvColorTrackBar
      Left = 5
      Top = 357
      Width = 282
      Height = 16
      BorderStyle = bsSingle
      Max = 255
      OnPosChange = ColorTrRPosChange
      Anchors = [akLeft, akBottom]
      ExplicitTop = 360
    end
    object ColorTrG: TJvColorTrackBar
      Left = 6
      Top = 333
      Width = 281
      Height = 16
      BorderStyle = bsSingle
      ColorTo = clGreen
      Max = 255
      OnPosChange = ColorTrRPosChange
      Anchors = [akLeft, akBottom]
      ExplicitTop = 336
    end
    object ColorTrR: TJvColorTrackBar
      Left = 6
      Top = 309
      Width = 281
      Height = 16
      BorderStyle = bsSingle
      ColorTo = clRed
      Max = 255
      OnPosChange = ColorTrRPosChange
      Anchors = [akLeft, akBottom]
      ExplicitTop = 299
    end
    object ColorTrA: TJvColorTrackBar
      Left = 6
      Top = 381
      Width = 281
      Height = 16
      BorderStyle = bsSingle
      ColorTo = clWhite
      Max = 255
      OnPosChange = ColorTrRPosChange
      Anchors = [akLeft, akBottom]
      ExplicitTop = 384
    end
    object Label1: TLabel
      Left = 291
      Top = 313
      Width = 11
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'R:'
      ExplicitTop = 303
    end
    object Label2: TLabel
      Left = 291
      Top = 336
      Width = 11
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'G:'
      ExplicitTop = 339
    end
    object Label4: TLabel
      Left = 291
      Top = 384
      Width = 11
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'A:'
      ExplicitTop = 387
    end
    object Label5: TLabel
      Left = 292
      Top = 360
      Width = 10
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'B:'
      ExplicitTop = 363
    end
    object Label6: TLabel
      Left = 275
      Top = 434
      Width = 32
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Width:'
      ExplicitTop = 424
    end
    object Label7: TLabel
      Left = 273
      Top = 411
      Width = 29
      Height = 13
      Caption = 'Color:'
    end
    object ScrollBarLL: TScrollBar
      Left = 6
      Top = 432
      Width = 263
      Height = 16
      Anchors = [akLeft, akBottom]
      LargeChange = 10
      Max = 1000
      PageSize = 0
      Position = 64
      TabOrder = 0
      OnChange = ScrollBarLLChange
      ExplicitTop = 422
    end
    object ColorR: TEdit
      Left = 333
      Top = 310
      Width = 37
      Height = 21
      Anchors = [akLeft, akBottom]
      NumbersOnly = True
      TabOrder = 1
      Text = '0'
      OnChange = ColorRChange
      ExplicitTop = 313
    end
    object ColorG: TEdit
      Left = 333
      Top = 333
      Width = 37
      Height = 21
      Anchors = [akLeft, akBottom]
      NumbersOnly = True
      TabOrder = 2
      Text = '0'
      OnChange = ColorRChange
      ExplicitTop = 336
    end
    object ColorA: TEdit
      Left = 333
      Top = 381
      Width = 37
      Height = 21
      Anchors = [akLeft, akBottom]
      NumbersOnly = True
      TabOrder = 3
      Text = '0'
      OnChange = ColorRChange
      ExplicitTop = 384
    end
    object ColorL: TEdit
      Left = 333
      Top = 430
      Width = 37
      Height = 21
      Anchors = [akLeft, akBottom]
      NumbersOnly = True
      TabOrder = 4
      Text = '0'
      OnChange = ColorLChange
      ExplicitTop = 433
    end
    object chbCycle: TCheckBox
      Left = 6
      Top = 98
      Width = 57
      Height = 17
      Hint = 'Cycle colors'
      Caption = 'Cycle'
      TabOrder = 5
      OnClick = chbCycleClick
    end
    object edCycleCount: TEdit
      Left = 51
      Top = 99
      Width = 46
      Height = 16
      AutoSize = False
      Color = clWhite
      TabOrder = 6
      Text = '10'
      OnChange = chbCycleClick
    end
    object ListView1: TListView
      Left = 6
      Top = 126
      Width = 372
      Height = 165
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = <
        item
          Caption = 'Num'
        end
        item
          Alignment = taCenter
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
      OnDeletion = ListView1Deletion
      ExplicitWidth = 364
      ExplicitHeight = 168
    end
    object Img2: TImage32
      Left = 384
      Top = 309
      Width = 70
      Height = 65
      Anchors = [akRight, akBottom]
      Bitmap.DrawMode = dmBlend
      Bitmap.CombineMode = cmMerge
      Bitmap.ResamplerClassName = 'TNearestResampler'
      BitmapAlign = baTopLeft
      Scale = 1.000000000000000000
      ScaleMode = smNormal
      TabOrder = 8
      ExplicitLeft = 376
      ExplicitTop = 312
    end
    object Img1: TImage32
      Left = 0
      Top = 0
      Width = 460
      Height = 91
      Align = alTop
      Bitmap.DrawMode = dmBlend
      Bitmap.CombineMode = cmMerge
      Bitmap.ResamplerClassName = 'TNearestResampler'
      BitmapAlign = baTopLeft
      Scale = 1.000000000000000000
      ScaleMode = smOptimal
      TabOrder = 9
      ExplicitLeft = 6
      ExplicitTop = 1
      ExplicitWidth = 443
    end
    object Panel3: TPanel
      Left = 104
      Top = 94
      Width = 245
      Height = 27
      BevelInner = bvSpace
      BevelOuter = bvLowered
      TabOrder = 10
      object Label3: TLabel
        Left = 5
        Top = 6
        Width = 62
        Height = 13
        Caption = 'Interpolation'
      end
      object rbInterpolation: TRadioButton
        Left = 108
        Top = 5
        Width = 54
        Height = 17
        Caption = 'Linear'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = chbCycleClick
      end
      object rbCosine: TRadioButton
        Left = 176
        Top = 5
        Width = 57
        Height = 17
        Caption = 'Cosine'
        TabOrder = 1
        OnClick = chbCycleClick
      end
    end
    object btnAdd: TButton
      Left = 384
      Top = 141
      Width = 65
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Add color'
      TabOrder = 11
      OnClick = btnAddClick
      ExplicitLeft = 376
    end
    object btnDelete: TButton
      Left = 384
      Top = 196
      Width = 65
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Delete Color'
      Enabled = False
      TabOrder = 12
      OnClick = btnDeleteClick
      ExplicitLeft = 376
    end
    object edFullColor: TEdit
      Left = 333
      Top = 408
      Width = 65
      Height = 21
      TabOrder = 13
      OnChange = edFullColorChange
      OnClick = edFullColorClick
    end
    object btnRepaint: TButton
      Left = 379
      Top = 93
      Width = 77
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Apply'
      TabOrder = 14
      OnClick = btnRepaintClick
      ExplicitLeft = 371
    end
    object chbAutoR: TCheckBox
      Left = 381
      Top = 118
      Width = 84
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Auto Apply'
      TabOrder = 15
      ExplicitLeft = 373
    end
    object btnInsert: TButton
      Left = 384
      Top = 172
      Width = 65
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Insert color'
      Enabled = False
      TabOrder = 16
      OnClick = btnInsertClick
      ExplicitLeft = 376
    end
    object btnUp: TButton
      Left = 384
      Top = 226
      Width = 25
      Height = 23
      Anchors = [akTop, akRight]
      Caption = '^'
      Enabled = False
      TabOrder = 17
      OnClick = btnUpClick
      ExplicitLeft = 376
    end
    object btnDown: TButton
      Left = 384
      Top = 250
      Width = 25
      Height = 23
      Anchors = [akTop, akRight]
      Caption = 'V'
      Enabled = False
      TabOrder = 18
      OnClick = btnDownClick
      ExplicitLeft = 376
    end
  end
  object ColorB: TEdit
    Left = 534
    Top = 357
    Width = 37
    Height = 21
    Anchors = [akLeft, akBottom]
    NumbersOnly = True
    TabOrder = 2
    Text = '0'
    OnChange = ColorRChange
    ExplicitTop = 360
  end
end
