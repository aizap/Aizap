program Whats;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form_Principal in 'Form_Principal.pas' {Frm_Principal},
  Data_Module in 'Data_Module.pas' {dm: TDataModule},
  UAudioControl in 'classes\UAudioControl.pas',
  uAudioVisualControl in 'classes\uAudioVisualControl.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.CreateForm(TFrm_Principal, Frm_Principal);
  Application.CreateForm(Tdm, dm);
  Application.Run;
end.
