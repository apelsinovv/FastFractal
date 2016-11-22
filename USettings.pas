unit USettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, JvExMask,
  JvToolEdit;

type
  TSetFrm = class(TForm)
    edFileSpan: TJvFilenameEdit;
    Label1: TLabel;
    Label2: TLabel;
    edFileVideo: TJvFilenameEdit;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    cbResolution: TComboBox;
    Label4: TLabel;
    cbAntialias: TComboBox;
    Label9: TLabel;
    ScrollBarDepth: TScrollBar;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure ScrollBarDepthChange(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SetFrm: TSetFrm;

implementation
uses main;
{$R *.dfm}

procedure TSetFrm.Edit1Change(Sender: TObject);
begin
 MainForm.Depth := StrToInt(Edit1.Text);
end;

procedure TSetFrm.ScrollBarDepthChange(Sender: TObject);
begin
 Edit1.Text := IntToStr(ScrollBarDepth.Position);
end;

end.
