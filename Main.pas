unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UFractal, Vcl.StdCtrls, Vcl.ExtCtrls,
  GR32_Image, GR32, GR32_Layers, JvFullColorSpaces, JvExStdCtrls, JvCombobox, JvFullColorCtrls,
  Vcl.Buttons, Vcl.Mask, JvExMask, JvSpin, math, Vcl.ComCtrls, syncobjs,
  Vcl.ToolWin, UnavPage;

type
  TMainForm = class(TForm)
    ImgView: TImgView32;
    Panel1: TPanel;
    cbResolution: TComboBox;
    cbApprox: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    cbAntialias: TComboBox;
    Label3: TLabel;
    cbColorSheme: TComboBox;
    Label4: TLabel;
    SpeedButton1: TSpeedButton;
    ProgressBar1: TProgressBar;
    ScrollBarDepth: TScrollBar;
    Edit1: TEdit;
    Label9: TLabel;
    chbQuality: TCheckBox;
    StatusBar1: TStatusBar;
    SpeedButton2: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure ZSpinChange(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormShow(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure ScrollBarDepthChange(Sender: TObject);
    procedure cbApproxChange(Sender: TObject);
    procedure chbQualityClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
     is_dragged: LongBool;
     is_hqual:LongBool;
      n_nodraw:LongInt;
      fscale:Double;
      fposx:Double;
      fposy:Double;
      FSelection: TPositionedLayer;
      RBLayer: TRubberbandLayer;
      fDrawCS: TCriticalSection;
      fRedrawIntervalStart: Cardinal;
    procedure onLMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure onLMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure onLMouseMove(Sender: TObject; Shift: TShiftState;
                           X, Y: Integer);

    procedure build_fractal_progress(var message: Tmessage); message WM_FRACTAL_PROGRESS;

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



var
  MainForm: TMainForm;
  fractal: TFractal;

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


procedure TMainForm.ScrollBarDepthChange(Sender: TObject);
begin
 Edit1.Text := IntToStr(ScrollBarDepth.Position);
end;

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
 cbColorSheme.OnChange := cbApproxChange;
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

procedure TMainForm.Button1Click(Sender: TObject);
var
 ns, ds:Double;
begin

    ns:=scale * power(1.2, 1);
    ds := 1/scale - 1/ns;
    scale:=ns;

    posx:=posx  + ds * (hcx / 1024);
    posy:=posy + ds * (hcy / 1024);

    Draw(fQuality);
    if not fQuality then
     fRedrawIntervalStart := GetTickCount;

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
 fdrawer := TDrawer.Create(self, OnDrawFinish, Quality);

end;

procedure TMainForm.Edit1Change(Sender: TObject);
begin
 fractal.Depth := StrToInt(Edit1.Text);
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  ci: TColorSItem;
  Layer: TBitmapLayer;
  p: TPoint;
  i: integer;
begin
 posx :=-2.74217800;
 posy :=-1.81874501;
 scale := 0.20736000;
 fQuality := False;


 fractal := TFractal.Create(self);
 fractal.Width := cImg_size[1].X;
 fractal.Height := cImg_size[1].Y;
 fractal.XPos := posx;
 fractal.YPos := posy;
 fractal.ZScale := scale;

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
    if not fQuality then
     fRedrawIntervalStart := GetTickCount;
   end;

end;

procedure TMainForm.FormShow(Sender: TObject);
begin
 Draw(True);
 NavPage.Show;
end;

procedure TMainForm.OnDrawFinish(sender: TObject);
begin
 ProgressBar1.Position := 0;
 ImgView.Repaint;
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

procedure TMainForm.ZSpinChange(Sender: TObject);
begin
end;

{ TDrawer }

constructor TDrawer.Create(AOwner: TMainForm; onTerm: TNotifyEvent; const Quality: Boolean);
begin
  fOwnerForm := AOwner;
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
   ProgressBar1.Max:= Cimg_size[cbResolution.ItemIndex].Y;
   fractal.Width := Cimg_size[cbResolution.ItemIndex].X;
   fractal.Height := Cimg_size[cbResolution.ItemIndex].Y;
   fractal.ApproxResolution := cApporox[cbApprox.ItemIndex];
   fractal.Antialiasing := cAntialias[cbAntialias.ItemIndex];
   fractal.Depth := StrToInt(Edit1.Text);
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

end.