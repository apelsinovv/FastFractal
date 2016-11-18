unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UFractal, Vcl.StdCtrls, Vcl.ExtCtrls,
  GR32_Image, GR32, GR32_Layers, JvFullColorSpaces, JvExStdCtrls, JvCombobox, JvFullColorCtrls,
  Vcl.Buttons, Vcl.Mask, JvExMask, JvSpin, math;

type
  TForm1 = class(TForm)
    ImgView: TImgView32;
    Panel1: TPanel;
    Panel2: TPanel;
    cbResolution: TComboBox;
    cbApprox: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    cbAntialias: TComboBox;
    Label3: TLabel;
    cbColorSheme: TComboBox;
    Label4: TLabel;
    SpeedButton1: TSpeedButton;
    ComboBox5: TComboBox;
    Label5: TLabel;
    XSpin: TJvSpinEdit;
    YSpin: TJvSpinEdit;
    ZSpin: TJvSpinEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ScrollBarDepth: TScrollBar;
    Label9: TLabel;
    Edit1: TEdit;
    chbQuality: TCheckBox;
    Label10: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure XSpinChange(Sender: TObject);
    procedure YSpinChange(Sender: TObject);
    procedure ZSpinChange(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormShow(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure ScrollBarDepthChange(Sender: TObject);
    procedure cbApproxChange(Sender: TObject);
    procedure chbQualityClick(Sender: TObject);
  private
     pdx, pdy, ccx, ccy:Double;//Longint;
     is_dragged: LongBool;
     is_hqual:LongBool;
      n_nodraw:LongInt;
      fscale:Double;
      fposx:Double;
      fposy:Double;
      fQuality: Boolean;
      FSelection: TPositionedLayer;
      RBLayer: TRubberbandLayer;

    procedure onLMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure onLMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure onLMouseMove(Sender: TObject; Shift: TShiftState;
                           X, Y: Integer);

    procedure SetSelection(Value: TPositionedLayer);
    procedure Redraw(const FQoality:  Boolean = False);
    procedure setPosx(const Value: Double);
    procedure setPosy(const Value: Double);
    procedure setScale(const Value: Double);
    property posx: Double read fposx write setPosx;
    property posy: Double read fposy write setPosy;
    property scale: Double read fscale write setScale;
    property Selection: TPositionedLayer read FSelection write SetSelection;

  public
    { Public declarations }
  end;

var
  Form1: TForm1;
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

{$R *.dfm}

procedure TForm1.Redraw(const FQoality: Boolean = False);
var
 layer: TBitmapLayer;
 P: TPoint;
 W, H: Single;
begin

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
//    Layers.Clear;
    Scale := 1;
//    Bitmap := fractal.ResultBitmap32;
//    Bitmap.SetSize(fractal.ResultBitmap32.Width, fractal.ResultBitmap32.Height);
//    Bitmap.Clear(clBlack32);
//    Bitmap.Assign(fractal.ResultBitmap32);
  end;


 if FQoality then
 begin
  fractal.QualityDraw(layer.Bitmap)
 end else
 begin
  fractal.PreviewDraw(layer.Bitmap);
//    layer.Bitmap.Assign(fractal.ResultBitmap32);
 end;

// if assigned(fractal.ResultBitmap32) then
// begin
// end;
end;

procedure TForm1.ScrollBarDepthChange(Sender: TObject);
begin
 Edit1.Text := IntToStr(ScrollBarDepth.Position);
end;

procedure TForm1.setPosx(const Value: Double);
begin
  if Value<>fposx  then
  begin
    fposx := Value;
    XSpin.OnChange := nil;
    XSpin.Value := fposx;
    XSpin.OnChange :=XSpinChange;
  end;
end;

procedure TForm1.setPosy(const Value: Double);
begin
  if Value<>fposy  then
  begin
    fposy := Value;
    YSpin.OnChange := nil;
    YSpin.Value := fposy;
    YSpin.OnChange :=YSpinChange;
  end;
end;

procedure TForm1.setScale(const Value: Double);
begin
  if Value<>fscale  then
  begin
    fscale := Value;
    ZSpin.OnChange := nil;
    ZSpin.Value := fscale;
    ZSpin.OnChange :=ZSpinChange;
  end;

end;

procedure TForm1.SetSelection(Value: TPositionedLayer);
begin
  if Value <> FSelection then
  begin
{    if RBLayer <> nil then
    begin
      RBLayer.ChildLayer := nil;
      RBLayer.LayerOptions := LOB_NO_UPDATE;
      ImgView.Invalidate;
    end;
}
     FSelection := Value;

{    if Value <> nil then
    begin
      if RBLayer = nil then
      begin
        RBLayer := TRubberBandLayer.Create(ImgView.Layers);
        RBLayer.MinHeight := 1;
        RBLayer.MinWidth := 1;
      end
      else RBLayer.BringToFront;
      RBLayer.ChildLayer := Value;
      RBLayer.LayerOptions := LOB_VISIBLE or LOB_MOUSE_EVENTS or LOB_NO_UPDATE;
      RBLayer.OnResizing := RBResizing;

      if Value is TBitmapLayer then
        with TBitmapLayer(Value) do
        begin
          pnlBitmapLayer.Visible := True;
          LayerOpacity.Position := Bitmap.MasterAlpha;
          LayerInterpolate.Checked := Bitmap.Resampler.ClassType = TDraftResampler;
        end
}
  end;

end;

procedure TForm1.cbApproxChange(Sender: TObject);
begin
 Redraw(fQuality);
end;

procedure TForm1.chbQualityClick(Sender: TObject);
begin
 fQuality := chbQuality.Checked;
 Redraw(fQuality);
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
 fractal.Depth := StrToInt(Edit1.Text);
end;

procedure TForm1.FormCreate(Sender: TObject);
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

//  Application.HintColor := clGrayText;
  Application.HintPause := 250;
  Application.HintHidePause := 9000;


 fractal := TFractal.Create;
 fractal.Width := cImg_size[1].X;
 fractal.Height := cImg_size[1].Y;
 fractal.XPos := posx;
 fractal.YPos := posy;
 fractal.ZScale := scale;

 ci := TColorSItem.Create;
 ci.Colors.Add(TLerpTag.Create(0,0,0,0,64));
 ci.Colors.Add(TLerpTag.Create(255,0,0,0,64));
 ci.Colors.Add(TLerpTag.Create(255,255,0,0,64));
 ci.Colors.Add(TLerpTag.Create(0,255,0,0,64));
 ci.Colors.Add(TLerpTag.Create(0,255,255,0,64));
 ci.Colors.Add(TLerpTag.Create(0,0,255,0,64));
 ci.Colors.Add(TLerpTag.Create(255,0,255,0,64));
 ci.Colors.Add(TLerpTag.Create(255,255,255,0,64));
 ci.Colors.Add(TLerpTag.Create(0,0,0,0,64));
 ci.Colors.Add(TLerpTag.Create(0,0,0,0,64));
 ci.Name := 'Color';
 fractal.SetColorSheme(ci);

 for I := 0 to fractal.ColorSheme.Colorshemas.Count - 1 do
  cbColorSheme.Items.Add(fractal.ColorSheme.Colorshemas.Items[i].Name);
 cbColorSheme.ItemIndex := fractal.ColorSheme.SelectedIndex;
 ImgView.SetupBitmap(True, clWhite32);
end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var ns, ds:Double;
begin

    Handled:=True;

    ns:=scale * power(1.2, (WheelDelta / 120));
    ds := 1/scale - 1/ns;
    scale:=ns;

    posx:=posx  + ds * (ccx / 1024);
    posy:=posy + ds * (ccy / 1024);


    inc(n_nodraw);
    Application.ProcessMessages;
    dec(n_nodraw);

    if(n_nodraw = 0)then
      Redraw(fQuality)


end;

procedure TForm1.FormShow(Sender: TObject);
begin
 Redraw(fQuality);
end;

procedure TForm1.onLMouseDown(Sender: TObject; Button: TMouseButton;
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

procedure TForm1.onLMouseMove(Sender: TObject; Shift: TShiftState;
                                X, Y: Integer);
var
 fx, fy: Double;
begin

    fx := X - (TPositionedLayer(selection).GetAdjustedLocation.Left);
    fy := Y - (TPositionedLayer(selection).GetAdjustedLocation.Top);

    ccx:=fx;//x;
    ccy:=fy;//y;
//    Label10.Caption := 'X = ' + IntToStr(x) + '; Y = ' + IntToStr(Y);

    if(is_dragged)then
    begin
      posx:=posx + (pdx - fx) / (1024 * scale);
      posy:=posy + (pdy - fy) / (1024 * scale);

      pdy:=fy;
      pdx:=fx;

      inc(n_nodraw);
      Application.ProcessMessages;
      dec(n_nodraw);

      if(n_nodraw = 0)then begin
        Redraw(fQuality);
      end;
    end;
end;

procedure TForm1.onLMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 fx, fy: Double;
begin
    fx := X - (TPositionedLayer(selection).GetAdjustedLocation.Left);
    fy := Y - (TPositionedLayer(selection).GetAdjustedLocation.Top);
    pdx:=fX;
    pdy:=fY;
    if(Button = mbLeft)then begin
      is_dragged:=False;
    end;
end;

procedure TForm1.XSpinChange(Sender: TObject);
begin
 fposx := XSpin.Value;
end;

procedure TForm1.YSpinChange(Sender: TObject);
begin
  fposy := YSpin.Value;
end;

procedure TForm1.ZSpinChange(Sender: TObject);
begin
 fscale := ZSpin.Value;
end;

end.
