unit dmData;

interface

uses
  SysUtils, Classes, DB, ADODB;

type
  TdmHotelData = class(TDataModule)
    conHotelData: TADOConnection;
    dsClients: TDataSource;
    dsHotels: TDataSource;
    qryClients: TADOQuery;
    qryHotels: TADOQuery;
    adoClients: TADOTable;
    adoHotels: TADOTable;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmHotelData: TdmHotelData;

implementation

{$R *.dfm}

end.
