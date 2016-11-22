object NavPage: TNavPage
  Left = 0
  Top = 0
  AlphaBlend = True
  AlphaBlendValue = 200
  BorderStyle = bsDialog
  Caption = 'navigation'
  ClientHeight = 191
  ClientWidth = 171
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 171
    Height = 191
    Align = alClient
    BevelOuter = bvNone
    DockSite = True
    TabOrder = 0
    ExplicitHeight = 193
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
    object Button1: TButton
      Left = 26
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
  end
end
