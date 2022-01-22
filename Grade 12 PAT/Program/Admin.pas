unit Admin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, dmData, StdCtrls, Spin, ExtCtrls, clsHotel;

type
  TfrmAdmin = class(TForm)
    dbgHotels: TDBGrid;
    edtHotelName: TEdit;
    edtRating: TEdit;
    edtDistance: TEdit;
    chk1Sleeper: TCheckBox;
    chk2Sleeper: TCheckBox;
    chk3Sleeper: TCheckBox;
    chk4Sleeper: TCheckBox;
    lblHotel: TLabel;
    lblProvince: TLabel;
    lblRating: TLabel;
    lblDistance: TLabel;
    lblRooms: TLabel;
    lblPrice: TLabel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnRemove: TButton;
    btnLogout: TButton;
    cbxProvinces: TComboBox;
    edtPrice: TEdit;
    cbxHotels: TComboBox;
    procedure btnLogoutClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure ClearObjects;
    procedure btnRemoveClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
  private
    { Private declarations }
    objHotel : THotel;
    procedure qryRefresh;
  public
    { Public declarations }
  end;

var
  frmAdmin: TfrmAdmin;

implementation

uses Login;

{$R *.dfm}

procedure TfrmAdmin.btnAddClick(Sender: TObject);
VAR
  sName,sProvince:string;
  rRating,rDist,rPrice:Real;
  b1,b2,b3,b4:Boolean;
begin
  objHotel.Free;
  sName:=edtHotelName.Text;
  sProvince:=cbxProvinces.Text;
  rRating:=StrToFloat(edtRating.Text);
  rDist:=StrToFloat(edtDistance.Text);
  rPrice:=StrToFloat(edtPrice.Text);
  b1:=chk1Sleeper.Checked;
  b2:=chk2Sleeper.Checked;
  b3:=chk3Sleeper.Checked;
  b4:=chk4Sleeper.Checked;
  if (edtHotelName.Text='') or (cbxProvinces.Text='Choose a province') or (edtRating.Text='') or (edtDistance.Text='') or (edtPrice.Text='') then
   ShowMessage('Ensure all fields are filled in')
  else begin
  if MessageDlg('Are you sure you want to add this record?'+#13+'(Data can always be changed)',mtConfirmation,[mbYes,mbNo],0)=mrYes then
  begin
    objHotel:=THotel.Create(sName,sProvince,'',rRating,rDist,rPrice,b1,b2,b3,b4);
    objHotel.Insert;
    cbxHotels.Clear;
    with dmHotelData do
    begin
    qryHotels.Close;
    qryHotels.SQL.Text:='Select HotelName FROM tblHotels ORDER BY Province';
    qryHotels.Open;
    qryHotels.First;
    while not(qryHotels.Eof) do
     begin
       cbxHotels.Items.Add(qryHotels.Fields.Fields[0].AsString);
       qryHotels.Next;
     end;
     qryHotels.Close;
    end;
    ClearObjects;
    qryRefresh;
  end
  else Showmessage('Record not added');
  end;
end;

procedure TfrmAdmin.btnEditClick(Sender: TObject);
VAR
  sName,sProvince,sSearch:string;
  rRating,rDist,rPrice:Real;
  b1,b2,b3,b4:Boolean;
begin
  objHotel.Free;
  sName:=edtHotelName.Text;
  sProvince:=cbxProvinces.Text;
  rRating:=StrToFloat(edtRating.Text);
  rDist:=StrToFloat(edtDistance.Text);
  rPrice:=StrToFloat(edtPrice.Text);
  b1:=chk1Sleeper.Checked;
  b2:=chk2Sleeper.Checked;
  b3:=chk3Sleeper.Checked;
  b4:=chk4Sleeper.Checked;
   with dmHotelData do
   begin
     sSearch:=qryHotels.Fields.Fields[0].AsString;
   end;
  if (sName='') or (sProvince='Choose a province') or (edtRating.Text='') or (edtDistance.Text='') or (edtPrice.Text='') then
    ShowMessage('Ensure all fields are filled in')
  else begin
     with dmHotelData do
     objHotel:=THotel.Create(sName,sProvince,sSearch,rRating,rDist,rPrice,b1,b2,b3,b4);
    objHotel.Edit;
    ShowMessage('Record edited');
    cbxHotels.Clear;
    with dmHotelData do
    begin
    qryHotels.Close;
    qryHotels.SQL.Text:='Select HotelName FROM tblHotels ORDER BY Province';
    qryHotels.Open;
    qryHotels.First;
    while not(qryHotels.Eof) do
     begin
       cbxHotels.Items.Add(qryHotels.Fields.Fields[0].AsString);
       qryHotels.Next;
     end;
     qryHotels.Close
    end;
    qryRefresh;
    ClearObjects;
  end;
end;

procedure TfrmAdmin.btnLogoutClick(Sender: TObject);
begin
  frmAdmin.Hide;
  frmLogin.Show;
  cbxProvinces.Clear;
  cbxHotels.Clear;
  ClearObjects;
end;

procedure TfrmAdmin.btnRemoveClick(Sender: TObject);
VAR
  sHotel:string;
begin
  sHotel:=cbxHotels.Text;
  if sHotel='Choose a hotel to delete' then
  ShowMessage('Choose a hotel from the list')
  else begin
  if MessageDlg('Are you sure you want to delete this record?',mtConfirmation,[mbYes,mbNo],0)=mrYes then
   begin
    with dmHotelData do
    begin
      qryHotels.SQL.Text:='DELETE FROM tblHotels WHERE HotelName='+QuotedStr(sHotel);
      qryHotels.ExecSQL;
      qryHotels.Close;
      cbxHotels.Clear;
      qryHotels.SQL.Text:='SELECT HotelName FROM tblHotels ORDER BY Province';
      qryHotels.Open;
      qryHotels.First;
      while not(qryHotels.Eof) do
       begin
         cbxHotels.Items.Add(qryHotels.Fields.Fields[0].AsString);
         qryHotels.Next;
       end;
      ClearObjects;
      qryRefresh;
    end;
   end
   else ShowMessage('Record not deleted');
  end;
end;

procedure TfrmAdmin.Clearobjects;
begin
  edtHotelName.Clear;
  edtRating.Clear;
  edtDistance.Clear;
  chk1Sleeper.Checked:=False;
  chk2Sleeper.Checked:=False;
  chk3Sleeper.Checked:=False;
  chk4Sleeper.Checked:=False;
  edtPrice.Clear;
  cbxProvinces.ItemIndex:=-1;
  cbxProvinces.Text:='Choose a province';
  cbxHotels.ItemIndex:=-1;
  cbxHotels.Text:='Choose a hotel to delete';
end;

procedure TfrmAdmin.FormShow(Sender: TObject);
begin
  with dmHotelData do
   begin
     qryHotels.Close;
     qryHotels.SQL.Text:='Select HotelName FROM tblHotels ORDER BY Province';
     qryHotels.Open;
     qryHotels.First;
     while not(qryHotels.Eof) do
      begin
        cbxHotels.Items.Add(qryHotels.Fields.Fields[0].AsString);
        qryHotels.Next;
      end;
     qryHotels.Close;
     qryHotels.SQL.Text:='SELECT Province FROM tblHotels GROUP BY Province';
     qryHotels.Open;
     qryHotels.First;
     while not(qryHotels.Eof) do
      begin
        cbxProvinces.Items.Add(qryHotels.Fields.Fields[0].AsString);
        qryHotels.Next;
      end;
     qryRefresh;
   end;
end;

procedure TfrmAdmin.qryRefresh;
begin
   with dmHotelData do
    begin
     qryHotels.Close;
     qryHotels.SQL.Text:='SELECT * FROM tblHotels ORDER BY Province';
     qryHotels.Open;
     qryHotels.First;
    end;
end;

end.
