unit Input;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmData, Grids, DBGrids, Spin, ComCtrls, StdCtrls, DateUtils, ExtCtrls, clsClient;

type
  TfrmInput = class(TForm)
    edtName: TEdit;
    edtSurname: TEdit;
    edtID: TEdit;
    lblName: TLabel;
    lblSurname: TLabel;
    lblID: TLabel;
    cbxHotel: TComboBox;
    lblHotel: TLabel;
    dtpArriving: TDateTimePicker;
    lblArrival: TLabel;
    dtpDeparting: TDateTimePicker;
    lblDeparture: TLabel;
    dbgClients: TDBGrid;
    btnInsert: TButton;
    btnChange: TButton;
    btnOutput: TButton;
    redOut: TRichEdit;
    btnAttractionsRestaurants: TButton;
    cbxProvinces: TComboBox;
    rgpPeople: TRadioGroup;
    procedure btnInsertClick(Sender: TObject);
    procedure btnChangeClick(Sender: TObject);
    procedure btnOutputClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAttractionsRestaurantsClick(Sender: TObject);
    procedure cbxHotelChange(Sender: TObject);
  private
    { Private declarations }
    arrAttractions: array[1..10,1..6] of string;
    arrRestaurants: array[1..10,1..6] of string;
    iRowCount:Integer;
    objClient:TClient;
    procedure ClearObjects;
    procedure FillProvinces;
  public
    { Public declarations }
  end;

var
  frmInput: TfrmInput;

implementation

uses Change, Output;

{$R *.dfm}

procedure TfrmInput.btnAttractionsRestaurantsClick(Sender: TObject);
VAR
sProvince:String;
iRow,iCol:Integer;
begin
  if cbxProvinces.Text='Choose a province' then
  ShowMessage('Choose a province')
  else begin
  redOut.Clear;
  sProvince:=cbxProvinces.Text;
  redOut.Lines.Add('Attractions for '+sProvince+':');
  for iRow := 1 to iRowCount do
   begin
     if arrAttractions[iRow,1]=UpperCase(sProvince) then
      begin
        for iCol := 2 to 6 do
        redOut.Lines.Add('    • '+arrAttractions[iRow,iCol]);
      end;
   end;
  redOut.Lines.Add(#13+'Restaurants for '+sProvince+':');
  for iRow := 1 to iRowCount do
   begin
     if arrRestaurants[iRow,1]=UpperCase(sProvince) then
      begin
        for iCol := 2 to 6 do
        redOut.Lines.Add('    • '+arrRestaurants[iRow,iCol]);
      end;
   end;
  end;
end;

procedure TfrmInput.btnChangeClick(Sender: TObject);
begin
  frmChange.Show;
  frmInput.Hide;
  ClearObjects;
end;

procedure TfrmInput.btnInsertClick(Sender: TObject);
VAR
  sName,sSurname,sID,sHotel,sArriving,sDeparting:string;
  iPeople:Integer;
begin
  sName:=edtName.Text;
  sSurname:=edtSurname.Text;
  sID:=edtID.Text;
  sHotel:=cbxHotel.Items[cbxHotel.ItemIndex];
  sArriving:=DateToStr(dtpArriving.Date);
  sDeparting:=DateToStr(dtpDeparting.Date);
  iPeople:=StrToInt(rgpPeople.Items[rgpPeople.ItemIndex]);
  if (sName='') or (sSurname='') or (sID='') or (sHotel='Choose a hotel') or (iPeople=0) then
   ShowMessage('Ensure every field is filled in.');
  if NOT Length(sID)=13 then
   begin
     ShowMessage('Ensure ID number is correct');
     edtID.SetFocus;
   end;
  ClearObjects;
  FillProvinces;
  if MessageDlg('Are you sure you want to add this record?'+#13+'(records can be changed if needed)',mtConfirmation,[mbYes,mbNo],0)=mrYes then
    begin
      objClient:=TClient.Create(sName,sSurname,sID,sHotel,sArriving,sDeparting,iPeople);
      objClient.Insert;
      redOut.Lines.Add(objClient.Output);
    end
  else begin
    ShowMessage('Record not added.');
  end;

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
     qryHotels.SQL.Text:='SELECT * FROM tblHotels ORDER BY Province';
     qryHotels.Open;
   end;
end;

procedure TfrmInput.btnOutputClick(Sender: TObject);
begin
  frmOutput.Show;
  frmInput.Hide;
  ClearObjects;
end;



procedure TfrmInput.cbxHotelChange(Sender: TObject);
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
     qryHotels.SQL.Text:='SELECT * FROM tblHotels ORDER BY Province';
     qryHotels.Open;
   end;
end;

procedure TfrmInput.ClearObjects;
begin
  edtName.Clear;
  edtSurname.Clear;
  edtID.Clear;
  dtpArriving.Date:=Date();
  dtpDeparting.Date:=Date();
  rgpPeople.Items.Clear;
  cbxHotel.Clear;
  cbxHotel.Text:='Choose a hotel';
  cbxProvinces.Clear;
  cbxProvinces.Text:='Choose a province';
  redOut.Clear;
  objClient.Free;
end;

procedure TfrmInput.FillProvinces;
begin
  with dmHotelData do
  begin
    qryHotels.SQL.Text:='SELECT Province FROM tblHotels GROUP BY Province';
    qryHotels.Open;
    qryHotels.First;
    while not qryHotels.Eof do
     begin
       cbxProvinces.Items.Add(qryHotels.Fields.Fields[0].AsString);
       qryHotels.Next;
     end;
     qryHotels.Close;
  end;
end;

procedure TfrmInput.FormShow(Sender: TObject);
VAR
  sLine:String;
  tAttractions,tRestaurants:TextFile;
  iRow,iCol:Integer;
begin
  redOut.Paragraph.TabCount:=1;
  redOut.Paragraph.Tab[0]:=150;
  FillProvinces;
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
     qryHotels.SQL.Text:='SELECT * FROM tblHotels ORDER BY Province';
     qryHotels.Open;
   end;
  dtpArriving.Date:=Date();
  dtpDeparting.Date:=Date();

  AssignFile(tAttractions,'FiveAttractions.txt');
  if FileExists('FiveAttractions.txt')=False then
   begin
     ShowMessage('FiveAttractions.txt not found');
     Exit;
   end;
  Reset(tAttractions);
  AssignFile(tRestaurants,'FiveRestaurants.txt');
  if FileExists('FiveRestaurants.txt')=False then
   begin
     ShowMessage('FiveRestaurants.txt not found');
     Exit;
   end;
  Reset(tRestaurants);
  iRowCount:=0;
  while (NOT Eof(tAttractions)) AND (NOT Eof(tRestaurants))do
   begin
    inc(iRowCount);
    Readln(tAttractions,sLine);
    arrAttractions[iRowCount,1]:=COPY(sLine,1,Pos(':',sLine)-1);
    Delete(sLine,1,Pos(':',sLine));
    for iCol := 2 to 6 do
      begin
        arrAttractions[iRowCount,iCol]:=Copy(sLine,1,POS('#',sLine)-1);
        Delete(sLine,1,POS('#',sLine));
      end;
    ReadLn(tRestaurants,sLine);
    arrRestaurants[iRowCount,1]:=Copy(sLine,1,POS(':',sLine)-1);
    Delete(sLine,1,POS(':',sLine));
    for iCol := 2 to 6 do
      begin
        arrRestaurants[iRowCount,iCol]:=COPY(sLine,1,POS('#',sLine)-1);
        Delete(sLine,1,POS('#',sLine));
      end;
   end;
end;

end.
