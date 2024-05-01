unit ufFormReportFiltros;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls,
  JSON, REST.JSON, uClassReport, uClassBase;

type
  TFormReportFiltros = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    EdtDataIni: TDateTimePicker;
    EdtDataFin: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    function GetJSON: TJSONObject;
  end;

var
  FormReportFiltros: TFormReportFiltros;

implementation

{$R *.dfm}

uses
  DateUtils;

procedure TFormReportFiltros.Button1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFormReportFiltros.FormCreate(Sender: TObject);
begin
  EdtDataIni.DateTime := now;
  EdtDataFin.DateTime := now;
end;

function TFormReportFiltros.GetJSON: TJSONObject;
var
  AReportFiltros: TReportFiltros;
  ADateEncoded: String;
begin
  AReportFiltros := TReportFiltros.Create;
  try
    ADateEncoded := FormatDateTime('dd/mm/yyyy 00:00:00', EdtDataIni.DateTime);
    AReportFiltros.DataInicial := StrToDateTime(ADateEncoded);
    ADateEncoded := FormatDateTime('dd/mm/yyyy 23:59:59', EdtDataFin.DateTime);
    AReportFiltros.DataFinal := StrToDateTime(ADateEncoded);
    Result := TJSON.ObjectToJSONObject(AReportFiltros);
  finally
    AReportFiltros.Free;
  end;
end;

end.
