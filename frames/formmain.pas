unit formmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynEdit, Forms, Controls, Graphics, Dialogs,
  Menus, ExtCtrls, StdCtrls, ActnList, ComCtrls, RadioSystem, RadioModule;

type

  { TMainForm }

  TMainForm = class(TForm)
    ActionList1: TActionList;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    Panel1: TPanel;
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    SynEdit1: TSynEdit;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    FSystem: TRadioSystem;
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses
  Genfft, UComplex, SignalBasic, rm_spectrum, rm_oscillator, logger,
  formfilter, rm_dump;

{$R *.lfm}

{ TMainForm }

procedure TMainForm.Button1Click(Sender: TObject);
begin
  TTextLogger.Level := llWarn;
  TTextLogger.Start;
  //FilterForm.Show;
  //exit;
  if not Assigned(FSystem) then
  begin
    FSystem := TRadioSystem.Create;
    FSystem.AddModule('s', 'Spectrum');
    FSystem.AddModule('s2', 'Spectrum');
    FSystem.AddModule('a', 'AudioIn');
    FSystem.AddModule('u', 'AudioOut');
    FSystem.AddModule('o', 'Oscillator');
    FSystem.AddModule('f', 'Filter');
    FSystem.AddModule('f2', 'Filter');
    FSystem.AddModule('r', 'Rtl');
    FSystem.AddModule('dump', 'DumpPlayer');
    FSystem.AddModule('fm', 'FMDemod');
  end;
  FSystem.ConnectBoth('dump', 's');
  FSystem.ConnectBoth('dump', 'f');
  FSystem.ConnectFeature('s', 'f');
  FSystem.ConnectBoth('f', 'fm');
  FSystem.ConnectFeature('s', 'fm');
  FSystem.ConnectBoth('fm', 's2');
  FSystem.ConnectBoth('fm', 'f2');
  FSystem.ConnectFeature('s2', 'f2');
  FSystem.ConnectBoth('f2', 'u');

  //FSystem.ConnectBoth('r', 'dump');

 // FSystem.ConnectBoth('f', 's2');
  //FSystem.ConnectBoth('f', 'u');
 // FSystem.ConnectBoth('dump', 'u');

 // RadioPostMessage(RM_SPECTRUM_CFG, SET_FFT_SIZE, 44100 div 4, 's');
//  RadioPostMessage(RM_SPECTRUM_CFG, SET_Y_RANGE, 10, 's');
 // RadioPostMessage(RM_SPECTRUM_CFG, SET_SPAN, -1, 's');
 // RadioPostMessage(RM_SPECTRUM_CFG, SET_CENTER_FREQ, 3000, 's');
  //RadioPostMessage(RM_SPECTRUM_CFG, SET_SPAN, 0, 's');

 // FSystem.ConfigModule('a');
 // FSystem.ConfigModule('r');
  FSystem.ConfigModule('dump');
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  Button1Click(Sender);
end;

procedure TMainForm.Button3Click(Sender: TObject);
var
  X: array [0..3] of Complex;
  P: PFFTPlan;
begin
 { FillChar(X[0], (High(X) + 1) * SizeOf(X[0]), 0);
  X[1].re := 100;
  P := BuildFFTPlan(High(X) + 1, False);
  FFT(P, @X[0], @X[0]);
  FinalizePlan(P);
  exit;
  }
  RadioPostMessage(RM_DUMP_STOP, 0, 0, 'dump');
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  FSystem.Free;
end;

end.

