unit Change;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, DB,
  Dialogs, Grids, DBGrids, dmData, StdCtrls, ComCtrls, Spin, Output, Input, DateUtils,
  ExtCtrls;

type
  TfrmChange = class(TForm)
    dbgClients: TDBGrid;
    lblEditName: TLabel;
    lblEditSurname: TLabel;
    lblID: TLabel;
    lblHotel: TLabel;
    lblArrival: TLabel;
    lblDeparture: TLabel;
    edtEditName: TEdit;
    edtEditSurname: TEdit;
    edtID: TEdit;
    cbxHotel: TComboBox;
    dtpArriving: TDateTimePicker;
    dtpDeparting: TDateTimePicker;
    btnConfirmEdit: TButton;
    btnSearch: TButton;
    cbxSearch: TComboBox;
    btnDelete: TButton;
    btnOutput: TButton;
    btnInput: TButton;
    btnArrivalOnly: TButton;
    btnDepartureOnly: TButton;
    cbxClients: TComboBox;
    rgpPeople: TRadioGroup;
    procedure btnSearchClick(Sender: TObject);
    procedure btnOutputClick(Sender: TObject);
    procedure btnInputClick(Sender: TObject);
    procedure btnArrivalOnlyClick(Sender: TObject);
    procedure btnDepartureOnlyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure cbxClientsChange(Sender: TObject);
    procedure btnConfirmEditClick(Sender: TObject);
    procedure cbxHotelChange(Sender: TObject);
  private
    { Private declarations }
    procedure ClearObjects;
  public
    { Public declarations }
  end;

var
  frmChange: TfrmChange;

implementation

{$R *.dfm}

procedure TfrmChange.btnArrivalOnlyClick(Sender: TObject);
VAR
  sArrival,sDeparture,sActive:String;
  iDays:Integer;
  dArrival,dDeparture:TDateTime;
begin
  sArrival:=DateToStr(dtpArriving.Date);
  sDeparture:=DateToStr(dtpDeparting.Date);
  dArrival:=StrToDate(sArrival);
  dDeparture:=StrToDate(sDeparture);
  iDays:=DaysBetween(dDeparture,dArrival);
  with dmHotelData do
  begin
    adoClients.Open;
    sActive:=adoClients['RefCode'];
    adoClients.Edit;
    adoClients['ArrivalDate']:=sArrival;
    adoClients['DaysStaying']:=iDays;
    adoClients.Post;
    adoClients.Close;
    qryClients.SQL.Text:='SELECT * FROM tblClients WHERE REfCode='+QuotedStr(sActive);
    qryClients.Open;
  end;
end;

procedure TfrmChange.btnConfirmEditClick(Sender: TObject);
VAR
  sName,sSurname,sID,sRefCode,sHotel,sArrival,sDeparture:string;
  iDays,iPeople:Integer;
  Arrival,Departure:TDateTime;  
begin
  sName:=edtEditName.Text;
  sSurname:=edtEditSurname.Text;
  sID:=edtID.Text;
  sRefCode:=UpperCase(sName[1])+UpperCase(sSurname[1])+Copy(sID,Length(sID)-3,4);
  sHotel:=cbxHotel.Text;
  sArrival:=DateToStr(dtpArriving.Date);
  sDeparture:=DateToStr(dtpDeparting.Date);
  iPeople:=StrToInt(rgpPeople.Items[rgpPeople.ItemIndex]);
  Arrival:=StrToDate(sArrival);
  Departure:=StrToDate(sDeparture);
  iDays:=DaysBetween(Departure,Arrival);
  With dmHotelData do
  begin
    if (edtEditName.Text='') or (edtEditSurname.Text='') or (edtID.Text='') or (cbxHotel.Text='Choose a hotel') or not(iPeople in [1..4]) then
    ShowMessage('Ensure all fields are filled in')
    else begin
    adoClients.Open;
    adoClients.Edit;
    adoClients['RefCode']:=sRefCode;
    adoClients['Name']:=sName;
    adoClients['Surname']:=sSurname;
    adoClients['IDNumber']:=sID;
    adoClients['HotelName']:=sHotel;
    adoClients['ArrivalDate']:=sArrival;
    adoClients['DepartureDate']:=sDeparture;
    adoClients['DaysStaying']:=iDays;
    adoClients['NumberOfPeople']:=iPeople;
    adoCLients.Post;
    adoClients.Close;
    qryClients.SQL.Text:='SELECT * FROM tblCLients';
    qryClients.Open;
    ShowMessage('Record successfully edited');
    cbxClients.Clear;
    qryHotels.Close;
    qryClients.SQL.Text:='SELECT Name,Surname FROM tblClients';
    qryClients.Open;
    while not(qryClients.Eof) do
    begin
       cbxClients.Items.Add(qryClients.Fields[0].AsString+' '+qryClients.Fields[1].AsString);
       qryClients.Next;
    end;
    qryClients.Close;
  end;
  end;

end;

procedure TfrmChange.btnDeleteClick(Sender: TObject);
begin
  if cbxClients.Text='Choose a client to delete' then
   ShowMessage('Choose a client to remove from the database')
  else begin
  if messagedlg('Are you sure you want to delete the record of '+cbxClients.Text+'?',mtConfirmation,[mbYes,mbNo],0)=mrYes then
  begin
  With dmHotelData do
  begin
    adoClients.Open;
    adoClients.delete;
    qryClients.Close;
    cbxClients.Clear;
    cbxClients.Text:='Choose a client to delete';
    qryClients.SQL.Text:='SELECT Name,Surname FROM tblClients';
    qryClients.Open;
    qryClients.First;
    while not(qryClients.Eof) do
    begin
       cbxClients.Items.Add(qryClients.Fields[0].AsString+' '+qryClients.Fields[1].AsString);
       qryClients.Next
    end;
    qryClients.SQL.Text:='SELECT * FROM tblClients';
    qryClients.Open;
  end;
  end
  else ShowMessage('Record not deleted');
  end;
end;

procedure TfrmChange.btnDepartureOnlyClick(Sender: TObject);
VAR
  sArrival,sDeparture,sActive:String;
  iDays:Integer;
  dArrival,dDeparture:TDateTime;
begin
  sArrival:=DateToStr(dtpArriving.Date);
  sDeparture:=DateToStr(dtpDeparting.Date);
  dArrival:=StrToDate(sArrival);
  dDeparture:=StrToDate(sDeparture);
  iDays:=DaysBetween(dDeparture,dArrival);
  with dmHotelData do
  begin
    adoClients.Open;
    sActive:=adoClients['RefCode'];
    adoClients.Edit;
    adoClients['DepartureDate']:=sDeparture;
    adoClients['DaysStaying']:=iDays;
    adoClients.Post;
    adoClients.Close;
    qryClients.SQL.Text:='SELECT * FROM tblClients WHERE REfCode='+QuotedStr(sActive);
    qryClients.Open;
  end;
end;

procedure TfrmChange.btnInputClick(Sender: TObject);
begin
  frmChange.Hide;
  frmInput.Show;
  ClearObjects;
end;

procedure TfrmChange.btnOutputClick(Sender: TObject);
begin
  frmChange.Hide;
  frmOutput.Show;
  ClearObjects;
end;

procedure TfrmChange.btnSearchClick(Sender: TObject);
VAR
  sSearch:string;
begin
  sSearch:=InputBox('Search for a client','Enter a the '+cbxSearch.Items[cbxSearch.ItemIndex]+' detail','');
  with dmHotelData do
  begin
    qryClients.SQL.Text:='SELECT * From tblClients WHERE '+cbxSearch.Text+'= '+QuotedStr(sSearch);
    qryClients.Open;
    dtpArriving.Date:=StrToDate(qryClients['ArrivalDate']);
    dtpDeparting.Date:=StrToDate(qryClients['DepartureDate']);
    if NOT(qryClients.RecordCount>0) then
     begin
       Showmessage('Record with '+sSearch+' not found in the '+cbxSearch.Text+' field');
       qryClients.SQL.Text:='SELECT * FROM tblClients';
       qryClients.Open;
     end;
  end;
end;



procedure TfrmChange.cbxClientsChange(Sender: TObject);
VAR
  sFull,sName,sSurname:string;
begin
  sFull:=cbxClients.Text;
  sName:=Copy(sFull,1,POS(' ',sFull)-1);
  Delete(sFull,1,POS(' ',sFull));
  sSurname:=sFull;
  with dmHotelData do
  begin
    qryClients.SQL.Text:='SELECT * FROM tblClients WHERE Name='+QuotedStr(sName)+' AND Surname='+QuotedStr(sSurname);
    qryClients.Open;
  end;
end;

procedure TfrmChange.cbxHotelChange(Sender: TObject);
VAR
  sHotel:string;
begin
  sHotel:=cbxHotel.Items[cbxHotel.ItemIndex];
  With dmHotelData do
  begin
    qryHotels.Close;
    qryHotels.SQL.Text:='SELECT HotelName,[1 sleeper],[2 sleeper],[3 sleeper],[4 sleeper] FROM tblHotels WHERE HotelName='+QuotedStr(sHotel);
    qryHotels.Open;
    rgpPeople.Items.Clear;
    if qryHotels['1 sleeper']='True' then
     rgpPeople.Items.Add('1');
    if qryHotels['2 sleeper']='True' then
     rgpPeople.Items.Add('2');
    if qryHotels['3 sleeper']='True' then
      rgpPeople.Items.Add('3');
    if qryHotels['4 sleeper']='True' then
      rgpPeople.Items.Add('4');
    qryHotels.Close;
  end;
end;

procedure TfrmChange.ClearObjects;
begin
  edtEditName.Clear;
  edtEditSurname.Clear;
  edtID.Clear;
  rgpPeople.Items.Clear;
  cbxHotel.Clear;
  cbxClients.Clear;
  cbxSearch.Text:='Where to search';
  cbxClients.Text:='Choose a client to delete';
  cbxHotel.Text:='Choose a hotel';
end;

procedure TfrmChange.FormShow(Sender: TObject);
begin
  with dmHotelData do
    begin
     qryHotels.SQL.Text:='SELECT HotelName FROM tblHotels ORDER BY HotelName';
     qryHotels.Open;
     qryHotels.First;
     while not qryHotels.Eof do
      begin
        cbxHotel.Items.Add(qryHotels.Fields.Fields[0].AsString);
        qryHotels.Next;
      end;
     qryHotels.Close;
     qryClients.SQL.Text:='SELECT Name,Surname FROM tblClients';
     qryClients.Open;
     while not(qryClients.Eof) do
     begin
       cbxClients.Items.Add(qryClients.Fields[0].AsString+' '+qryClients.Fields[1].AsString);
       qryClients.Next;
     end;
     qryClients.Close;
     qryClients.SQL.Text:='SELECT * FROM tblClients';
     qryClients.Open;
     dtpArriving.Date:=StrToDate(qryClients['ArrivalDate']);
     dtpDeparting.Date:=StrToDate(qryClients['DepartureDate']);
    end;
  rgpPeople.Items.Clear;
end;

end.
