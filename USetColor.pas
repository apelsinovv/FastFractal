unit USetColor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvFullColorSpaces, JvFullColorCtrls,
  JvExControls, JvColorTrackbar, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  GR32_Image, ufractal, main, GR32;

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
  private
      fx,fy: integer;

    procedure repaintColors(gradient: PGradientoFloat);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ColorForm: TColorForm;
implementation

{$R *.dfm}

procedure TColorForm.ColorLChange(Sender: TObject);
begin
 ScrollBarLL.OnChange := nil;
 ScrollBarLL.Position := StrToInt(ColorL.Text);
 ScrollBarLL.OnChange := ScrollBarLLChange;
 ListView1.ItemFocused.SubItems.Strings[3] := ColorL.Text;

end;

procedure TColorForm.ColorRChange(Sender: TObject);
var
 ci: TColorSItem;
begin
 ci := TColorSItem(ListBox1.Items.Objects[ListBox1.ItemIndex]);
 if assigned(ci) then
 begin
   if TEdit(Sender).Name = 'ColorR' then
   begin
    ColorTrR.OnPosChange := nil;
    ColorTrR.Position := StrToInt(TEdit(sender).Text);
    ColorTrR.OnPosChange := ColorTrRPosChange;
    ListView1.ItemFocused.Caption := TEdit(sender).Text;

   end else
   if TEdit(Sender).Name = 'ColorG' then
   begin
    ColorTrG.OnPosChange := nil;
    ColorTrG.Position := StrToInt(TEdit(sender).Text);
    ColorTrG.OnPosChange := ColorTrRPosChange;
    ListView1.ItemFocused.SubItems.Strings[0] := TEdit(sender).Text;

   end else
   if TEdit(Sender).Name = 'ColorB' then
   begin
    ColorTrB.OnPosChange := nil;
    ColorTrB.Position := StrToInt(TEdit(sender).Text);
    ColorTrB.OnPosChange := ColorTrRPosChange;
    ListView1.ItemFocused.SubItems.Strings[1] := TEdit(sender).Text;

   end else
   if TEdit(Sender).Name = 'ColorA' then
   begin
    ColorTrA.OnPosChange := nil;
    ColorTrA.Position := StrToInt(TEdit(sender).Text);
    ColorTrA.OnPosChange := ColorTrRPosChange;
    ListView1.ItemFocused.SubItems.Strings[2] := TEdit(sender).Text;
   end;
    img2.Bitmap.SetSize(80, 80);
    img2.Bitmap.FillRect(0, 0, 80, 80, Color32(ColorTrR.Position, ColorTrG.Position, ColorTrB.Position, ColorTrA.Position));

//    repaintColors(fractal.ColorSheme.Compile(ListBox1.ItemIndex));
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

procedure TColorForm.FormCreate(Sender: TObject);
var
 i: integer;
begin
 ListBox1.Clear;
 for I := 0 to fractal.ColorSheme.Colorshemas.Count - 1 do
  ListBox1.Items.AddObject(fractal.ColorSheme.Colorshemas.Items[i].Name, fractal.ColorSheme.Colorshemas.Items[i]);
 ListBox1.ItemIndex := fractal.ColorSheme.SelectedIndex;
 chbCycle.Checked := fractal.ColorSheme.Colorshemas.Items[fractal.ColorSheme.SelectedIndex].Cycle;
 edCycleCount.Text := IntToStr(fractal.ColorSheme.Colorshemas.Items[fractal.ColorSheme.SelectedIndex].CycleCount);
 ListBox1Click(self);
end;

procedure TColorForm.ListBox1Click(Sender: TObject);
var
 ci: TColorSItem;
 cl: TLerpTag;
 li: TListItem;
 i: Integer;
begin
 ListView1.Items.Clear;
 ci :=TColorSItem(ListBox1.Items.Objects[ListBox1.ItemIndex]);
 if assigned(ci) then
 begin
  for cl in ci.Colors do
  begin
   li := ListView1.Items.Add;
   li.Caption := IntToStr(Round(cl.r));
   li.SubItems.Add(IntToStr(Round(cl.g)));
   li.SubItems.Add(IntToStr(Round(cl.b)));
   li.SubItems.Add(IntToStr(Round(cl.a)));
   li.SubItems.Add(IntToStr(Round(cl.llength)));
  end;
  repaintColors(fractal.ColorSheme.GradientFloat);
 end;
end;

procedure TColorForm.repaintColors(gradient: PGradientoFloat);
var
 ci: TColorSItem;
 colorsCnt: Integer;
 width, i: Integer;
begin
 if ListBox1.ItemIndex <0 then exit;

  ci := TColorSItem(ListBox1.Items.Objects[ListBox1.ItemIndex]);
  if assigned(ci) then
  begin
     width := 0;
     for I := 0 to ci.Colors.Count - 1 do
      width := width + ci.Colors.Items[i].llength;

    img1.Bitmap.SetSize(width, 90);
    for I := 0 to img1.Bitmap.Width - 1 do
     img1.Bitmap.Line(i,0,i,90, rgbaf(gradient[i].r, gradient[i].g, gradient[i].b, gradient[i].a));

  end;
end;

procedure TColorForm.ListView1Click(Sender: TObject);
var
 li: TListitem;
begin
 li := ListView1.Selected;
 if assigned(li) then
 begin
  ColorR.Text := li.Caption;
  ColorG.Text := li.SubItems.Strings[0];
  ColorB.Text :=li.SubItems.Strings[1];
  ColorA.Text := li.SubItems.Strings[2];
  ColorL.Text := li.SubItems.Strings[3];

 end;
end;

procedure TColorForm.ListView1CustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
 pbRect: TRect;
 cw, i: Integer;
begin
 SetBkMode(Listview1.Canvas.Handle, TRANSPARENT);
 if SubItem = 5 then
 begin
  DefaultDraw := false;
  pbRect :=  Item.DisplayRect(drBounds);
  cw := pbRect.Left;
  for I := 0 to 4  do
   cw := cw + ListView1.Columns[i].Width;
  pbRect.Left := cw;
  pbRect.Right := cw + ListView1.Columns[5].Width;
  pbRect.Top := pbRect.Top + 1;
  pbRect.Bottom := pbRect.Bottom - 1;

  Sender.Canvas.Brush.Color := RGB(StrToInt(Item.Caption),StrToInt(Item.SubItems.Strings[0]), StrToInt(Item.SubItems.Strings[1]));
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

procedure TColorForm.ScrollBarLLChange(Sender: TObject);
begin
 ColorL.Text := IntToStr(ScrollBarLL.Position)
end;

end.
