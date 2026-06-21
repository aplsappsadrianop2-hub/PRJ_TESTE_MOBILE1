program Ap2App;

uses
  System.StartUpCopy,
  FMX.Forms,
  FrmAp2AppMain in 'FrmAp2AppMain.pas' {FrmAppMain},
  FrmAp2Image in 'FrmAp2Image.pas' {FrmImage: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmAppMain, FrmAppMain);
  Application.Run;
end.
