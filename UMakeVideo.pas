unit UMakeVideo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, ufractal;

  const
   WM_RENDER_ITEM = WM_FRACTAL_PROGRESS + 1;

type
  TMakeVideo = class(TForm)
    ListBox1: TListBox;
    ProgressBar1: TProgressBar;
    Edit1: TEdit;
    Label1: TLabel;
    Panel1: TPanel;
    Button1: TButton;
    procedure Panel1Resize(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure onTermit(sender: TObject);
    procedure ProgressRender(var message: TMessage); message  WM_RENDER_ITEM;


  public
    { Public declarations }
  end;

var
  MakeVideo: TMakeVideo;

implementation
uses main, UNavPage;
{$R *.dfm}


procedure TMakeVideo.Button1Click(Sender: TObject);
begin
  ProgressBar1.Position := 0;
  ProgressBar1.Max := ListBox1.Items.Count;
  TRender.Create(self, MainForm, onTermit, TstringList(ListBox1.Items), MainForm.tmpVideoPath, MainForm.VideoPath);
end;

procedure TMakeVideo.ListBox1Click(Sender: TObject);
var
 np: PNavPoint;
begin
 np :=  PNavPoint(ListBox1.Items.Objects[ListBox1.ItemIndex]);
 if assigned(np) then
 begin
   NavPage.XSpin.Value := np.x;
   NavPage.YSpin.Value := np.y;
   NavPage.ZSpin.Value := np.z;
   MainForm.Draw(MainForm.fQuality);
 end;
end;

procedure TMakeVideo.onTermit(sender: TObject);
begin
 ProgressBar1.Position := 0;
end;

procedure TMakeVideo.Panel1Resize(Sender: TObject);
begin
 Button1.Left := Panel1.Left + (Panel1.Width div 2 - Button1.Width div 2);
end;

procedure TMakeVideo.ProgressRender(var message: TMessage);
begin
 ProgressBar1.Position := message.WParam;
end;

end.
