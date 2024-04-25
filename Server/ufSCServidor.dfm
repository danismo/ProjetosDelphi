object SCServidor: TSCServidor
  OldCreateOrder = False
  Height = 271
  Width = 415
  object DSServer1: TDSServer
    Left = 96
    Top = 11
  end
  object DSTCPServerTransport1: TDSTCPServerTransport
    Server = DSServer1
    Filters = <>
    Left = 96
    Top = 73
  end
  object DSServerClass1: TDSServerClass
    OnGetClass = DSServerClass1GetClass
    Server = DSServer1
    Left = 216
    Top = 11
  end
  object DSHTTPService1: TDSHTTPService
    HttpPort = 8081
    Server = DSServer1
    Filters = <>
    Left = 216
    Top = 72
  end
end
