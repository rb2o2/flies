unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

Const
MyCanvasMax = 1;
MaxWorm = 16;
MaxFly = 16;
MaxImageWorm = 4;
MaxImageFly = 2;
SinFlyMax = 50;
xmax = 860;
ymax = 520;
xmin = 0;
ymin = 0;

type

  TMyFly = class (TObject)
  public
  Name: string;
  MyCanvas: array[1..MyCanvasMax] of TImage;
  ImgMass: array[1..MaxImageFly] of TBitMap;
  owner:TWinControl;
  shagx1,shagx2,spr,shagy1:integer;
  Xfly,Yfly:word;
  grad:real;
  ThereMove: string;
  Timer: TTimer;
  procedure TimerFly1Timer(Sender: TObject);
  Constructor CreateFly(X,Y: word; Move: string; ownerForm: TWinControl);
  Destructor Destroy(); override;
  end;

  TMyWorm = class (TObject)
  public
  Name: string;
  MyCanvas: array[1..MyCanvasMax] of TImage;
  ImgMass: array[1..MaxImageWorm] of TBitMap;
  owner:TWinControl;
  shagx1,shagx2,shagy2:integer;
  Xworm,Yworm,spr1,spr2,sprmin,sprmax:word;
  ThereMove: string;
  Timer: TTimer;
  procedure TimerWorm1Timer(Sender: TObject);
  Constructor CreateWorm(X,Y: word; Move: string; ownerForm: TWinControl);
  Destructor Destroy(); override;
  end;

type
  TForm1 = class(TForm)
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    Worms: array[1..MaxWorm] of TMyWorm;
    Flyes: array[1..MaxFly] of TMyFly;

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TMyWorm }



constructor TMyWorm.CreateWorm(X, Y:word; Move:string; ownerForm: TWinControl);
var
i:integer;
begin
Randomize;
self.Timer:=TTimer.Create(nil);
self.Timer.OnTimer:=self.TimerWorm1Timer;
self.Timer.Interval:=round((Random*120)+(Random*60)+1);
//Максимальная координата по X для гусеницы, чтобы она развернулась
Xworm:=xmax;
Yworm:=round(Random*ymax);
self.owner:=ownerForm;
MyCanvas[1]:=TImage.Create(owner);
For i:=1 to MaxImageWorm Do
   begin
   ImgMass[i]:=TBitMap.Create;
   ImgMass[i].LoadFromFile('Worm'+IntToStr(i)+'.bmp');
   end;
sprmin:=2;
sprmax:=4;
spr1:=sprmin;
ThereMove:='left';
//Загружаем изображение Гусеницы в объект
MyCanvas[1].Left:=Xworm;
MyCanvas[1].Top:=Yworm;
MyCanvas[1].Picture.Assign(ImgMass[spr1]);
MyCanvas[1].Visible:=True;
MyCanvas[1].Parent:=owner;
self.Timer.Enabled:=true;
end;

procedure TMyWorm.TimerWorm1Timer(Sender: TObject);
begin
MyCanvas[1].Picture.Assign(ImgMass[spr1]);
MyCanvas[1].Visible:=True;
MyCanvas[1].AutoSize:=True;
MyCanvas[1].Parent:=Form1;
MyCanvas[1].Left:=MyCanvas[1].Left+shagx1;
//Делаем так чтобы Гусеница ползала от края до края и так далее
If MyCanvas[1].Left>=xmax then
   begin
   shagx1:=-4;
   ThereMove:='left';
   end;
If MyCanvas[1].Left<xmin then
   begin
   shagx1:=4;
   ThereMove:='right';
   end;
spr1:=spr1+1;
//Гусеница ползёт влево
If (ThereMove='left') and (spr1>2) then
   begin
   spr1:=1;
   spr2:=5;
   end;
//Гусеница ползёт вправо
If (ThereMove='right') and (spr1>4) then
   begin
   spr1:=3;
   spr2:=6;
   end;
end;

constructor TMyFly.CreateFly(X, Y:word; Move:string; ownerForm: TWinControl);
var
i:integer;
begin
Randomize;
self.Timer:=TTimer.Create(nil);
self.Timer.OnTimer:=self.TimerFly1Timer;
self.Timer.Interval:=round((Random*120)+(Random*60)+1);
//Максимальная координата по X для мухи, чтобы она развернулась
Xfly:=xmax;
Yfly:=round(Random*ymax)+SinFlyMax;
self.grad:=0;
self.owner:=ownerForm;
MyCanvas[1]:=TImage.Create(owner);
For i:=1 to MaxImageFly Do
   begin
   ImgMass[i]:=TBitMap.Create;
   ImgMass[i].LoadFromFile('Fly'+IntToStr(i)+'.bmp');
   end;
//sprmin:=2;
//sprmax:=4;
//spr1:=sprmin;
spr:=1;
ThereMove:='left';
//Загружаем изображение мухи в объект
MyCanvas[1].Left:=Xfly;
MyCanvas[1].Top:=Yfly;
MyCanvas[1].Picture.Assign(ImgMass[spr]);
MyCanvas[1].Visible:=True;
MyCanvas[1].Parent:=owner;
self.Timer.Enabled:=true;
end;

procedure TMyFly.TimerFly1Timer(Sender: TObject);
begin
MyCanvas[1].Picture.Assign(ImgMass[spr]);
MyCanvas[1].Visible:=True;
MyCanvas[1].AutoSize:=True;
MyCanvas[1].Parent:=Form1;
MyCanvas[1].Left:=MyCanvas[1].Left+shagx1;
//Делаем так чтобы муха летала от края до края и так далее
grad:=grad+9;
If MyCanvas[1].Left>=xmax then
   begin
   shagx1:=-4;
   ThereMove:='left';
   end;
If MyCanvas[1].Left<xmin then
   begin
   shagx1:=4;
   ThereMove:='right';
   end;
//if MyCanvas[1].Top>ymax then
//  begin

  MyCanvas[1].Top:=Yfly+round(SinFlyMax*Sin(pi/180*grad));
//  end;
//if MyCanvas[1].Top<0 then
//  begin
//  MyCanvas[1].Top:=round(SinFlyMax*Sin(pi/180*grad));
//  end;
//Муха летит влево
If (ThereMove='left') then
   begin
   spr:=1;
   end;
//Муха летит вправо
If (ThereMove='right') then
   begin
   spr:=2;
   end;
end;


procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
i:byte;
begin
for i := 1 to 16 do
   begin
   Worms[i].free;
   end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
WX,WY:word;
i:byte;
begin
Form1.Image1.Canvas.Brush.Color:=clBlack;
Form1.Image1.Canvas.FillRect(Rect(xmin,ymin,xmax,ymax));
Form1.Image1.Width:=xmax;
Form1.Image1.Height:=ymax;
for i := 1 to MaxWorm do
   begin
   Worms[i]:= TMyWorm.CreateWorm(WX,WY, 'left', Form1);
   WX:=xmax; //Worms[i].ImgMass[1].Width;
   WY:=Random(Ymax)-Worms[i].ImgMass[1].Width;

   end;
for i := 1 to MaxFly do
   begin
   Flyes[i]:= TMyFly.CreateFly(WX,WY, 'left', Form1);
   WX:=xmax;
   WY:=Random(Ymax)-Worms[i].ImgMass[1].Width;
   end;
end;

destructor TMyWorm.Destroy;
var
i:byte;
begin
for i := 1 to MyCanvasMax do
   begin
   If MyCanvas[i]<>nil then MyCanvas[i].free;
   end;
For i:=1 to MaxImageWorm Do
   begin
   if ImgMass[i]<>nil then ImgMass[i].free;
   end;
Timer.free;
inherited;
end;

destructor TMyFly.Destroy;
var
i:byte;
begin
for i := 1 to MyCanvasMax do
   begin
   If MyCanvas[i]<>nil then MyCanvas[i].free;
   end;
For i:=1 to  MaxImageFly Do
   begin
   if ImgMass[i]<>nil then ImgMass[i].free;
   end;
Timer.free;
inherited;
end;


end.
