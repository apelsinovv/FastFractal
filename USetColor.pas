unit USetColor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvFullColorSpaces, JvFullColorCtrls,
  JvExControls, JvColorTrackbar, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  GR32_Image, ufractal, main, GR32, Vcl.Mask, JvExMask, JvSpin;

type
  TColorForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBarLL: TScrollBar;
    ColorTrB: TJvColorTrackBar;
    ColorTrG: TJvColorTrackBar;
    ColorTrR: TJvColorTrackBar;
    ColorTrA: TJvColorTrackBar;
    Label1: TLabel;
    ColorR: TEdit;
    Label2: TLabel;
    ColorG: TEdit;
    ColorB: TEdit;
    Label4: TLabel;
    ColorA: TEdit;
    Label5: TLabel;
    ColorL: TEdit;
    Label6: TLabel;
    chbCycle: TCheckBox;
    edCycleCount: TEdit;
    ListView1: TListView;
    ListBox1: TListBox;
    Img2: TImage32;
    Img1: TImage32;
    Panel3: TPanel;
    Label3: TLabel;
    rbInterpolation: TRadioButton;
    rbCosine: TRadioButton;
    btnAdd: TButton;
    btnDelete: TButton;
    Label7: TLabel;
    edFullColor: TEdit;
    btnRepaint: TButton;
    chbAutoR: TCheckBox;
    btnInsert: TButton;
    btnUp: TButton;
    btnDown: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListView1CustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure ListView1Click(Sender: TObject);
    procedure ColorTrRPosChange(Sender: TObject);
    procedure ColorRChange(Sender: TObject);
    procedure ScrollBarLLChange(Sender: TObject);
    procedure ColorLChange(Sender: TObject);
    procedure edFullColorClick(Sender: TObject);
    procedure btnRepaintClick(Sender: TObject);
    procedure ListView1Deletion(Sender: TObject; Item: TListItem);
    procedure chbCycleClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure edFullColorChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
      fx,fy: integer;
       ci: TColorSItem;
    procedure repaintColors(const ci: TColorSItem);
    procedure BtnEnableRefresh;
    procedure RefreshColorSheme(const index: Integer);
    procedure RepaintColorsheme(const index: integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ColorForm: TColorForm;
implementation

{$R *.dfm}

procedure TColorForm.btnInsertClick(Sender: TObject);
begin
 ci.Colors.Insert(ListView1.ItemIndex, TLerpTag.Create(0,0,0,255,64));
 ListBox1Click(self);
end;


procedure TColorForm.btnRepaintClick(Sender: TObject);
begin
 repaintColors(ci);
end;

procedure TColorForm.RefreshColorSheme(const index: Integer);
begin
 ListBox1Click(self);
 ListView1.ItemIndex := index;
 ListView1Click(self);
 BtnEnableRefresh;
end;

procedure TColorForm.btnUpClick(Sender: TObject);
var
 index: integer;
begin
 index := ListView1.ItemIndex;
 ci.Colors.Exchange(index, index - 1);
 RefreshColorSheme(index);
end;

procedure TColorForm.Button1Click(Sender: TObject);
var
 localCi: TColorSItem;
 idx: integer;
begin
  localCi := fractal.ColorSheme.add;
  localCi.Name := InputBox('Add new color sheme', 'Set the name of color sheme', 'Colors');
  idx := localCi.index;
  RepaintColorsheme(idx);
end;

procedure TColorForm.Button3Click(Sender: TObject);
begin
 Fractal.ColorSheme.Write('c:\colorsheme.fch');
end;

procedure TColorForm.Button4Click(Sender: TObject);
begin
 Fractal.ColorSheme.Read('c:\colorsheme.fch');
 RepaintColorsheme(1);
end;

procedure TColorForm.btnAddClick(Sender: TObject);
var
 lt: TLerpTag;
 index: integer;
begin
 lt.Create(0,0,0,255,64);
 index := ci.Colors.Add(lt);
 RefreshColorSheme(index);
end;

procedure TColorForm.chbCycleClick(Sender: TObject);
begin
 if chbAutoR.Checked then
   btnRepaintClick(self);
end;

procedure TColorForm.btnDeleteClick(Sender: TObject);
var
 index: integer;
begin
 index := ListView1.ItemIndex;
 ListView1.Items.Delete(index);
 dec(index);
 if index < 0 then index := 0;
 RefreshColorSheme(index);
end;

procedure TColorForm.btnDownClick(Sender: TObject);
var
 index: integer;
begin
 index := ListView1.ItemIndex;
 ci.Colors.Exchange(index, index + 1);
 RefreshColorSheme(index);
end;

procedure TColorForm.BtnEnableRefresh;
begin
 if assigned(ListView1.ItemFocused) then
 begin
   btnInsert.Enabled := true;
   btnDelete.Enabled := true;
   if ListView1.ItemFocused.Index > 0 then
    btnUp.Enabled := True
   else
    btnUp.Enabled := False;
   if ListView1.ItemFocused.Index <  (ListView1.Items.Count - 1) then
    btnDown.Enabled := True
   else
    btnUp.Enabled := False;
 end else
 begin
   btnInsert.Enabled := False;
   btnDelete.Enabled := False;
   btnUp.Enabled := False;
   btnUp.Enabled := False;
 end;
end;

procedure TColorForm.ColorLChange(Sender: TObject);
var
 cl: PLerpTag;
begin
 cl := ListView1.ItemFocused.Data;
 ScrollBarLL.OnChange := nil;
 ScrollBarLL.Position := StrToInt(ColorL.Text);
 cl.llength := ScrollBarLL.Position;
 ListView1.ItemFocused.SubItems.Strings[4] := ColorL.Text;
 ScrollBarLL.OnChange := ScrollBarLLChange;
 if chbAutoR.Checked then
   btnRepaintClick(self);

end;

procedure TColorForm.ColorRChange(Sender: TObject);
var
 cl: PLerpTag;
 Color: TColor32;
begin
 cl := ListView1.ItemFocused.Data;
 begin
   if TEdit(Sender).Name = 'ColorR' then
   begin
    ColorTrR.OnPosChange := nil;
    ColorTrR.Position := StrToInt(TEdit(sender).Text);
    cl.r := ColorTrR.Position;
    ListView1.ItemFocused.SubItems.Strings[0] := TEdit(sender).Text;
    ColorTrR.OnPosChange := ColorTrRPosChange;

   end else
   if TEdit(Sender).Name = 'ColorG' then
   begin
    ColorTrG.OnPosChange := nil;
    ColorTrG.Position := StrToInt(TEdit(sender).Text);
    cl.g := ColorTrG.Position;
    ListView1.ItemFocused.SubItems.Strings[1] := TEdit(sender).Text;
    ColorTrG.OnPosChange := ColorTrRPosChange;
   end else
   if TEdit(Sender).Name = 'ColorB' then
   begin
    ColorTrB.OnPosChange := nil;
    ColorTrB.Position := StrToInt(TEdit(sender).Text);
    cl.b := ColorTrB.Position;
    ListView1.ItemFocused.SubItems.Strings[2] := TEdit(sender).Text;
    ColorTrB.OnPosChange := ColorTrRPosChange;
   end else
   if TEdit(Sender).Name = 'ColorA' then
   begin
    ColorTrA.OnPosChange := nil;
    ColorTrA.Position := StrToInt(TEdit(sender).Text);
    cl.a := ColorTrA.Position;
    ListView1.ItemFocused.SubItems.Strings[3] := TEdit(sender).Text;
    ColorTrA.OnPosChange := ColorTrRPosChange;
   end;
    Color := Color32(ColorTrR.Position, ColorTrG.Position, ColorTrB.Position, ColorTrA.Position);
    img2.Bitmap.SetSize(80, 80);
    img2.Bitmap.FillRect(0, 0, 80, 80, Color);
    edFullColor.OnChange := nil;
    edFullColor.Text := Format('#%8.8x', [Color]);
    edFullColor.OnChange := edFullColorChange;

    if chbAutoR.Checked then
       btnRepaintClick(self);
 end;
end;

procedure TColorForm.ColorTrRPosChange(Sender: TObject);
begin
 if TJvColorTrackBar(sender).Name = 'ColorTrR' then
  ColorR.Text := IntToStr(TJvColorTrackBar(sender).Position)
 else
 if TJvColorTrackBar(sender).Name = 'ColorTrG' then
  ColorG.Text := IntToStr(TJvColorTrackBar(sender).Position)
 else
 if TJvColorTrackBar(sender).Name = 'ColorTrB' then
  ColorB.Text := IntToStr(TJvColorTrackBar(sender).Position)
 else
 if TJvColorTrackBar(sender).Name = 'ColorTrA' then
  ColorA.Text := IntToStr(TJvColorTrackBar(sender).Position);
end;

procedure TColorForm.edFullColorChange(Sender: TObject);
var
 r,g,b,a: Byte;
 str: string;
begin
 str := copy(edFullColor.Text, 2, Length(edFullColor.Text) );
 Color32ToRGBA(HexToInt(str),r,g,b,a);
 ColorR.Text := IntToStr(r);
 ColorG.Text := IntToStr(g);
 ColorB.Text := IntToStr(b);
 ColorA.Text := IntToStr(a);

end;

procedure TColorForm.edFullColorClick(Sender: TObject);
begin
 edFullColor.SelStart := 1;
 edFullColor.SelLength := Length(edFullColor.Text) - 1;
end;

procedure TColorForm.RepaintColorsheme(const index: integer);
var
 i, idx: integer;
begin
 if (index >=0) and (index < fractal.ColorSheme.Colorshemas.Count) then
  idx := index
 else
  idx := 0;

 ListBox1.Clear;
 ci := nil;
 for I := 0 to fractal.ColorSheme.Colorshemas.Count - 1 do
  ListBox1.Items.AddObject(fractal.ColorSheme.Colorshemas.Items[i].Name, fractal.ColorSheme.Colorshemas.Items[i]);
 ListBox1.ItemIndex := idx;
 ci := fractal.ColorSheme.Colorshemas.Items[idx];
 chbCycle.Checked := ci.Cycle;
 edCycleCount.Text := IntToStr(ci.CycleCount);
 ListBox1Click(self);
end;

procedure TColorForm.FormCreate(Sender: TObject);
begin
 RepaintColorsheme(fractal.ColorSheme.SelectedIndex);
end;

procedure TColorForm.ListBox1Click(Sender: TObject);
var
 cl: TLerpTag;
 clocal: PLerpTag;
 li: TListItem;
 i: Integer;
begin
 ListView1.Items.Clear;
 ci :=TColorSItem(ListBox1.Items.Objects[ListBox1.ItemIndex]);
 if assigned(ci) then
 begin
  i := 1;
  for cl in ci.Colors do
  begin
   new(clocal);
   clocal.r := cl.r;
   clocal.g := cl.g;
   clocal.b := cl.b;
   clocal.a := cl.a;
   clocal.llength := cl.llength;

   li := ListView1.Items.Add;
   li.Data := clocal;
   li.Caption := IntToStr(i);
   li.SubItems.Add(IntToStr(Round(clocal.r)));
   li.SubItems.Add(IntToStr(Round(clocal.g)));
   li.SubItems.Add(IntToStr(Round(clocal.b)));
   li.SubItems.Add(IntToStr(Round(clocal.a)));
   li.SubItems.Add(IntToStr(Round(clocal.llength)));
   inc(i);
  end;
  case ci.Interpolation of
   ipLenear: rbInterpolation.Checked := True;
   ipCosine: rbCosine.Checked := true;
  end;
  chbCycle.Checked := ci.Cycle;
  edCycleCount.Text := IntToStr(ci.CycleCount);
  repaintColors(ci);
 end;
end;

procedure TColorForm.repaintColors(const ci: TColorSItem);
var
   fGradientoFloat0: PGradientoFloat;
   fGradientoFloat: PGradientoFloat;

 colorsCnt: Integer;
 width, i, index: Integer;
begin

  fGradientoFloat0 := nil;
  fGradientoFloat := nil;

  if assigned(ci) then
  begin
     width := 0;
     ci.Colors.Clear;
     for I := 0 to ListView1.Items.Count - 1 do
     begin
      index := ci.Colors.Add(TLerpTag(ListView1.Items.Item[i].Data^));
      width := width + ci.Colors.Items[index].llength;
     end;
    ci.Cycle := chbCycle.Checked;
    ci.CycleCount := StrToInt(edCycleCount.Text);
     if rbInterpolation.Checked then
      ci.Interpolation := ipLenear
     else
      ci.Interpolation := ipCosine;

    try
      ci.Compile(fGradientoFloat0, fGradientoFloat);
      if ci.Cycle then
       width := width * ci.CycleCount;
      img1.Bitmap.SetSize(width, 90);
      for I := 0 to img1.Bitmap.Width - 1 do
       img1.Bitmap.Line(i,0,i,90, rgbaf(fGradientoFloat[i].r, fGradientoFloat[i].g, fGradientoFloat[i].b, fGradientoFloat[i].a));
    finally
     if assigned(fGradientoFloat0) then
      FreeMem(fGradientoFloat0);
    end;

  end;
end;

procedure TColorForm.ListView1Click(Sender: TObject);
var
 li: TListitem;
begin
 li := ListView1.Selected;
 if assigned(li) then
 begin
  ColorR.Text := li.SubItems.Strings[0];
  ColorG.Text := li.SubItems.Strings[1];
  ColorB.Text :=li.SubItems.Strings[2];
  ColorA.Text := li.SubItems.Strings[3];
  ColorL.Text := li.SubItems.Strings[4];
 end;
 BtnEnableRefresh;
end;

procedure TColorForm.ListView1CustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
 pbRect: TRect;
 cw, i: Integer;
begin
 SetBkMode(Listview1.Canvas.Handle, TRANSPARENT);
 if SubItem = 6 then
 begin
  DefaultDraw := false;
  pbRect :=  Item.DisplayRect(drBounds);
  cw := pbRect.Left;
  for I := 0 to 5  do
   cw := cw + ListView1.Columns[i].Width;
  pbRect.Left := cw;
  pbRect.Right := cw + ListView1.Columns[5].Width;
  pbRect.Top := pbRect.Top + 1;
  pbRect.Bottom := pbRect.Bottom - 1;

  Sender.Canvas.Brush.Color := RGB(StrToInt(Item.SubItems.Strings[0]),StrToInt(Item.SubItems.Strings[1]), StrToInt(Item.SubItems.Strings[2]));
  Sender.Canvas.FillRect(pbRect);
  Sender.Canvas.Brush.Color := clWhite;
  Sender.Canvas.Font.Color := clBlack;

 end else
 begin
  DefaultDraw := true;
  Sender.Canvas.Brush.Color := clWhite;
  Sender.Canvas.Font.Color := clBlack;

 end;
end;

procedure TColorForm.ListView1Deletion(Sender: TObject; Item: TListItem);
var
 clocal: PLerpTag;
begin
 clocal := Item.Data;
 Dispose(clocal);
end;

procedure TColorForm.ScrollBarLLChange(Sender: TObject);
begin
 ColorL.Text := IntToStr(ScrollBarLL.Position)
end;

end.
