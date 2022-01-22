object dmHotelData: TdmHotelData
  OldCreateOrder = False
  Height = 330
  Width = 608
  object conHotelData: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=HotelDatabase.mdb;M' +
      'ode=ReadWrite;Persist Security Info=False;Jet OLEDB:System datab' +
      'ase="";Jet OLEDB:Registry Path="";Jet OLEDB:Database Password=""' +
      ';Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode=1;Jet O' +
      'LEDB:Global Partial Bulk Ops=2;Jet OLEDB:Global Bulk Transaction' +
      's=1;Jet OLEDB:New Database Password="";Jet OLEDB:Create System D' +
      'atabase=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Don'#39't C' +
      'opy Locale on Compact=False;Jet OLEDB:Compact Without Replica Re' +
      'pair=False;Jet OLEDB:SFP=False'
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 56
    Top = 120
  end
  object dsClients: TDataSource
    DataSet = qryClients
    Left = 248
    Top = 72
  end
  object dsHotels: TDataSource
    DataSet = qryHotels
    Left = 248
    Top = 168
  end
  object qryClients: TADOQuery
    Connection = conHotelData
    Parameters = <>
    Left = 160
    Top = 72
  end
  object qryHotels: TADOQuery
    Connection = conHotelData
    Parameters = <>
    Left = 160
    Top = 168
  end
  object adoClients: TADOTable
    Connection = conHotelData
    TableName = 'tblClients'
    Left = 160
    Top = 32
  end
  object adoHotels: TADOTable
    Connection = conHotelData
    TableName = 'tblHotels'
    Left = 160
    Top = 224
  end
end
