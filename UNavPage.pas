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
    ListBox1: TListBox;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button6: TButton;
    Button5: TButton;
    Button4: TButton;
    Button11: TButton;
    procedure XSpinChange(Sender: TObject);
    procedure YSpinChange(Sender: TObject);
    procedure ZSpinChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Panel2Resize(Sender: TObject);
    procedure Button11Click(Sender: TObject);
  private
    procedure videobtnRefresh;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NavPage: TNavPage;

implementation
uses main;
{$R *.dfm}

procedure TNavPage.Button10Click(Sender: TObject);
var
 dlg: TOpenDialog;
 rd: TReader;
 strm: TFileStream;
 str: String;
 np: PNavPoint;
begin
  dlg := TOpenDialog.Create(self);
  try
    dlg.InitialDir := ExtractFilePath(application.ExeName);
    dlg.DefaultExt := '.pth';
    dlg.Filter := '*.pth';
    if dlg.Execute then
    begin
     while ListBox1.Items.Count > 0 do
     begin
       np := PNavPoint(ListBox1.Items.Objects[0]);
       if assigned(np) then
        dispose(np);
       ListBox1.Items.Delete(0);
     end;

      strm := TFileStream.Create(dlg.FileName, fmOpenRead);
      rd := TReader.Create(strm, 512);
      try
        rd.ReadListBegin;
        while not rd.EndOfList do
        begin
         str := rd.ReadString;
         new(np);
         np.hcx := rd.ReadDouble;
         np.hcy := rd.ReadDouble;
         np.x := rd.ReadDouble;
         np.y := rd.ReadDouble;
         np.z := rd.ReadDouble;
         ListBox1.Items.AddObject(str, Tobject(np));
        end;
        rd.ReadListEnd;
      finally
        FreeAndNil(rd);
        FreeAndNil(strm);
      end;
    end;
  finally
    FreeAndNil(dlg);
  end;
 videobtnRefresh;
end;

procedure TNavPage.Button11Click(Sender: TObject);
var
 np: PNavPoint;
begin
 while ListBox1.Items.Count > 0 do
 begin
  np := PNavPoint(ListBox1.Items.Objects[0]);
  dispose(np);
  ListBox1.Items.Delete(0);
 end;
end;

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
  0: posx := posx - 10 / (1024 * scale);
  1: posx:=posx + 10 / (1024 * scale);
  2: posy:=posy + 10 / (1024 * scale);
  3: posy:=posy - 10 / (1024 * scale);
  end;
   Draw(fQuality);
 end;
end;

procedure  TNavPage.videobtnRefresh;
begin
 if ListBox1.Items.Count > 1 then
  MainForm.btnMakeVideo.Enabled := True
 else
  MainForm.btnMakeVideo.Enabled := False

end;

procedure TNavPage.Button7Click(Sender: TObject);
var
 navpoint: PNavPoint;
begin
 new(navpoint);
  navpoint.hcx := MainForm.hcx;
  navpoint.hcy := MainForm.hcy;
  navpoint.x := MainForm.posx;
  navpoint.y := MainForm.posy;
  navpoint.z := MainForm.scale;
  ListBox1.AddItem(format('hcx:%f-hcy:%f x:%2.18f-y:%2.18f-z:%2.18f',[navpoint.hcx, navpoint.hcy, navpoint.x, navpoint.y, navpoint.z]), Tobject(navpoint));
  videobtnRefresh;
end;

procedure TNavPage.Button8Click(Sender: TObject);
var
 navpoint: PNavPoint;
begin
 if ListBox1.ItemIndex < 0 then exit;

  navpoint := PNavPoint(ListBox1.Items.Objects[ListBox1.ItemIndex]);
  dispose(navpoint);
  ListBox1.Items.Delete(ListBox1.ItemIndex);
 videobtnRefresh;
end;

procedure TNavPage.Button9Click(Sender: TObject);
var
 dlg: TSaveDialog;
 wrt: TWriter;
 strm: TFileStream;
 i: integer;
begin
  dlg := TSaveDialog.Create(self);
  try
    dlg.InitialDir := ExtractFilePath(application.ExeName);
    dlg.DefaultExt := '.pth';
    dlg.Filter := 'Path file(*.pth)|*.pth';
    if dlg.Execute then
    begin
      strm := TFileStream.Create(dlg.FileName, fmcreate);
      wrt := TWriter.Create(strm, 512);
      try
        wrt.WriteListBegin;
        for I := 0 to ListBox1.Items.Count - 1 do
        begin
         wrt.WriteString(ListBox1.Items.Strings[i]);
         wrt.WriteDouble(PNavPoint(ListBox1.Items.Objects[i]).hcx);
         wrt.WriteDouble(PNavPoint(ListBox1.Items.Objects[i]).hcy);
         wrt.WriteDouble(PNavPoint(ListBox1.Items.Objects[i]).x);
         wrt.WriteDouble(PNavPoint(ListBox1.Items.Objects[i]).y);
         wrt.WriteDouble(PNavPoint(ListBox1.Items.Objects[i]).z);
        end;
        wrt.WriteListEnd;
        wrt.FlushBuffer;
      finally
        FreeAndNil(wrt);
        FreeAndNil(strm);
      end;
    end;
  finally
    FreeAndNil(dlg);
  end;
end;

procedure TNavPage.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MainForm.btnControl.Down := false;
  Action := caHide;
end;

procedure TNavPage.ListBox1Click(Sender: TObject);
var
 np: PNavPoint;
begin
 np :=  PNavPoint(ListBox1.Items.Objects[ListBox1.ItemIndex]);
 if assigned(np) then
 begin
   XSpin.Value := np.x;
   YSpin.Value := np.y;
   ZSpin.Value := np.z;
   MainForm.Draw(MainForm.fQuality);
 end;
end;

procedure TNavPage.Panel2Resize(Sender: TObject);
begin
 panel1.Left := panel2.Left + (panel2.Width div 2 - panel1.Width div 2);
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
