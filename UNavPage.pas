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
    ListBox1: TListBox;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
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

procedure TNavPage.Button10Click(Sender: TObject);
var
 dlg: TOpenDialog;
 rd: TReader;
 strm: TFileStream;
 str: String;
 np: PNavPoint;
 i: integer;
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

procedure TNavPage.Button7Click(Sender: TObject);
var
 navpoint: PNavPoint;
begin
 new(navpoint);
  navpoint.x := MainForm.posx;
  navpoint.y := MainForm.posy;
  navpoint.z := MainForm.scale;
  ListBox1.AddItem(format('x:%f-y:%f-z:%f',[navpoint.x, navpoint.y, navpoint.z]), Tobject(navpoint));
end;

procedure TNavPage.Button8Click(Sender: TObject);
var
 navpoint: PNavPoint;
begin
 if ListBox1.ItemIndex < 0 then exit;

  navpoint := PNavPoint(ListBox1.Items.Objects[ListBox1.ItemIndex]);
  dispose(navpoint);
  ListBox1.Items.Delete(ListBox1.ItemIndex);

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
