object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 550
  Width = 343
  object conn: TFDConnection
    Params.Strings = (
      'Database=E:\aizapNow\Web\DB\banco.db'
      'OpenMode=ReadWrite'
      'LockingMode=Normal'
      'DriverID=SQLite')
    Left = 56
    Top = 24
  end
  object qry_geral: TFDQuery
    Connection = conn
    Left = 136
    Top = 24
  end
  object qry_msg: TFDQuery
    Connection = conn
    Left = 216
    Top = 24
  end
  object qry_chat: TFDQuery
    Connection = conn
    Left = 56
    Top = 88
  end
end
