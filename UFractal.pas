unit UFractal;

interface

uses
Windows,
Messages,
SysUtils,
Variants,
Classes,
Math,
Graphics,
GR32,
FastDIB,
FastGate,
Controls,
Generics.Collections,
UITypes;

const
  cTimeOut = 1000 * 60 * 60 * 24;

type

  TTraceBufferHeader = packed record
    magic:DWORD;
    width, height, aa_level, tdepth: LongInt;
    re, im, zoom:Double;
    map:array[0..0]of single;
  end;

  PTraceBuffer = ^TTraceBuffer;
  TTraceBuffer = packed record
    width,
    height,
    aa_level,
    tdepth: LongInt;
    re,
    im,
    zoom:Double;
  end;

  PRGBA = ^TRGBA;
  TRGBA = packed record
    case LongInt of
      0:(b,g,r,a:Byte);
      1:(color:LongInt);
  end;

  TRGBAF = packed record
    b,g,r,a:Single;
  end;

  TLerpTag = record
    a,r,g,b:Single;
    llength:Longint;
  constructor Create(_r, _g, _b, _a: Single; _llength: LongInt);
  end;



  PTraceMap = ^TTraceMap;
  TTraceMap = array [0..0] of Single;

  PGradientoFloat = ^TGradientoFloat;
  TGradientoFloat = array[0..0]of TRGBAF;

  TInterpolation = (ipLenear, ipCosine);
  TResultType = (rtBmp, rtBmp32, rtFastDIB);

  PLerpTagArray = ^TLerpTagArray;
  TLerpTagArray = array [0..$FFF] of TLerpTag;



  TMandelbrotMap = class(TThread)
  private
    fSender: TObject;
    fMap: PTraceMap;
    fRoundWidth,
    fRoundHeight: Integer;
    fpixelUnitH,
    fpixelUnitW: Integer;
    fxstart, fystart, fzscale: Double;
    fzdepth: Integer;
  protected
   procedure Execute; override;
  public
    class function cb_progress(sender:TObject; p: Integer): LongBool; stdcall; static;
    constructor Create(sender: TObject; const map:PTraceMap; const RoundWidth, RoundHeight: Integer;
                                  const pixelUnitH, pixelUnitW: Integer;
                                  const xstart, ystart, zscale, approx: Double;
                                  const zdepth: Integer);
  end;

  TColorSItem = class
  private
   fName: ShortString;
   fColors: TList<TLerpTag>;
   fCycle: Boolean;
   fCycleCount: Integer;
  protected
   destructor Destroy; override;
  public
   constructor Create;
   property Name: ShortString read fName write fName;
   property Colors: TList<TLerpTag> read fColors;
   property Cycle: Boolean read fCycle write fCycle;
   property CycleCount: Integer read fCycleCount write fCycleCount;
  end;

  TColorSheme = class
   const
    fcl_gradiento_maxi = $FFFF;
  strict private
   flerp_factor0: PLerpTagArray;
   flerp_factor: PLerpTagArray;
   fGradientoFloat0: PGradientoFloat;
   fGradientoFloat: PGradientoFloat;
   fColorshemas: TList<TColorSItem>;
//   fDefaultIndex: Integer;
   fSelectedIndex: Integer;
   fInterpolation: TInterpolation;
   fMandelbrotDepth: LongInt;
   procedure reinit_color_factor(const index, lerp_len: Integer);
   procedure SetDefaultColorSheme;
  protected
   destructor Destroy; override;
  public
   constructor Create(const SetDefaultColors: Boolean = true);
   function Compile(const index: Integer): PGradientoFloat;
   property Colorshemas: TList<TColorSItem> read fColorshemas;
   property SelectedIndex: Integer read fSelectedIndex write fSelectedIndex;
   property GradientFloat: PGradientoFloat read fGradientoFloat;
   property Interpolation: TInterpolation read fInterpolation write fInterpolation;
   property FractalDepth: LongInt read fMandelbrotDepth;

  end;

  TInterpolate = class(TThread)
  private
   ftmp_map,
   fmap: PTraceMap;
   fwidth, fheight,
   fRoundWidth,
   ffarX, fpixelUnit: Integer;
  protected
   procedure Execute; override;
  public
   constructor Create(tmp_map:PTraceMap; map:PTraceMap; const width,height, RoundWidth, farX, pixelUnit:Longint);
  end;

  TRasterizer = class(TThread)
  private
   fmap: PTraceMap;
   fbmp: TBitmap;
   fcl_gradiento_float: PGradientoFloat;
   fWidth,
   fHeight,
   fzskip: LongInt;
    procedure fractal_map_rasterize(b: TBitmap; map: PTraceMap;
      cl_gradiento_float: PGradientoFloat; w, h, zskip: Integer);
  protected
   procedure Execute; override;
  public
   constructor Create(bmp:TBitmap; map:PTraceMap; cl_gradiento_float: PGradientoFloat; const width,height, zskip:Longint);
  end;


  TIntFunction = function(a, b, k:Double):Double;

  TFractal = class
  private
   fColorSheme: TColorSheme;
   fxstart,fystart, fzscale:Double;
   fApproxResolution: Single;
   fDepth: LongInt;
   fSkip: LongInt;
   fResolution: LongInt;
   fAntialiasing: LongInt;

   fHeight, fWidth: LongInt;
   fRoundHeight, fRoundWidth,
   fPixelUnit: LongInt;

   fbuffer_w:LongInt;
   fbuffer_h:LongInt;
   fbuffer_val_min:Longint;
   fbuffer_val_max:Longint;
   pref_freq: Int64;

//   fcl_gradiento_float0:PGradientoFloat;
//   fcl_gradiento_float:PGradientoFloat;

//   fcl_gradiento_buffer:array[0 .. 65536]of TRGBAF;
//   fcl_gradiento_maxi:Longint;
//   fcl_gradiento_default:Longint;

   fbitmap: TBitmap;
   fBitmap32: TBitmap32;
   fFastDib: TFastDIB;

   fResultType: TResultType;

   fmap0:PTraceMap;
   fmap:PTraceMap;

//   fcl_lerp_factor:PLerpTagArray;
//   fcl_lerp_factor_len:Longint;

//   g_mandelbrot_depth:Longint;
   g_mandelbrot_skip:Longint;

   fqdrawFlag: Boolean;

   farx: Longint;

   procedure buffer_trace_init(const w,h:Longint);

  protected
   destructor Destroy; override;
  public
   constructor Create;

   procedure PreviewDraw(const ResultType: TResultType = rtBmp32);
   procedure QualityDraw(const ResultType: TResultType = rtBmp32);
   function SetColorSheme(ci: TColorSItem; const interpolation: TInterpolation = ipLenear): Boolean; overload;
   function SetColorSheme(const index: Integer; const interpolation: TInterpolation = ipLenear): Boolean; overload;
   function SetColorSheme(const name: String; const interpolation: TInterpolation = ipLenear): Boolean; overload;

   property ApproxResolution: Single read fApproxResolution write fApproxResolution;
   property Antialiasing: LongInt read fAntialiasing write fAntialiasing;
   property Resolution: LongInt read fResolution write fResolution;
//   property Interpolation: TInterpolation read fInterpolation write fInterpolation;
   property Depth: LongInt read fDepth write fDepth;
   property ColorSkip: LongInt read fSkip write fSkip;
   property Height: LongInt read fHeight write fHeight;
   property Width: LongInt read fWidth write fWidth;
   property ResultType: TResultType read fResultType write fResultType;
   property ResultBitmap: TBitmap read fbitmap;
   property ResultBitmap32: TBitmap32 read fbitmap32;
   property ResultFastDib: TFastDIB read fFastDib;
   property ColorSheme: TColorSheme read fColorSheme;
   property XPos: Double read fxstart write fxstart;
   property YPos: Double read fystart write fystart;
   property ZScale: Double read fzscale write fzscale;
  end;

 var
    fFinishedEvent: THandle;

implementation

function int_linear(a, b, k:Double):Double;
begin
  result := a * (1 - k) + b * k;
end;

function int_cosine(a, b, k:Double):Double;
begin
  result := (a + b + (a - b) * cos(pi * k)) / 2;
end;

function rgbaf(r,g,b,a:single):DWORD;
begin
  Result:=(byte(round(a*255)) shl 24) or (byte(ceil(r*255)) shl 16) or (byte(floor(g*255)) shl 8) or (byte(round(b*255)));
end;


procedure aligned_get_mem(var p1, p2:Pointer; count, edge:LongInt);
begin
  GetMem(p1, count + edge);
  p2:=Pointer((DWORD(p1) + edge) and (not (edge - 1)));
end;

//ôóíêöèÿ ìîæåò ðàáîòàòü òîëüêî ñ êàðòàìè, ñ øèðèíîé êðàòíîé 4-ì
//âûðàâíåííóþ ïàìÿòü ìû ãîòîâèì â äðóãîì ìåñòå
procedure fractal_mandelbrot_fast(sender: TObject; map:PTraceMap; nmax, w,h, wu,hu:LongInt; xstart,ystart, zscale:Double) stdcall;
var
cconst:Double;
t0, t1:Double;
begin
  cconst:=8.0;
  asm
    {$I ./inc/mandelbrot_fast.asm}
  end;
end;


procedure fractal_map_adjust(fmap:PTraceMap; w,h:Longint; var vmin,vmax:Longint);
var i,j,wy,tmx,tmm:Longint;
begin
  vmin:=Floor(fmap[0]);
  vmax:=Ceil(fmap[0]);

  for j:=0 to h - 1 do begin
    wy:=j * w;

    for i:=0 to w - 1 do begin
      tmx:=Ceil(fmap[wy + i]);
      tmm:=Floor(fmap[wy + i]);

      if(vmin > tmm)then begin
        vmin:=tmm;
      end;

      if(vmax < tmx)then begin
        vmax:=tmx;
      end;
    end;
  end;

  //for a great juice
  vmax := vmax + 1;

end;


{ TMandelBrot }



class function TMandelbrotMap.cb_progress(sender:TObject; p: Integer): LongBool;
var
 res: integer;
begin
   res := TFractal(sender).fDepth;
 //
// PostMessage(
//  Form1.ProgressBar1.Position:=Form1.ProgressBar1.Max - p;

  result:=GetAsyncKeyState(VK_ESCAPE) < 0;
end;

constructor TMandelbrotMap.Create(sender: TObject;const map:PTraceMap;const RoundWidth, RoundHeight: Integer;
                                  const pixelUnitH, pixelUnitW: Integer;
                                  const xstart, ystart, zscale, approx: Double;
                                  const zdepth: Integer);
begin
   fSender := sender;
   fmap := map;
   fRoundWidth := RoundWidth;
   fRoundHeight := RoundHeight;
   fpixelUnitH := pixelUnitH;
   fpixelUnitW := pixelUnitW;
   fxstart := xstart;
   fystart := ystart;
   fzscale := zscale;
   fzdepth := zdepth;
   FreeOnTerminate := true;
   inherited Create(True);
end;

procedure TMandelbrotMap.Execute;
begin
 try
  fractal_mandelbrot_fast(fSender, fmap, fzdepth, fRoundWidth, fRoundHeight, fpixelUnitW, fpixelUnitH, fxstart, fystart, fzscale);
 finally
  setEvent(fFinishedEvent);
 end;
end;


{ TFractal }

procedure TFractal.buffer_trace_init(const w, h: Integer);
begin
  if(fmap0 <> nil)then
  begin
    FreeMem(fmap0);
    fmap0 := nil;
  end;
  aligned_get_mem(Pointer((@fmap0)^), Pointer((@fmap)^), w * h * 4, 16);
end;

constructor TFractal.Create;
var pnull:Pointer;
begin
  randomize;
  Set8087CW($1FF);
  SetErrorMode(SEM_NOOPENFILEERRORBOX or SEM_NOGPFAULTERRORBOX or SEM_NOALIGNMENTFAULTEXCEPT or SEM_FAILCRITICALERRORS);
  QueryPerformanceFrequency(pref_freq);

 g_mandelbrot_skip := 0;
 fAntialiasing := 1;
 fqdrawFlag := False;
 fApproxResolution := 1;
 fResolution := 1024;
 fDepth := 750;

 fWidth := 1024;
 fHeight := 1024;

 fbuffer_val_min := 0;
 fbuffer_val_max := 0;
 fSkip := 0;

 fxstart := -2.6;
 fystart := -2;
 fzscale := 0.1;

// g_mandelbrot_depth := 0;
 g_mandelbrot_skip := 0;

// fcl_gradiento_float := nil;
// fcl_lerp_factor := nil;
 fmap := nil;

 fbitmap := nil;
 fBitmap32 := nil;
 fFastDib := nil;

 fFinishedEvent := CreateEvent(nil, True, False, nil);




 fColorSheme := TColorSheme.Create;

end;

destructor TFractal.Destroy;
begin
  CloseHandle(fFinishedEvent);

  if(fmap0 <> nil)then
  begin
    FreeMem(fmap0);
    fmap0 := nil;
  end;
// if assigned(fcl_gradiento_float) then
//  FreeMem(fcl_gradiento_float);
 if assigned(fColorSheme) then
  FreeAndNil(fColorSheme);
  inherited;
end;




procedure TFractal.PreviewDraw(const ResultType: TResultType);
var map:PTraceMap;
po:Pointer;
b: TBitmap;
ix, iy:Longint;
line, pixel, l_pixel:PRGBA;
//z:TComplex;
t0, t1:Double;
zmw:Longint;
zmh:Longint;

zmz,dfax:Longint;

maxmw, maxmh:Longint;
miy,rarx,farx:Longint;

i:Longint;
j:Longint;

approx:Single;
apfrac:Single;
aplwr:Longint;
widx:Longint;
buffer_val_min, buffer_val_max: integer;

fmandelbortMap: TMandelbrotMap;
begin

  rarx:=round(fApproxResolution);
  farx:=round(1/fApproxResolution);

  if(ColorSheme.FractalDepth = 0)then begin
    exit;
  end;


  zmw:=Floor(fWidth / fApproxResolution);
  zmh:=Floor(fHeight / fApproxResolution);

  zmz:=Floor(1024 / fApproxResolution);

  //ðîâíÿåì ðàçìåðû
  zmw:=zmw - zmw mod 4;
  zmh:=zmh - zmh mod 4;

  //ðàçìåðû êàðòèíêè è îêíà
  maxmw:=round(zmw * fApproxResolution);
  maxmh:=round(zmh * fApproxResolution);


  aligned_get_mem(po, Pointer(map), zmw * zmh * sizeof(single), 16);

  b:=TBitmap.Create;

  b.PixelFormat:=pf32bit;

  b.Width:=maxmw;
  b.Height:=maxmh;


  //ProgressBar1.Max:=zmh;
  //ProgressBar1.Position:=0;


//  fractal_mandelbrot_fast(map, ColorSheme.FractalDepth + g_mandelbrot_skip, zmw, zmh, zmz, zmz, fxstart, fystart, fzscale);
  ResetEvent(fFinishedEvent);
  fmandelbortMap := TMandelbrotMap.Create(self, map, zmw, zmh, zmz, zmz, fxstart, fystart,  fzscale, 1 / fAntialiasing , ColorSheme.FractalDepth + g_mandelbrot_skip);
  fResultType := ResultType;
  fmandelbortMap.Start;

  if WaitForSingleObject(fFinishedEvent, cTimeOut ) = WAIT_TIMEOUT then
  begin
    TerminateThread(fmandelbortMap.Handle, 1);
    FreeAndNil(fmandelbortMap);
    exit;
  end;

//    fractal_map_adjust(map,zmw, zmh, buffer_val_min, buffer_val_max);


  g_mandelbrot_skip := ColorSheme.FractalDepth + g_mandelbrot_skip;


  for iy:=0 to zmh - 1 do begin
    for ix := 0 to zmw - 1 do begin

      miy:=iy * zmw;

      if(round(map[miy + ix]) < g_mandelbrot_skip)then begin
        g_mandelbrot_skip := round(map[miy + ix]);
      end;
    end;
  end;


  dfax:=farx * farx;


  for iy:=0 to maxmh - 1 do begin
    line := b.ScanLine[iy];

    if(fApproxResolution >= 1)then
    begin
      miy:=iy div rarx * zmw;
    end;

    for ix := 0 to maxmw - 1 do
    begin
      pixel := pointer(dword(line) + ix * 4);

      widx:=round(map[miy + ix div rarx]);

      pixel.color :=rgbaf(
        ColorSheme.GradientFloat[widx - g_mandelbrot_skip].r,
        ColorSheme.GradientFloat[widx - g_mandelbrot_skip].g,
        ColorSheme.GradientFloat[widx - g_mandelbrot_skip].b,
        ColorSheme.GradientFloat[widx - g_mandelbrot_skip].a

      );
    end;
  end;

 case fResultType of
   rtBmp: fbitmap := b;
   rtBmp32: begin
             fbitmap32 := TBitmap32.Create;
             fbitmap32.SetSize(b.Width, b.Height);
             fbitmap32.Assign(b);
             freeAndNil(b);
            end;
   rtFastDIB: begin
               fFastDib := TFastDIB.Create(fbuffer_w, fbuffer_h, 32);
               Bitmap2FastDIB(b,fFastDib);
               freeAndNil(b);
              end;
 end;

//  b.Free;

  FreeMem(po);
end;

procedure TFractal.QualityDraw(const ResultType: TResultType = rtBmp32);
var
 bmp: TBitmap;
 tmpp, tmpo:PTraceMap;
 fmandelbortMap: TMandelbrotMap;
 finterpolate: TInterpolate;
 frasterize: TRasterizer;
 buffer_val_min, buffer_val_max: Integer;
begin
  fqdrawFlag := True;
  fbuffer_w := fWidth and not 3;
  fbuffer_h := fHeight and not 3;

  buffer_trace_init(fbuffer_w, fbuffer_h);

  if((1 / fAntialiasing) > 1)then  exit;

  farx := round(fAntialiasing);
  fRoundHeight := Round(fbuffer_h) * farx;
  fRoundWidth := Round(fbuffer_w) * farx;
  fPixelUnit := 1024 * farx;

  aligned_get_mem(Pointer((@tmpo)^), Pointer((@tmpp)^), fRoundWidth * fRoundHeight * 4, 16);

  ResetEvent(fFinishedEvent);

  fmandelbortMap := TMandelbrotMap.Create(self, tmpp, fbuffer_w, fbuffer_h, fPixelUnit, 1024, fxstart, fystart,  fzscale, 1 / fAntialiasing , fDepth);
  fResultType := ResultType;
  fmandelbortMap.Start;

  if WaitForSingleObject(fFinishedEvent, cTimeOut ) = WAIT_TIMEOUT then
  begin
    TerminateThread(fmandelbortMap.Handle, 1);
    FreeAndNil(fmandelbortMap);
    exit;
  end;


  ResetEvent(fFinishedEvent);
  finterpolate := TInterpolate.Create(tmpp, fmap, fbuffer_w, fbuffer_h, fRoundWidth, farx, fPixelUnit);
  finterpolate.Start;

  if WaitForSingleObject(fFinishedEvent, cTimeOut ) = WAIT_TIMEOUT then
  begin
    TerminateThread(finterpolate.Handle, 1);
    FreeAndNil(finterpolate);
    exit;
  end;

  FreeMem(tmpo);

  fractal_map_adjust(fmap, fbuffer_w, fbuffer_h, buffer_val_min, buffer_val_max);

 bmp := TBitmap.Create;

 ResetEvent(fFinishedEvent);

 frasterize := TRasterizer.Create(bmp, fmap, ColorSheme.GradientFloat, fbuffer_w, fbuffer_h, fSkip);
 frasterize.Start;
 if WaitForSingleObject(fFinishedEvent, cTimeOut ) = WAIT_TIMEOUT then
 begin
    TerminateThread(frasterize.Handle, 1);
    FreeAndNil(frasterize);
    exit;
 end;

 ResetEvent(fFinishedEvent);

 case fResultType of
   rtBmp: fbitmap := bmp;
   rtBmp32: begin
             fbitmap32 := TBitmap32.Create;
             fbitmap32.Assign(bmp);
             freeAndNil(bmp);
            end;
   rtFastDIB: begin
               fFastDib := TFastDIB.Create(fbuffer_w, fbuffer_h, 32);
               Bitmap2FastDIB(bmp,fFastDib);
               freeAndNil(bmp);
              end;
 end;
// freemem(fmap0);
end;


function TFractal.SetColorSheme(const name: String; const interpolation: TInterpolation = ipLenear): Boolean;
var
 ci: TColorSItem;
begin
  result := false;
 for ci in ColorSheme.Colorshemas do
  if CompareText(ci.Name , name) = 0 then
  begin
    ColorSheme.Interpolation := interpolation;
    ColorSheme.Compile(ColorSheme.Colorshemas.IndexOf(ci));
    ColorSheme.SelectedIndex := ColorSheme.Colorshemas.IndexOf(ci);
    result := true;
    break;
  end;
end;

function TFractal.SetColorSheme(ci: TColorSItem; const interpolation: TInterpolation = ipLenear): Boolean;
var
 index: integer;
begin
 result := false;
 index := ColorSheme.Colorshemas.Add(ci);
 if index < ColorSheme.Colorshemas.Count then
 begin
  ColorSheme.Interpolation := interpolation;
  ColorSheme.Compile(index);
  ColorSheme.SelectedIndex := index;
  result := true;
 end;
end;

function TFractal.SetColorSheme(const index: Integer; const interpolation: TInterpolation = ipLenear): Boolean;
begin
 result := false;
 if (index >= 0) and (index < ColorSheme.Colorshemas.Count) then
 begin
   ColorSheme.Interpolation := interpolation;
   ColorSheme.Compile(index);
   ColorSheme.SelectedIndex := index;
   result := true;
 end;
end;

{ TRasterizer }

constructor TRasterizer.Create(bmp:TBitmap; map:PTraceMap; cl_gradiento_float: PGradientoFloat; const width,height, zskip:Longint);
begin
 fbmp := bmp;
 fmap := map;
 fcl_gradiento_float := cl_gradiento_float;
 fwidth := width;
 fheight := height;
 fzskip := zskip;
 FreeOnTerminate := True;
 inherited Create(True);
end;

procedure TRasterizer.fractal_map_rasterize(b: TBitmap; map: PTraceMap; cl_gradiento_float: PGradientoFloat; w, h,
  zskip: Integer);
var i, j: Longint;
line:Pointer;
pixel:PRGBA;
apfrac:Single;
aplwr:Longint;
wy:Longint;
si:Single;

const1:Single;
const256:Single;
begin

  const1 := 1.0;

  //для цвета
  const256:= 255.0;

  //размеры карты для правильной работы опять же должны быть кратны четырем
  //похоже что у строк битмапа адреса всегда выровнены по 16
  //в таком случае, нам даже не нужно думать
  b.PixelFormat:=pf32bit;

  b.Width:=w;
  b.Height:=h;

  for j := 0 to h - 1 do begin
    line := b.ScanLine[j];

    wy := w * j;

    //дальше делаем цикл
    asm
      {$I inc\renderer_fast.asm}
    end;

  end;
end;

procedure TRasterizer.Execute;
begin
 try
  fractal_map_rasterize(fbmp, fmap, fcl_gradiento_float, fWidth, fHeight,  fzskip);
 finally
  setEvent(fFinishedEvent);
 end;
end;

{ TInterpolate }

constructor TInterpolate.Create(tmp_map, map: PTraceMap; const width, height,
  RoundWidth, farX, pixelUnit: Integer);
begin
   ftmp_map := tmp_map;
   fmap := map;
   fwidth := width;
   fheight := height;
   fRoundWidth := RoundWidth;
   ffarX := farX;
   fpixelUnit := pixelUnit;
   FreeOnTerminate := True;
   inherited Create(True);
end;

procedure TInterpolate.Execute;
var
  darx:Longint;
  i, j, li, lj, jss, jsm: Longint;
  acc: Single;
begin
 try
  //èíòåðïîëèðóåì
  for j:=0 to fheight - 1 do begin

    jsm := j * fwidth;

    for i:=0 to fwidth - 1 do begin

      acc:=0;

      //èùåì ñðåäíèå çíà÷åíèÿ êâàäðàòà
      for lj := j * ffarX to j * ffarX + ffarX - 1 do begin

        jss := lj * fRoundWidth;

        for li := i * ffarX to i * ffarX + ffarX - 1 do begin
          acc := acc + ftmp_map[jss + li];
        end;
      end;
       darx := ffarx * ffarx;
      fmap[jsm + i] := acc / darx;
    end;
  end;
 finally
  setEvent(fFinishedEvent);
 end;
end;


{ TColorSItem }

destructor TColorSItem.Destroy;
begin
  if assigned(fColors) then
    FreeAndNil(fColors);
  inherited;
end;

{ TColorSheme }

constructor TColorSheme.Create(const SetDefaultColors: Boolean = true);
begin
 fColorshemas := TList<TColorSItem>.Create;
 fInterpolation := ipLenear;
 flerp_factor0 := nil;
 flerp_factor := nil;
 fGradientoFloat0 := nil;
 fGradientoFloat := nil;
 if SetDefaultColors then
  SetDefaultColorSheme;

end;

destructor TColorSheme.Destroy;
begin
  if assigned(flerp_factor0) then
    FreeMem(flerp_factor0);

  if assigned(fGradientoFloat0) then
    FreeMem(fGradientoFloat0);

  if assigned(fColorshemas) then
   FreeAndNil(fColorshemas);
  inherited;
end;

procedure TColorSheme.reinit_color_factor(const index, lerp_len: Integer);
var
 i,j,ssl:Longint;
 pipf:TIntFunction;
 lerpFactor: TLerpTag;
 lerpList: Tlist<TLerpTag>;
begin
  ssl:=0;

  if assigned(fGradientoFloat0) then
  begin
   FreeMem(fGradientoFloat0);
   fGradientoFloat0 := nil;
   fGradientoFloat := nil;
  end;

  aligned_get_mem(pointer(fGradientoFloat0), pointer(fGradientoFloat), fcl_gradiento_maxi * sizeof(TRGBAF), 16);


  pipf := @int_linear;

  case fInterpolation of
    ipLenear: begin
      pipf := @int_linear;
    end;
    ipCosine: begin
      pipf := @int_cosine;
    end;
  end;

  for i := 0 to fcl_gradiento_maxi - 1 do
  begin
    fGradientoFloat[i].r:=0;
    fGradientoFloat[i].g:=0;
    fGradientoFloat[i].b:=0;
    fGradientoFloat[i].a:=0;
  end;

  for i:=0 to lerp_len - 2 do
  begin
    for j:=0 to flerp_factor[i].llength-1 do
    begin
      fGradientoFloat[ssl + j].r := pipf(flerp_factor[i].r, flerp_factor[i + 1].r, (j / flerp_factor[i].llength));
      fGradientoFloat[ssl + j].g := pipf(flerp_factor[i].g, flerp_factor[i + 1].g, (j / flerp_factor[i].llength));
      fGradientoFloat[ssl + j].b := pipf(flerp_factor[i].b, flerp_factor[i + 1].b, (j / flerp_factor[i].llength));
      fGradientoFloat[ssl + j].a := pipf(flerp_factor[i].a, flerp_factor[i + 1].a, (j / flerp_factor[i].llength));
    end;
    inc(ssl, flerp_factor[i].llength);
  end;
  fMandelbrotDepth := ssl;
end;

procedure TColorSheme.SetDefaultColorSheme;
var
 ci: TColorSItem;
begin
 ci := TColorSItem.Create;
 ci.Name := 'Default';
 ci.Colors.Add(TLerpTag.Create(0,0,0,0,64));
 ci.Colors.Add(TLerpTag.Create(1,0,0,0,64));
 ci.Colors.Add(TLerpTag.Create(1,1,0,0,64));
 ci.Colors.Add(TLerpTag.Create(0,1,0,0,64));
 ci.Colors.Add(TLerpTag.Create(0,1,1,0,64));
 ci.Colors.Add(TLerpTag.Create(0,0,1,0,64));
 ci.Colors.Add(TLerpTag.Create(1,0,1,0,64));
 ci.Colors.Add(TLerpTag.Create(1,1,1,0,64));
 ci.Colors.Add(TLerpTag.Create(0,0,0,0,64));
 ci.Colors.Add(TLerpTag.Create(0,0,0,0,64));
 fColorshemas.Insert(0, ci);
 Compile(0);
end;

function TColorSheme.Compile(const index: Integer): PGradientoFloat;
var i:longint;
 fico:Longint;
begin
 result := nil;
 try
  if assigned(flerp_factor0)then
  begin
    FreeMem(flerp_factor0);
    flerp_factor0 := nil;
    flerp_factor := nil;
  end;

   with fColorshemas.Items[index] do
   begin
    if(fCycle)then
    begin
      fico := fCycleCount * fColors.Count;
    end else begin
      fico := fColors.Count;
    end;

    aligned_get_mem(pointer(flerp_factor0), pointer(flerp_factor), fico * sizeof(TRGBAF), 16);


  for i := 0 to fColors.Count - 1 do
  begin
      flerp_factor[i].r := fColors.Items[i].r / 255;
      flerp_factor[i].g := fColors.Items[i].g / 255;
      flerp_factor[i].b := fColors.Items[i].b / 255;
      flerp_factor[i].a := fColors.Items[i].a / 255;
      flerp_factor[i].llength := fColors.Items[i].llength;
  end;
 end;

   try
    reinit_color_factor(index, fico);
    result := fGradientoFloat;
   except
   end;

   SelectedIndex := index;
 except
   SelectedIndex := 0;
 end;
end;

constructor TColorSItem.Create;
begin
   fColors := TList<TLerpTag>.Create;
   fCycle := false;
   fCycleCount := 0;
end;

{ TLerpTag }

constructor TLerpTag.Create(_r, _g, _b, _a: Single; _llength: LongInt);
begin
 a:=_a;
 r :=_r;
 g :=_g;
 b := _b;
 llength := _llength;
end;

end.
