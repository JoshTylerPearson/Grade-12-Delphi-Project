unit clsHotel;

interface

Uses
  SysUtils, dmData;

type
THotel = class(TObject)

private
  fName,fProvince,fEditSearch:string;
  fRating,fDistance,fPrice:Real;
  f1,f2,f3,f4:Boolean;

public
  constructor Create(sName,sProvince,sSearch:String;rRating,rDistance,rPrice:Real;b1,b2,b3,b4:Boolean);
  Procedure Insert;
  procedure Edit;
end;

implementation

{ THotel }

constructor THotel.Create(sName, sProvince, sSearch: String; rRating, rDistance,
  rPrice: Real; b1, b2, b3, b4: Boolean);
begin
  fName:=sName;
  fProvince:=sProvince;
  fRating:=rRating;
  fDistance:=rDistance;
  fPrice:=rPrice;
  f1:=b1;
  f2:=b2;
  f3:=b3;
  f4:=b4;
  fEditSearch:=sSearch;
end;

procedure THotel.Edit;
begin
  with dmHotelData do
  begin
    adoHotels.Open;
    adoHotels.Locate('HotelName',fEditSearch,[]);
    adoHotels.Edit;
    adoHotels['HotelName']:=fName;
    adoHotels['Province']:=fProvince;
    adoHotels['Rating']:=fRating;
    adoHotels['DistanceFromCenter']:=fDistance;
    adoHotels['1 Sleeper']:=f1;
    adoHotels['2 Sleeper']:=f2;
    adoHotels['3 Sleeper']:=f3;
    adoHotels['4 Sleeper']:=f4;
    adoHotels['PricePerNight']:=fPrice;
    adoHotels.Post;
    adoHotels.Close;
  end;
end;

procedure THotel.Insert;
begin
  with dmHotelData do
  begin
    adoHotels.Close;
    adoHotels.Open;
    adoHotels.Insert;
    adoHotels['HotelName']:=fName;
    adoHotels['Province']:=fProvince;
    adoHotels['Rating']:=fRating;
    adoHotels['DistanceFromCenter']:=fDistance;
    adoHotels['1 Sleeper']:=f1;
    adoHotels['2 Sleeper']:=f2;
    adoHotels['3 Sleeper']:=f3;
    adoHotels['4 Sleeper']:=f4;
    adoHotels['PricePerNight']:=fPrice;
    adoHotels.Post;
  end;
end;

end.
