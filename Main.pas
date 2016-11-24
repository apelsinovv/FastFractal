unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UFractal, Vcl.StdCtrls, Vcl.ExtCtrls,
  GR32_Image, GR32, GR32_Layers, JvFullColorSpaces, JvExStdCtrls, JvCombobox, JvFullColorCtrls,
  Vcl.Buttons, Vcl.Mask, JvExMask, JvSpin, math, Vcl.ComCtrls, syncobjs,
  Vcl.ToolWin, UnavPage, USettings, IniFiles, UMakeVideo,
  generics.collections;


type

  PNavPoint = ^TNavPoint;
  TNavPoint= record
   x,y,z : Double;
  end;

  TMainForm = class(TForm)
    ImgView: TImgView32;
    Panel1: TPanel;
    cbApprox: TComboBox;
    Label1: TLabel;
    cbColorSheme: TComboBox;
    Label4: TLabel;
    SpeedButton1: TSpeedButton;
    ProgressBar1: TProgressBar;
    chbQuality: TCheckBox;
    StatusBar1: TStatusBar;
    SpeedButton2: TSpeedButton;
    btnControl: TSpeedButton;
    btnMakeVideo: TButton;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormShow(Sender: TObject);
    procedure cbApproxChange(Sender: TObject);
    procedure chbQualityClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnMakeVideoClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btnControlClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
  private
     is_dragged: LongBool;
     is_hqual:LongBool;
      n_nodraw:LongInt;
      fscale:Double;
      fposx:Double;
      fposy:Double;

      fApproxIndex,
      fAntialiasIndex,
      fResolutionIndex: Integer;
      fDepth: Integer;
      FSelection: TPositionedLayer;
      RBLayer: TRubberbandLayer;
      fRedrawIntervalStart: Cardinal;
      fSnapshot,
      fVideo,
      fVideotmp: String;
      fDrawBusy: Boolean;
    procedure onLMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure onLMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure onLMouseMove(Sender: TObject; Shift: TShiftState;
                           X, Y: Integer);

    procedure build_fractal_progress(var message: Tmessage); message WM_FRACTAL_PROGRESS;
    procedure SetDepth(const Value: Integer);
    procedure setAntialiasIndex(const Value: Integer);
    procedure setResolutionIndex(const Value: Integer);
    procedure setApproxIndex(const Value: Integer);

  public
     pdx, pdy, ccx, ccy:Double;//Longint;
     hcx, hcy: Double;
     fQuality: Boolean;

    procedure Draw(Quality: Boolean = false);
    procedure OnDrawFinish(sender: TObject);
    procedure SetSelection(Value: TPositionedLayer);
    procedure setPosx(const Value: Double);
    procedure setPosy(const Value: Double);
    procedure setScale(const Value: Double);
    property posx: Double read fposx write setPosx;
    property posy: Double read fposy write setPosy;
    property scale: Double read fscale write setScale;
    property Selection: TPositionedLayer read FSelection write SetSelection;
    property Depth: Integer read fDepth write SetDepth;
    property ApproxIndex: Integer read fApproxIndex write setApproxIndex;
    property AntialiasIndex: Integer read fAntialiasIndex write setAntialiasIndex;
    property ResolutionIndex: Integer read fResolutionIndex write setResolutionIndex;
    property tmpVideoPath: String read fVideotmp;
    property VideoPath: String read fVideo;
    property snapshotPath: String read fSnapshot;

  end;

  TDrawer = class(TThread)
  private
   fOwnerForm: TMainForm;
   fQuality: Boolean;
   procedure Redraw;
  protected
   procedure execute; override;
  public
   constructor Create(AOwner: TMainForm; onTerm: TNotifyEvent; const Quality:  Boolean = False);
  end;

  TRender = class(TThread)
  private
   fOwnerForm: TWinControl;
   fMainForm: TmainForm;
   fList: TStringList;
   fTmpPath, fVideoPath: String;
  protected
   procedure execute; override;
  public
   constructor Create(const AOwner, aMainForm: TWinControl; const onTerm: TNotifyEvent;const list: TstringList; const TmpPath, VideoPath: String);
  end;


var
  MainForm: TMainForm;
  fractal: TFractal;
  fDrawCS: TCriticalSection;

  const
   cImg_size : array[0..6] of TPoint =
   (
    (x:800; y:600),
    (x:1024; y:768),
    (x:1600; y:1200),
    (x:2272; y:1704),
    (x:3264; y:2448),
    (x:4096; y:3072),
    (x:9600; y:7200)
   );

   cApporox: array[0..4] of integer = (1,2,4,8,16);
   cAntialias: array[0..7] of integer = (1,2,4,8,16,32,64,128);

implementation

uses uSetColor;
{$R *.dfm}



procedure TMainForm.setPosx(const Value: Double);
begin
  if Value<>fposx  then
  begin
    fposx := Value;
    if assigned(NavPage) then
    begin
      NavPage.XSpin.OnChange := nil;
      NavPage.XSpin.Value := fposx;
      NavPage.XSpin.OnChange :=NavPage.XSpinChange;
    end;
  end;
end;

procedure TMainForm.setPosy(const Value: Double);
begin
  if Value<>fposy  then
  begin
    fposy := Value;
    if assigned(NavPage) then
    begin
     NavPage.YSpin.OnChange := nil;
     NavPage.YSpin.Value := fposy;
     NavPage.YSpin.OnChange :=NavPage.YSpinChange;
    end;
  end;
end;

procedure TMainForm.setResolutionIndex(const Value: Integer);
begin
 if fResolutionIndex <> Value then
 begin
  fResolutionIndex := Value;
 end;
end;

procedure TMainForm.setScale(const Value: Double);
begin
  if Value<>fscale  then
  begin
    fscale := Value;
    if assigned(NavPage) then
    begin
     NavPage.ZSpin.OnChange := nil;
     NavPage.ZSpin.Value := fscale;
     NavPage.ZSpin.OnChange :=NavPage.ZSpinChange;
    end;
  end;

end;

procedure TMainForm.SetSelection(Value: TPositionedLayer);
begin
  if Value <> FSelection then
     FSelection := Value;
end;

procedure TMainForm.SpeedButton1Click(Sender: TObject);
var
 i: integer;
begin
 ColorForm := TColorForm.Create(self);
 ColorForm.ShowModal;
 FreeAndNil(ColorForm);
 cbColorSheme.OnChange := nil;
 cbColorSheme.Items.Clear;
 for i := 0 to fractal.ColorSheme.Colorshemas.Count - 1 do
  cbColorSheme.Items.Add(fractal.ColorSheme.Colorshemas.Items[i].Name);
 cbColorSheme.ItemIndex := fractal.ColorSheme.SelectedIndex;
 fractal.ColorSheme.Compile(fractal.ColorSheme.SelectedIndex);
 cbColorSheme.OnChange := cbApproxChange;
 Draw(fQuality);
end;

procedure TMainForm.SpeedButton2Click(Sender: TObject);
begin
 SetFrm := TSetFrm.Create(self);
 SetFrm.cbResolution.ItemIndex := fResolutionIndex;
 SetFrm.cbAntialias.ItemIndex := fAntialiasIndex;
 SetFrm.ScrollBarDepth.Position := fDepth;
 SetFrm.edFileSpan.Text := fSnapshot;
 SetFrm.edFileVideo.Text := fVideo;
 if SetFrm.ShowModal = mrOk then
 begin
  ResolutionIndex := SetFrm.cbResolution.ItemIndex;
  AntialiasIndex := SetFrm.cbAntialias.ItemIndex;
  Depth := SetFrm.ScrollBarDepth.Position;
  fSnapshot := SetFrm.edFileSpan.Text;
  fVideo := SetFrm.edFileVideo.Text;
 end;
end;

procedure TMainForm.btnControlClick(Sender: TObject);
begin
 if btnControl.Down then
 begin
  NavPage.Left := self.Left + self.Width - NavPage.Width;
  NavPage.Top := self.Top + self.Height - NavPage.Height;
  NavPage.Show;
 end else
  NavPage.Close;


end;

procedure TMainForm.Timer1Timer(Sender: TObject);
var
 drwintrv: Cardinal;
 ar: double;
begin
  drwintrv := (GetTickCount - fRedrawIntervalStart);
 if (drwintrv > (1000 * 4)) and (drwintrv < (1000 * 4 + 500)) then
 begin
  ar := fractal.ApproxResolution;
  fractal.ApproxResolution := 1;
   draw(True);
  sleep(10);
//  fractal.ApproxResolution := ar;
 end;
end;

procedure TMainForm.build_fractal_progress(var message: Tmessage);
begin

  ProgressBar1.Position:=ProgressBar1.Max - message.WParam;

end;

procedure TMainForm.btnMakeVideoClick(Sender: TObject);
const
 callign = 1000;
var
 ns, ds, lenx, leny, ideep,
 mposx, mposy,
 mstepx, mstepy,
 zstep:Double;
 point1, point2: PNavPoint;
 newpoint:PNavPoint;
 i: integer;
 slst: TStringList;
function interpolate_linear(a, b, k:Double):Double;
begin
  Result := a * (1 - k) + b * (k);
end;

procedure addNewObject(const x,y,z: double);
begin
  new(newpoint);
  newpoint.x := x;
  newpoint.y := y;
  newpoint.z := z;
  makeVideo.ListBox1.Items.AddObject(format('x:%2.18f-y:%2.18f-z:%2.18f',[newpoint.x, newpoint.y, newpoint.z]), TObject(newpoint));
end;

begin
// step x, y
 //     zstep := scale * power(1.2, 1);
// step scale
    scale := scale * power(1.2, 1);
//    scale:=ns;

 if NavPage.ListBox1.Items.Count > 0 then
 begin
   if assigned(makeVideo) then
    FreeAndnIl(makeVideo);
   makeVideo := TmakeVideo.Create(self);
  try
    for i:=0 to NavPage.ListBox1.Items.Count - 2 do
    begin
      point1 := PNavPoint(NavPage.ListBox1.Items.Objects[i]);
      point2 := PNavPoint(NavPage.ListBox1.Items.Objects[i+1]);

      lenx := (point2.x + callign)  - (point1.X + callign);
      leny := (point2.y + callign)  - (point1.y + callign);

      ideep := point2.z - point1.z;

      if ((lenx > leny) and (lenx > 0)) or
         ((lenx < leny) and (lenx < 0)) then
      begin
//      if (ideep > 0) or (ilen > 0) then
//        new(newpoint);
//        newpoint.x :=  point1.x;
//        newpoint.y :=  point1.y;
//        newpoint.z :=  point1.z;
//        makeVideo.ListBox1.Items.AddObject(format('x:%2.18f-y:%2.18f-z:%2.18f',[newpoint.x, newpoint.y, newpoint.z]), TObject(newpoint));


       zstep := point1.z;
//       mstepx := 100 / (1024 * zstep);//point1.X;
{       while zstep < point2.z do
       begin
        zstep := zstep  * power(1.2, 1);
        mstepy := interpolate_linear(point1.Y, point2.Y, (mstepx - point1.X) / ilen);
        new(newpoint);
        newpoint.x := mstepx;
        newpoint.y := mstepy;
        newpoint.z := zstep;
        makeVideo.ListBox1.Items.AddObject(format('x:%2.18f-y:%2.18f-z:%2.18f',[newpoint.x, newpoint.y, newpoint.z]), TObject(newpoint));
        if mstepx < point2.x then
         mstepx := mstepx + 100 / (1024 * zstep);
       end;
 }
       mposx := point1.X;

       while (
        ((((point2.x + callign) - (mposx + callign)) > 0) and (lenx > 0)) or
        ((((point2.x + callign) - (mposx + callign)) < 0) and (lenx < 0))
       ) do
       begin
        mposy := interpolate_linear(point1.Y, point2.Y, (mposx - point1.X) / lenx);

        addNewObject(mposx, mposy, zstep);

        mstepx := 100 / (1024 * zstep);
        if lenx > 0 then
         mposx := mposx + mstepx
        else
         mposx := mposx - mstepx;
        if (ideep > 0) and (zstep < ideep) then
         zstep := zstep + scale
        else
         if (ideep < 0) and (zstep > ideep) then
          zstep := zstep - scale


       end;
      end else
      begin
       zstep := point1.z;
       mposy := point1.y;

       while (
        ((((point2.y + callign) - (mposy + callign)) > 0) and (leny > 0)) or
        ((((point2.y + callign) - (mposy + callign)) < 0) and (leny < 0))
       ) do
       begin
        mposx := interpolate_linear(point1.x, point2.x, (mposy - point1.y) / leny);

        mstepy := 100 / (1024 * zstep);

        addNewObject(mposx, mposy, zstep);

        if leny > 0 then
         mposy := mposy + mstepy
        else
         mposy := mposy - mstepy;

        if (ideep > 0) and (zstep < ideep) then
         zstep := zstep + scale
        else
         if (ideep < 0) and (zstep > ideep) then
          zstep := zstep - scale

       end;
      end;
    end;

    while ((ideep > 0) and (zstep < ideep)) or
          ((ideep < 0) and (zstep > ideep))  do
    begin
        if (ideep > 0) and (zstep < ideep) then
         zstep := zstep + scale
        else
         if (ideep < 0) and (zstep > ideep) then
          zstep := zstep - scale;

      addNewObject(mposx, mposy, zstep);

    end;


    point1 := PNavPoint(NavPage.ListBox1.Items.Objects[NavPage.ListBox1.Items.Count - 1]);
    addNewObject(point1.x, point1.y, point1.z);

  finally
   makeVideo.ShowModal;
  end;
 end;
end;

procedure TMainForm.Button2Click(Sender: TObject);
var
 ns, ds:Double;
begin

    ns:=scale * power(1.2, -1);
    ds := 1/scale - 1/ns;
    scale:=ns;

    posx:=posx  + ds * (hcx / 1024);
    posy:=posy + ds * (hcy / 1024);

    Draw(fQuality);
    if not fQuality then
     fRedrawIntervalStart := GetTickCount;
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
   posy:=posy + 1 / (1024 * scale);
   Draw(fQuality);
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
   posy:=posy - 1 / (1024 * scale);
   Draw(fQuality);
end;

procedure TMainForm.Button5Click(Sender: TObject);
begin
   posx:=posx - 1 / (1024 * scale);
   Draw(fQuality);
end;

procedure TMainForm.Button6Click(Sender: TObject);
begin
   posx:=posx + 1 / (1024 * scale);
   Draw(fQuality);
end;

procedure TMainForm.cbApproxChange(Sender: TObject);
begin
 Draw(fQuality);
end;

procedure TMainForm.chbQualityClick(Sender: TObject);
begin
 fQuality := chbQuality.Checked;
 Draw(fQuality);
end;

procedure TMainForm.Draw(Quality: Boolean);
var
 fdrawer: TDrawer;
begin
 if not fDrawBusy then
  fdrawer := TDrawer.Create(self, OnDrawFinish, Quality);

end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
 ini: TIniFile;
begin
 ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
 try

   ini.WriteInteger('main','resolution', ResolutionIndex);
   ini.WriteInteger('main','antialiasing', AntialiasIndex);
   ini.WriteInteger('main', 'aproximation', ApproxIndex);
   ini.WriteInteger('main', 'depth', Depth);
   ini.WriteBool('main', 'cntrl', btnControl.Down);
   ini.WriteString('main', 'snap',  fSnapshot);
   ini.WriteString('main', 'video',  fVideo);
   ini.WriteString('main', 'videobuf',  fVideotmp);

 finally
  FreeAndNil(ini);
 end;
 CanClose := true;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  ci: TColorSItem;
  Layer: TBitmapLayer;
  p: TPoint;
  i: integer;
  fn: string;
  ini: TIniFile;
begin
 posx :=-2.74217800;
 posy :=-1.81874501;
 scale := 0.20736000;
 fQuality := False;
 fDrawBusy := False;

 fractal := TFractal.Create(self);
 fractal.Width := cImg_size[ResolutionIndex].X;
 fractal.Height := cImg_size[ResolutionIndex].Y;
 fractal.XPos := posx;
 fractal.YPos := posy;
 fractal.ZScale := scale;

 ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
 try

   ResolutionIndex := ini.ReadInteger('main','resolution', 1);
   AntialiasIndex := ini.ReadInteger('main','antialiasing', 0);
   ApproxIndex := ini.ReadInteger('main', 'aproximation', 1);
   Depth := ini.ReadInteger('main', 'depth', 750);
   btnControl.Down := ini.ReadBool('main', 'cntrl', true);
   fSnapshot := ini.ReadString('main', 'snap',  IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName)) + 'Snapshots');
   fVideo := ini.ReadString('main', 'video',  IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName)) + 'VideoResult');
   fVideotmp := ini.ReadString('main', 'videobuf',  IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName)) + 'tmpbuf');
 finally
  FreeAndNil(ini);
 end;


 fn := ChangeFileExt(Application.ExeName,'.fch');
 if fileexists(fn) then
  fractal.ColorSheme.Read(fn);
 if fractal.ColorSheme.Colorshemas.Count = 0 then
 begin
   ci := TColorSItem.Create(fractal.ColorSheme);
   ci.Colors.Add(TLerpTag.Create(0,0,0,255,64));
   ci.Colors.Add(TLerpTag.Create(255,0,0,255,64));
   ci.Colors.Add(TLerpTag.Create(255,255,0,255,64));
   ci.Colors.Add(TLerpTag.Create(0,255,0,255,64));
   ci.Colors.Add(TLerpTag.Create(0,255,255,255,64));
   ci.Colors.Add(TLerpTag.Create(0,0,255,255,64));
   ci.Colors.Add(TLerpTag.Create(255,0,255,255,64));
   ci.Colors.Add(TLerpTag.Create(255,255,255,255,64));
   ci.Colors.Add(TLerpTag.Create(0,0,0,255,64));
   ci.Colors.Add(TLerpTag.Create(0,0,0,255,64));
   ci.Name := 'Color';
   fractal.SetColorSheme(ci);
 end;
 for I := 0 to fractal.ColorSheme.Colorshemas.Count - 1 do
  cbColorSheme.Items.Add(fractal.ColorSheme.Colorshemas.Items[i].Name);
 cbColorSheme.ItemIndex := fractal.ColorSheme.SelectedIndex;
 ImgView.SetupBitmap(True, clBlack32);

 fDrawCS := TCriticalSection.Create;
end;

procedure TMainForm.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
 ns, ds:Double;
 px, py: double;
begin

    Handled:=True;
    px := posx;
    py := posy;

    ns:=scale * power(1.2, (WheelDelta / 120));
    ds := 1/scale - 1/ns;
    scale:=ns;

    posx:=posx  + ds * (ccx / 1024);
    posy:=posy + ds * (ccy / 1024);


//    inc(n_nodraw);
//    Application.ProcessMessages;
//    dec(n_nodraw);

   if (posx <> px) and (posy <> py) then
   begin
      Draw(fQuality);
   end;

end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  btnControlClick(self);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
 Draw(True);
 btnControlClick(self);
end;

procedure TMainForm.OnDrawFinish(sender: TObject);
begin
 ProgressBar1.Position := 0;
 ImgView.Repaint;
 fDrawBusy := False;
end;

procedure TMainForm.onLMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 fx, fy: Double;
begin
    fx := X - (TPositionedLayer(selection).GetAdjustedLocation.Left);
    fy := Y - (TPositionedLayer(selection).GetAdjustedLocation.Top);
  pdx:=fX;
  pdy:=fY;

  if(Button = mbLeft)then
  begin
    is_dragged:=True;
  end;
end;

procedure TMainForm.onLMouseMove(Sender: TObject; Shift: TShiftState;
                                X, Y: Integer);
var
 fx, fy: Double;
begin

    fx := X - (TPositionedLayer(selection).GetAdjustedLocation.Left);
    fy := Y - (TPositionedLayer(selection).GetAdjustedLocation.Top);

    ccx:=fx;//x;
    ccy:=fy;//y;

    if(is_dragged)then
    begin
      posx:=posx + (pdx - fx) / (1024 * scale);
      posy:=posy + (pdy - fy) / (1024 * scale);

      pdy:=fy;
      pdx:=fx;

      inc(n_nodraw);
      Application.ProcessMessages;
      dec(n_nodraw);

//      if(n_nodraw = 0)then begin
//        Draw(fQuality);
//      end;
    end;
end;

procedure TMainForm.onLMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 fx, fy: Double;
begin
    fx := X - (TPositionedLayer(selection).GetAdjustedLocation.Left);
    fy := Y - (TPositionedLayer(selection).GetAdjustedLocation.Top);
    pdx:=fX;
    pdy:=fY;
    hcx :=  fx;
    hcy := fy;

    if(Button = mbLeft)then
    begin
      is_dragged:=False;
       Draw(fQuality);
      if not fQuality then
        fRedrawIntervalStart := GetTickCount;
    end;
end;

procedure TMainForm.setAntialiasIndex(const Value: Integer);
begin
 if fAntialiasIndex <> Value then
 begin
  fAntialiasIndex := Value;
 end;
end;

procedure TMainForm.setApproxIndex(const Value: Integer);
begin
 if fApproxIndex <> Value then
 begin
  fApproxIndex := Value;
  cbApprox.ItemIndex := fApproxIndex;
 end;
end;

procedure TMainForm.SetDepth(const Value: Integer);
begin
  if fDepth <> value then
  begin
   fDepth := value;
   fractal.Depth := fDepth;
  end;
end;


{ TDrawer }

constructor TDrawer.Create(AOwner: TMainForm; onTerm: TNotifyEvent; const Quality: Boolean);
begin
  fOwnerForm := AOwner;
  fOwnerForm.fDrawBusy := True;
  fQuality := Quality;
  FreeOnTerminate := true;
  OnTerminate := onTerm;
  inherited Create(False);
end;

procedure TDrawer.Redraw;
var
 layer: TBitmapLayer;
 P: TPoint;
 W, H: Single;
begin
 if not assigned(fOwnerForm) then Exit;
 with fOwnerForm do
 begin
  fDrawCS.Acquire;
  try
   ProgressBar1.Position:=0;
   ProgressBar1.Max:= Cimg_size[fResolutionIndex].Y;
   fractal.Width := Cimg_size[fResolutionIndex].X;
   fractal.Height := Cimg_size[fResolutionIndex].Y;
   fractal.ApproxResolution := cApporox[cbApprox.ItemIndex];
   fractal.Antialiasing := cAntialias[fAntialiasIndex];
   fractal.Depth := fDepth;
   fractal.ColorSheme.SelectedIndex := cbColorSheme.ItemIndex;
   fractal.XPos := fposx;
   fractal.YPos := fposy;
   fractal.ZScale := fscale;

    with ImgView do
    begin
     if Layers.Count = 0 then
     begin
       layer := TBitmapLayer.Create(ImgView.Layers);
       layer.Bitmap.CombineMode := cmMerge;
       layer.Bitmap.DrawMode := dmBlend;
       layer.OnMouseDown := onLMouseDown;
       layer.OnMouseMove := onLMouseMove;
       layer.OnMouseUp := onLMouseUp;
     end else
       layer := TBitmapLayer(Selection);
      with layer do
      begin
        w := fractal.Width * 0.5;
        h := fractal.Height * 0.5;

        with ImgView.GetViewportRect do
            P := ImgView.ControlToBitmap(Point(Width div 2, Height div 2));
        with ImgView.Bitmap do
         Location := GR32.FloatRect(P.X - w, P.Y - h, P.X + w, P.Y + h);
        Scaled := True;
      end;

      Selection := layer;
      Scale := 1;
    end;


   if fQuality then
   begin
    fractal.QualityDraw(layer.Bitmap)
   end else
   begin
    fractal.PreviewDraw(layer.Bitmap);
   end;
  finally
    fDrawCS.Release;
  end;
 end;
end;

procedure TDrawer.execute;
begin
  Redraw;
end;

{ TRender }

constructor TRender.Create(const AOwner, aMainForm: TWinControl; const onTerm: TNotifyEvent;
  const list: TstringList; const TmpPath, VideoPath: String);
begin
  fOwnerForm := AOwner;
  fMainForm := TMainForm(aMainForm);
  FreeOnTerminate := true;
  fList := list;
  fTmpPath := TmpPath;
  fVideoPath := VideoPath;
  OnTerminate := onTerm;
  inherited Create(False);
end;

procedure TRender.execute;
var
 P: TPoint;
 W, H: Single;
 np: PNavPoint;
 i: integer;
 bmp: TBitmap32;
begin
 if not assigned(fOwnerForm) then Exit;
 with fOwnerForm do
 begin
  try
   fractal.Width := Cimg_size[fMainForm.ResolutionIndex].X;
   fractal.Height := Cimg_size[fMainForm.ResolutionIndex].Y;
   fractal.ApproxResolution := 1;
   fractal.Antialiasing := cAntialias[fMainForm.AntialiasIndex];
   fractal.Depth := fMainForm.Depth;
   fractal.ColorSheme.SelectedIndex := fMainForm.cbColorSheme.ItemIndex;
   for I := 0 to flist.Count - 1 do
   begin
    np := PNavPoint(flist.Objects[i]);
    if Assigned(np) then
    begin
       bmp := TBitmap32.Create;
       try
         fractal.XPos := np.x;
         fractal.YPos := np.y;
         fractal.ZScale := np.z;
         fractal.QualityDraw(bmp);
         if not DirectoryExists(fTmpPath) then
          ForceDirectories(fTmpPath);
         bmp.SaveToFile(IncludeTrailingPathDelimiter(fTmpPath) +  format('%s-%.5d.bmp',[TMakeVideo(fOwnerForm).Edit1.Text, i]));
       finally
        FreeAndNil(bmp);
       end;
      PostMessage(fOwnerForm.Handle, WM_RENDER_ITEM, i, 0);
    end;
   end;
  finally
    fDrawCS.Release;
  end;
 end;
end;

end.
