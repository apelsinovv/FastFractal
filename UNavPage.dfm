object NavPage: TNavPage
  Left = 0
  Top = 0
  AlphaBlendValue = 200
  BorderStyle = bsSizeToolWin
  Caption = 'navigation'
  ClientHeight = 380
  ClientWidth = 169
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  GlassFrame.Enabled = True
  GlassFrame.SheetOfGlass = True
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 169
    Height = 380
    Align = alClient
    BevelOuter = bvNone
    DockSite = True
    TabOrder = 0
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
    object XSpin: TJvSpinEdit
      Left = 36
      Top = 16
      Width = 129
      Height = 21
      Decimal = 20
      ValueType = vtFloat
      Value = -2.600000000000000000
      TabOrder = 0
      OnChange = XSpinChange
    end
    object YSpin: TJvSpinEdit
      Left = 36
      Top = 43
      Width = 130
      Height = 21
      Decimal = 20
      ValueType = vtFloat
      Value = -2.000000000000000000
      TabOrder = 1
      OnChange = YSpinChange
    end
    object ZSpin: TJvSpinEdit
      Left = 36
      Top = 70
      Width = 129
      Height = 21
      Decimal = 20
      ValueType = vtFloat
      Value = 0.100000000000000000
      TabOrder = 2
      OnChange = ZSpinChange
    end
    object Button1: TButton
      Left = 30
      Top = 101
      Width = 25
      Height = 25
      Caption = '+'
      TabOrder = 3
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 121
      Top = 101
      Width = 26
      Height = 25
      Caption = '-'
      TabOrder = 4
      OnClick = Button2Click
    end
    object Button3: TButton
      Tag = 2
      Left = 74
      Top = 115
      Width = 25
      Height = 25
      Caption = '^'
      TabOrder = 5
      OnClick = Button6Click
    end
    object Button4: TButton
      Tag = 3
      Left = 74
      Top = 161
      Width = 25
      Height = 25
      Caption = 'V'
      TabOrder = 6
      OnClick = Button6Click
    end
    object Button5: TButton
      Tag = 1
      Left = 98
      Top = 138
      Width = 25
      Height = 25
      Caption = '>'
      TabOrder = 7
      OnClick = Button6Click
    end
    object Button6: TButton
      Left = 51
      Top = 138
      Width = 25
      Height = 25
      Caption = '<'
      TabOrder = 8
      OnClick = Button6Click
    end
    object ListBox1: TListBox
      Left = 0
      Top = 216
      Width = 169
      Height = 164
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      TabOrder = 9
      OnClick = ListBox1Click
    end
    object Button7: TButton
      Left = 7
      Top = 195
      Width = 20
      Height = 20
      Caption = '+'
      TabOrder = 10
      OnClick = Button7Click
    end
    object Button8: TButton
      Left = 29
      Top = 195
      Width = 20
      Height = 20
      Caption = '-'
      TabOrder = 11
      OnClick = Button8Click
    end
    object Button9: TButton
      Left = 72
      Top = 195
      Width = 44
      Height = 20
      Caption = 'Save'
      TabOrder = 12
      OnClick = Button9Click
    end
    object Button10: TButton
      Left = 122
      Top = 195
      Width = 44
      Height = 20
      Caption = 'Load'
      TabOrder = 13
      OnClick = Button10Click
    end
  end
end
