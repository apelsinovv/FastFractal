unit UNavPage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, JvExMask,
  JvSpin, Vcl.ExtCtrls, math;

type
  TNavPage = class(TForm)
    Panel2: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    XSpin: TJvSpinEdit;
    YSpin: TJvSpinEdit;
    ZSpin: TJvSpinEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    procedure XSpinChange(Sender: TObject);
    procedure YSpinChange(Sender: TObject);
    procedure ZSpinChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NavPage: TNavPage;

implementation
uses main;
{$R *.dfm}

procedure TNavPage.Button1Click(Sender: TObject);
var
 ns, ds:Double;
begin
  with  MainForm do
  begin
    ns:=scale * power(1.2, 1);
    ds := 1/scale - 1/ns;
    scale:=ns;

    posx:=posx  + ds * (hcx / 1024);
    posy:=posy + ds * (hcy / 1024);

    Draw(fQuality);
  end;
end;

procedure TNavPage.Button2Click(Sender: TObject);
var
 ns, ds:Double;
begin
  with  MainForm do
  begin
    ns:=scale * power(1.2, -1);
    ds := 1/scale - 1/ns;
    scale:=ns;

    posx:=posx  + ds * (hcx / 1024);
    posy:=posy + ds * (hcy / 1024);

    Draw(fQuality);
  end;
end;

procedure TNavPage.Button6Click(Sender: TObject);
begin
 with MainForm do
 begin
  case TButton(Sender).tag of
  0: posx := posx + 1 / (1024 * scale);
  1: posx:=posx - 1 / (1024 * scale);
  2: posy:=posy + 1 / (1024 * scale);
  3: posy:=posy - 1 / (1024 * scale);
  end;
   Draw(fQuality);
 end;
end;

procedure TNavPage.XSpinChange(Sender: TObject);
begin
 MainForm.posx := XSpin.Value;
end;

procedure TNavPage.YSpinChange(Sender: TObject);
begin
  MainForm.posy := YSpin.Value;

end;

procedure TNavPage.ZSpinChange(Sender: TObject);
begin
 MainForm.scale := ZSpin.Value;

end;

end.
