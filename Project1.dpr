program Project1;

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainForm},
  UFractal in 'UFractal.pas',
  USetColor in 'USetColor.pas' {ColorForm},
  UNavPage in 'UNavPage.pas' {NavPage};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TNavPage, NavPage);
  Application.Run;
end.
