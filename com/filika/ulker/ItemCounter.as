package com.filika.ulker
{
	import com.alptugan.layout.Aligner;
	import com.alptugan.text.ATextSingleLine;
	import com.filika.Singleton;
	import com.filika.events.EnergyBarEvent;
	import com.filika.events.GameEvents;
	import com.filika.text.FontParamVO;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.casalib.display.CasaSprite;
	
	
	public class ItemCounter extends CasaSprite
	{
		
		
		//Embed TimeCounter Images
		[Embed(source="assets/tatu/time.png")] 
		public static const timeImage:Class;
		private var timeBmp:Bitmap;
		
		private var timerHolder :CasaSprite;
		
		private var txtime : ATextSingleLine;
		
		//public var txt : TextItem;
		
		public var txt : ATextSingleLine;
		
		private var timer:Timer;
		
		public function ItemCounter()
		{
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			
			/*txt = new TextItem("00");
			txt.addEventListener(Event.ADDED_TO_STAGE,onAddedtxt);
			addChild(txt);*/
			
			txt = new ATextSingleLine("00",FontParamVO.fontName,0x333333, FontParamVO.fontSize);
			addChild(txt);
			Aligner.alignToCenterTopToBounds(txt,stage.stageWidth,0,20);
			
			timerHolder = new CasaSprite();
			addChild(timerHolder);
			timeBmp = new timeImage() as Bitmap;
			timeBmp.smoothing = true;
			timeBmp.scaleX = timeBmp.scaleY = 0.5;
			timeBmp.y = 28;
			timeBmp.x = -30;
			timerHolder.addChild(timeBmp);
			
			var timeStr:String = String(Math.ceil(Singleton.getInstance().timeLimit) < 10 ? "0"+Math.ceil(Singleton.getInstance().timeLimit) : Math.ceil(Singleton.getInstance().timeLimit));
			
			txtime = new ATextSingleLine(timeStr+":"+"00",FontParamVO.timefontName,0x333333,FontParamVO.timefontSize);
			timerHolder.addChild(txtime);
			txtime.x = 30;
			txtime.y = 42;
			
			Aligner.alignTopRightToBounds(timerHolder,stage.stageWidth,stage.stageHeight,0,-2);
			
			var ev:GameEvents = new GameEvents(GameEvents.COUNTER_ADDED);
			dispatchEvent(ev);
		}
		
		protected function onAddedtxt(e:Event):void
		{
			e.target.removeEventListener(Event.ADDED_TO_STAGE,onAddedtxt);
			
			trace("textanim done\n----------------------------------------------------------");
			
		}
		
		public function resetTimer():void
		{
			var evt:EnergyBarEvent = new EnergyBarEvent(EnergyBarEvent.ENERGY_FINISHED);
			dispatchEvent(evt);
		}
		
		public function initTimer():void
		{
			if(!timer)
				timer = new Timer(1000, Math.ceil(Singleton.getInstance().timeLimit*60));
			
			if(!timer.hasEventListener(TimerEvent.TIMER))
				timer.addEventListener(TimerEvent.TIMER, countdown);
			
			if(!timer.hasEventListener(TimerEvent.TIMER_COMPLETE))
				timer.addEventListener(TimerEvent.TIMER_COMPLETE,onCompleteTimer);
			
			if(!timer.running)
				timer.start();
			else {
				timer.stop();
				timer.reset();
				timer.start();
			}
		}
		
		protected function onCompleteTimer(e:TimerEvent):void
		{
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onCompleteTimer);
			timer.removeEventListener(TimerEvent.TIMER, countdown);
			timer.reset();
			var evt:EnergyBarEvent = new EnergyBarEvent(EnergyBarEvent.ENERGY_FINISHED);
			dispatchEvent(evt);
			trace("time is finished game ends\n----------------------------------------------------------");
		}
		
		private function countdown(event:TimerEvent):void {
			var totalSecondsLeft:Number = ( Math.ceil(Singleton.getInstance().timeLimit*60)) - timer.currentCount;
			txtime.SetText(timeFormat(totalSecondsLeft));
		}
		
		private function timeFormat(seconds:int):String {
			var minutes:int;
			var sMinutes:String;
			var sSeconds:String;
			if(seconds > 59) {
				minutes = Math.floor(seconds / 60);
				sMinutes = String(minutes);
				sSeconds = String(seconds % 60);
			} else {
				sMinutes = "0";
				sSeconds = String(seconds);
			}
			if(sSeconds.length == 1) {
				sSeconds = "0" + sSeconds;
			}
			
			if(sMinutes.length == 1) {
				sMinutes = "0" + sMinutes;
			}
			
			
			return sMinutes + ":" + sSeconds;
		}
	}
}