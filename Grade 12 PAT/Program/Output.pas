unit Output;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, Math;

type
  TfrmOutput = class(TForm)
    dbgOutput: TDBGrid;
    btnAvgStay: TButton;
    btnTotalPeople: TButton;
    btnSumMoney: TButton;
    btnChange: TButton;
    btnAdmin: TButton;
    edtUser: TEdit;
    edtPass: TEdit;
    lblUser: TLabel;
    lblPass: TLabel;
    btnLogin: TButton;
    btnInput: TButton;
    btnLogout: TButton;
    btnCommision: TButton;
    procedure btnAdminClick(Sender: TObject);
    procedure btnChangeClick(Sender: TObject);
    procedure btnInputClick(Sender: TObject);
    procedure btnLogoutClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure btnCommisionClick(Sender: TObject);
    procedure btnAvgStayClick(Sender: TObject);
    procedure btnTotalPeopleClick(Sender: TObject);
    procedure btnSumMoneyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure ClearObjects;
  public
    { Public declarations }
    VAR
      sAdmin :string;
  end;

var
  frmOutput: TfrmOutput;

implementation

uses Change, Input, Login, dmData, Admin;

{$R *.dfm}

procedure TfrmOutput.btnAdminClick(Sender: TObject);
begin
  edtUser.Visible:=True;
  edtPass.Visible:=True;
  lblUser.Visible:=True;
  lblPass.Visible:=True;
  btnLogin.Visible:=True;
end;

procedure TfrmOutput.btnAvgStayClick(Sender: TObject);
begin
  with dmHotelData do
  begin
     qryClients.Close;
     qryClients.SQL.Text:='SELECT HotelName,AVG(DaysStaying) AS [Average Stay] FROM tblClients GROUP BY HotelName';
     qryClients.Open;
  end;
  dbgOutput.Columns[0].Width:=250;
  dbgOutput.Columns[1].Width:=70;
end;

procedure TfrmOutput.btnChangeClick(Sender: TObject);
begin
  frmOutput.Hide;
  frmChange.Show;
  ClearObjects;
end;

procedure TfrmOutput.btnCommisionClick(Sender: TObject);
begin
  with dmHotelData do
  begin
    qryClients.Close;
    qryClients.SQL.Text:='SELECT tblHotels.HotelName,FORMAT(SUM((PricePerNight*DaysStaying)*0.1),"Currency") AS Commission FROM tblHotels,tblClients WHERE tblHotels.HotelName=tblClients.HotelName GROUP BY tblHotels.HotelName';
    qryClients.Open;
  end;
  dbgOutput.Columns[0].Width:=250;
  dbgOutput.Columns[1].Width:=70;
end;

procedure TfrmOutput.btnInputClick(Sender: TObject);
begin
  frmOutput.Hide;
  frmInput.Show;
  ClearObjects;
end;

procedure TfrmOutput.btnLoginClick(Sender: TObject);
VAR
  sUserIn,sPassIn,sLogin,sUser,sPass:string;
begin
  sUserIn:=edtUser.Text;
  sPassIn:=edtPass.Text;
  sLogin:=sAdmin;
  Delete(sLogin,1,POS(':',sLogin));
  sUser:=Copy(sLogin,1,Pos('#',sLogin)-1);
  Delete(sLogin,1,POS('#',sLogin));
  spass:=sLogin;
  if (sUserIn=sUser) AND (sPassIn=sPass) then
   begin
     frmOutput.Hide;
     frmAdmin.Show;
     edtUser.Visible:=False;
     edtPass.Visible:=False;
     lblUser.Visible:=False;
     lblPass.Visible:=False;
     btnLogin.Visible:=False;
   end
   else begin
     Showmessage('Incorrect username or password.');
     edtUser.Clear;
     edtPass.Clear;
   end;
end;

procedure TfrmOutput.btnLogoutClick(Sender: TObject);
begin
  frmOutput.Hide;
  frmLogin.Show;
  ClearObjects;
end;

procedure TfrmOutput.btnSumMoneyClick(Sender: TObject);
begin
  With dmHotelData do
  begin
    qryClients.Close;
    qryClients.SQL.Text:='SELECT tblHotels.HotelName,FORMAT(SUM(PricePerNight*DaysStaying),"Currency") AS Total FROM tblClients,tblHotels WHERE tblHotels.HotelName=tblClients.HotelName GROUP BY tblHotels.HotelName';
    qryClients.Open;
  end;
  dbgOutput.Columns[0].Width:=250;
  dbgOutput.Columns[1].Width:=70;
end;

procedure TfrmOutput.btnTotalPeopleClick(Sender: TObject);
begin
  with dmHotelData do
  begin
    qryClients.Close;
    qryClients.SQL.Text:='SELECT HotelName,Count(NumberOfPeople) AS Total FROM tblClients GROUP BY HotelName';
    qryClients.Open;
  end;
  dbgOutput.Columns[0].Width:=250;
  dbgOutput.Columns[1].Width:=70;
end;


procedure TfrmOutput.ClearObjects;
begin
  edtUser.Visible:=False;
  edtPass.Visible:=False;
  lblUser.Visible:=False;
  lblPass.Visible:=False;
  btnLogin.Visible:=False;
  edtUser.Clear;
  edtPass.Clear;
  with dmHotelData do
  begin
    qryClients.Close;
    qryHotels.Close;
  end;
end;



procedure TfrmOutput.FormShow(Sender: TObject);
VAR
  tFile:TextFile;
  sLine:String;
begin
  ClearObjects;
  AssignFile(tFile,'Passwords.txt');
  Reset(tFile);
  while not Eof(tFile) do
   begin
    Readln(tFile,sLine);
    if Copy(sLine,1,5)='ADMIN' then
     begin
      sAdmin:=sLine;
     end;
     End;
end;

end.
