program Project1;

uses
  Forms,
  Login in 'Login.pas' {frmLogin},
  Input in 'Input.pas' {frmInput},
  Admin in 'Admin.pas' {frmAdmin},
  Change in 'Change.pas' {frmChange},
  Output in 'Output.pas' {frmOutput},
  dmData in 'dmData.pas' {dmHotelData: TDataModule},
  clsClient in 'clsClient.pas',
  clsHotel in 'clsHotel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmInput, frmInput);
  Application.CreateForm(TfrmAdmin, frmAdmin);
  Application.CreateForm(TfrmChange, frmChange);
  Application.CreateForm(TfrmOutput, frmOutput);
  Application.CreateForm(TdmHotelData, dmHotelData);
  Application.Run;
end.
