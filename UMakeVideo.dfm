object MakeVideo: TMakeVideo
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Make video'
  ClientHeight = 414
  ClientWidth = 332
  Color = clBtnFace
  Constraints.MinHeight = 355
  Constraints.MinWidth = 332
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    332
    414)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 19
    Width = 27
    Height = 13
    Caption = 'Name'
  end
  object ListBox1: TListBox
    Left = 0
    Top = 43
    Width = 332
    Height = 329
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvNone
    BevelOuter = bvNone
    ItemHeight = 13
    TabOrder = 0
    OnClick = ListBox1Click
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 407
    Width = 332
    Height = 7
    Align = alBottom
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 59
    Top = 16
    Width = 265
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = 'Amazing_fractal'
  end
  object Panel1: TPanel
    Left = 0
    Top = 372
    Width = 332
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    OnResize = Panel1Resize
    object Button1: TButton
      Left = 120
      Top = 6
      Width = 75
      Height = 25
      BiDiMode = bdLeftToRight
      Caption = 'Start'
      ParentBiDiMode = False
      TabOrder = 0
      OnClick = Button1Click
    end
  end
end
