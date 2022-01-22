unit Login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GIFImg, ExtCtrls, StdCtrls, Input, Admin;

type
  TfrmLogin = class(TForm)
    btnEmployee: TButton;
    btnAdmin: TButton;
    imgPlane: TImage;
    edtEmployeePass: TEdit;
    edtAdminPass: TEdit;
    edtEmployeeUser: TEdit;
    edtAdminUser: TEdit;
    lblEmployeeUser: TLabel;
    lblEmployeePass: TLabel;
    lblAdminUser: TLabel;
    lblAdminPass: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure btnEmployeeClick(Sender: TObject);
    procedure btnAdminClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    var
    sEmployee,sAdmin:String;
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

procedure TfrmLogin.btnAdminClick(Sender: TObject);
var
  sUserIn,sPassIn,sLogin,sUser,sPass:string;
begin
  sUserIn:=edtAdminUser.Text;
  sPassIn:=edtAdminPass.Text;
  sLogin:=sAdmin;
  Delete(sLogin,1,POS(':',sLogin));
  sUser:=Copy(sLogin,1,Pos('#',sLogin)-1);
  Delete(sLogin,1,POS('#',sLogin));
  spass:=sLogin;
  if (sUserIn='') or (sPassIn='') then
  begin
    ShowMessage('Check that you have entered your username and password.');
  end
  else begin
   if (sUserIn=sUser) and(sPassIn=sPass) then
    begin
     frmAdmin.Show;
     frmLogin.Hide;
     edtAdminUser.Clear;
     edtAdminPass.Clear;
    end
    else begin
     Showmessage('Incorrect username or password');
     edtAdminUser.Clear;
     edtAdminPass.Clear;
     edtAdminUser.SetFocus;
    end;
  end;
end;

procedure TfrmLogin.btnEmployeeClick(Sender: TObject);
var
  sUserIn,sPassIn,sLogin,sUser,sPass:string;
begin
  sUserIn:=edtEmployeeUser.Text;
  sPassIn:=edtEmployeePass.Text;
  sLogin:=sEmployee;
  Delete(sLogin,1,POS(':',sLogin));
  sUser:=Copy(sLogin,1,Pos('#',sLogin)-1);
  Delete(sLogin,1,Pos('#',sLogin));
  sPass:=sLogin;
  if (sUserIn='') or (sPassIn='') then
  begin
    ShowMessage('Check that you have entered your username and password.');
  end
  else begin
    if (sUserIn=sUser) and(sPassIn=sPass) then
     begin
      frmInput.Show;
      frmLogin.Hide;
      edtEmployeeUser.Clear;
      edtEmployeePass.Clear;
     end
    else begin
      Showmessage('Incorrect username or password');
      edtEmployeeUser.Clear;
      edtEmployeePass.Clear;
      edtEmployeeUser.SetFocus;
     end;
  end;

end;

procedure TfrmLogin.FormActivate(Sender: TObject);
VAR
  tFile:Textfile;
  sLine:String;
begin
  (imgPlane.Picture.Graphic as TGIFImage).Animate:=True;
  AssignFile(tFile,'Passwords.txt');
  Reset(tFile);
  while not Eof(tFile) do
   begin
    Readln(tFile,sLine);
    if Copy(sLine,1,5)='ADMIN' then
     begin
      sAdmin:=sLine;
     end
     else sEmployee:=sLine;
     End;
end;

end.
