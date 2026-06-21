unit FrmAp2Image;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.ExtCtrls;

type
  TFrmImage = class(TFrame)
    ImageViewer1: TImageViewer;
    procedure ImageViewer1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation





{$R *.fmx}

procedure TFrmImage.ImageViewer1Click(Sender: TObject);
begin
 //
end;

end.
