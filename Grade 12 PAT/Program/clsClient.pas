unit clsClient;

interface

uses
  DateUtils, SysUtils, dmData;

type
TClient = class(TObject)

private
  fName,fSurname,fID,fHotel,fArriving,fDeparting,fRefCode:string;
  fDays,fPeople:Integer;
public
  constructor Create(sName,sSurname,sID,sHotel,sArriving,sDeparting:string;iPeople:Integer);
  function getRefCode:string;
  function getDays:Integer;
  function getPrice:Real;
  function getTotal:Real;
  function Output:string;
  procedure Insert;
end;

implementation


{ TClient }

constructor TClient.Create(sName, sSurname, sID, sHotel, sArriving,
  sDeparting: string; iPeople: Integer);
begin
  fName:=sName;
  fSurname:=sSurname;
  fID:=sID;
  fHotel:=sHotel;
  fArriving:=sArriving;
  fDeparting:=sDeparting;
  fPeople:=iPeople;
end;

function TClient.getPrice: Real;
begin
  with dmHotelData do
  begin
    qryHotels.SQL.Text:='SELECT PricePerNight FROM tblHotels WHERE HotelName='+QuotedStr(fHotel);
    qryHotels.Open;
    Result:=StrToFloat(qryHotels.Fields.Fields[0].AsString);
  end;
end;



function TClient.getDays: Integer;
var
  Arrival,Departure:TDateTime;
begin
  Arrival:=StrToDate(fArriving);
  Departure:=StrToDate(fDeparting);
  Result:=DaysBetween(Departure,Arrival);
end;

function TClient.getRefCode: string;
begin
  Result:=uppercase(fName[1])+uppercase(fSurname[1])+COPY(fID,Length(fID)-3,4);
end;

function TClient.getTotal: Real;
begin
  Result:=getPrice*getDays;
end;

procedure TClient.Insert;
begin
  with dmHotelData do
   begin
      adoClients.Open;
      adoClients.Insert;
      adoClients['RefCode']:=getRefCode;
      adoClients['Name']:=fName;
      adoClients['Surname']:=fSurname;
      adoClients['IDNumber']:=fID;
      adoClients['HotelName']:=fHotel;
      adoClients['ArrivalDate']:=fArriving;
      adoClients['DepartureDate']:=fDeparting;
      adoClients['DaysStaying']:=getDays;
      adoClients['NumberOfPeople']:=fPeople;
      adoClients.Post;
   end;
end;

function TClient.Output: string;
VAR
  sOut:String;
begin
  sout:='Cost details for client RefCode: '+#9+getRefCode+#13;
  sOut:=sOut+'Price per night: '+#9+FloatToStrf(getPrice,ffCurrency,8,2)+#13;
  if (fDays=1) And (fPeople=1) then
  Result:=sOut+'Total cost for '+IntToStr(fPeople)+' person for '+IntToStr(fDays)+' day:'+#9+FloatToStrf(getTotal,ffCurrency,8,2)
  else if (fDays=1) AND not(fPeople=1) then
  Result:=sOut+'Total cost for '+IntToStr(fPeople)+' people for '+IntToStr(getDays)+' day:'+#9+FloatToStrf(getTotal,ffCurrency,8,2)
  else Result:=sOut+'Total cost for '+IntToStr(fPeople)+' people for '+IntToStr(getDays)+' days:'+#9+FloatToStrf(getTotal,ffCurrency,8,2);
end;

end.

