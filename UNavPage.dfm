object NavPage: TNavPage
  Left = 0
  Top = 0
  AlphaBlendValue = 200
  BorderStyle = bsSizeToolWin
  Caption = 'navigation'
  ClientHeight = 485
  ClientWidth = 251
  Color = clBtnFace
  Constraints.MinWidth = 267
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
    Width = 251
    Height = 485
    Align = alClient
    BevelOuter = bvNone
    DockSite = True
    TabOrder = 0
    OnResize = Panel2Resize
    ExplicitWidth = 190
    ExplicitHeight = 380
    DesignSize = (
      251
      485)
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
      Width = 211
      Height = 21
      Decimal = 18
      ValueType = vtFloat
      Value = -2.600000000000000000
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = XSpinChange
      ExplicitWidth = 150
    end
    object YSpin: TJvSpinEdit
      Left = 36
      Top = 43
      Width = 211
      Height = 21
      Decimal = 18
      ValueType = vtFloat
      Value = -2.000000000000000000
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      OnChange = YSpinChange
      ExplicitWidth = 150
    end
    object ZSpin: TJvSpinEdit
      Left = 36
      Top = 70
      Width = 211
      Height = 21
      Decimal = 18
      ValueType = vtFloat
      Value = 0.100000000000000000
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      OnChange = ZSpinChange
      ExplicitWidth = 150
    end
    object ListBox1: TListBox
      Left = 0
      Top = 216
      Width = 251
      Height = 269
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      TabOrder = 3
      OnClick = ListBox1Click
      ExplicitHeight = 245
    end
    object Button7: TButton
      Left = 7
      Top = 195
      Width = 20
      Height = 20
      Caption = '+'
      TabOrder = 4
      OnClick = Button7Click
    end
    object Button8: TButton
      Left = 33
      Top = 195
      Width = 20
      Height = 20
      Caption = '-'
      TabOrder = 5
      OnClick = Button8Click
    end
    object Button9: TButton
      Left = 159
      Top = 195
      Width = 44
      Height = 20
      Anchors = [akTop, akRight]
      Caption = 'Save'
      TabOrder = 6
      OnClick = Button9Click
    end
    object Button10: TButton
      Left = 204
      Top = 195
      Width = 44
      Height = 20
      Anchors = [akTop, akRight]
      Caption = 'Load'
      TabOrder = 7
      OnClick = Button10Click
    end
    object Panel1: TPanel
      Left = 53
      Top = 97
      Width = 123
      Height = 92
      BevelOuter = bvNone
      TabOrder = 8
      object Button1: TButton
        Left = 0
        Top = 11
        Width = 25
        Height = 25
        Caption = '+'
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 95
        Top = 11
        Width = 26
        Height = 25
        Caption = '-'
        TabOrder = 1
        OnClick = Button2Click
      end
      object Button3: TButton
        Tag = 2
        Left = 47
        Top = 19
        Width = 25
        Height = 25
        Caption = '^'
        TabOrder = 2
        OnClick = Button6Click
      end
      object Button6: TButton
        Left = 24
        Top = 42
        Width = 25
        Height = 25
        Caption = '<'
        TabOrder = 3
        OnClick = Button6Click
      end
      object Button5: TButton
        Tag = 1
        Left = 70
        Top = 42
        Width = 25
        Height = 25
        Caption = '>'
        TabOrder = 4
        OnClick = Button6Click
      end
      object Button4: TButton
        Tag = 3
        Left = 47
        Top = 66
        Width = 25
        Height = 25
        Caption = 'V'
        TabOrder = 5
        OnClick = Button6Click
      end
    end
    object Button11: TButton
      Left = 114
      Top = 195
      Width = 44
      Height = 20
      Anchors = [akTop, akRight]
      Caption = 'Clear'
      TabOrder = 9
      OnClick = Button11Click
    end
  end
end
