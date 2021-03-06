//+------------------------------------------------------------------+
//|                                                         xixi.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

input double MaxLoss          = 30;
input bool ForbiddenTradeInMorning = true;
input bool MovingToCost = true;
input int CostPoint = 30;
input string TrendPeriod = "PERIOD_D1";

double Bottom[2], Top[2];
int trend_period = PERIOD_CURRENT;
int trend = 0;//0 represent no, 1 represent up, -1 represent down
bool in_bottom = false;
bool in_top = false;
int last_trend_day = -1;

int OnInit()
{
   if (TrendPeriod == "PERIOD_D1")
      trend_period = PERIOD_D1;
   if (TrendPeriod == "PERIOD_H4")
      trend_period = PERIOD_H4;
   if (TrendPeriod == "PERIOD_H1")
      trend_period = PERIOD_H1;
   PrintFormat("trend period is %d minutes", trend_period);
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
 {
   
 }
 
 void DebugInfo()
 {
   PrintFormat("Last 3 high is %f, %f, %f", iHigh(NULL, trend_period, 3), iHigh(NULL, trend_period, 2), iHigh(NULL, trend_period, 1));
   PrintFormat("Last 3 low is %f, %f, %f", iLow(NULL, trend_period, 3), iLow(NULL, trend_period, 2), iLow(NULL, trend_period, 1));
   if(in_top){
      Print("Xixi in top");
   }
   if(in_bottom){
      Print("Xixi in bottom");
   }
   if(trend == 1){
      Print("Trend is up");
   }
   if(trend == -1){
      Print("Trend is down");
   }
 }

void CalcTrend(){
   trend = 0;
   

   if (iHighest(NULL, trend_period, MODE_HIGH, 3, 1) == 2){
      //is top
      Top[0] = Top[1];
      Top[1] = iHigh(NULL, trend_period, 2);
      in_top = true;
   }
   else {
      in_top = false;
   }

   if (iLowest(NULL, trend_period, MODE_LOW, 3, 1) == 2){
      PrintFormat("before Bottom[1] is %f, Bottom[0] is %f", Bottom[1], Bottom[0]);
      Bottom[0] = Bottom[1];
      PrintFormat("2xx before Bottom[1] is %f, Bottom[0] is %f", Bottom[1], Bottom[0]);
      Print(iLow(NULL, trend_period, 2));
      Bottom[1] = iLow(NULL, trend_period, 2);
      PrintFormat("3xx before Bottom[1] is %f, Bottom[0] is %f", Bottom[1], Bottom[0]);
      in_bottom = true;
   }
   else{
      in_bottom = false;
   }
   /*
   if ((in_top == true) && (in_bottom == true){
      return;
   }
   */
   
   if(in_top){     
      PrintFormat("Top[1] is %f, Top[0] is %f", Top[1], Top[0]);
      if(Top[1] < Top[0]){
         trend = -1;
      }
   }
   
   if(in_bottom){
      PrintFormat("Bottom[1] is %f, Bottom[0] is %f", Bottom[1], Bottom[0]);
      if(Bottom[1] > Bottom[0]){
         trend = 1;
      }
      
      
   }
   
   DebugInfo();
     
}

bool can_sell(){
   return true;
}

bool can_buy(){
   return false;
}

void DoTrade(){
  if(trend == 1)// 1 represent after top
   {
     
      if(can_sell())
      {
      
      }
      //can_sell?
   }

   if (trend == -1) // -1 represent after bottom
   {
      //can_buy?
   
      if(can_buy()){
      }
   }
}

void OnTick()
{

   if(Bars<100 || IsTradeAllowed()==false)
      return;
   int current_day = TimeDay(TimeCurrent());
   
   if (current_day != last_trend_day){ //only compute trend in 1:00 am, one day once.
      PrintFormat("last_trend_day = %d, current_day = %d", last_trend_day, current_day);
      last_trend_day = current_day;
      CalcTrend();
   }
   DoTrade();   
    
}