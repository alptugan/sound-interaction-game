package com.filika
{
	import com.alptugan.layout.Aligner;
	import com.alptugan.text.ATextSingleLine;
	import com.filika.events.EnergyBarEvent;
	import com.filika.events.GameEvents;
	import com.filika.text.FontParamVO;
	import com.filika.text.TextItem;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.casalib.display.CasaSprite;
	
	public class ItemCounter extends CasaSprite
	{
		//Embed fonts 
		[Embed(source="assets/fonts/akaDylan.ttf", embedAsCFF="false", fontName="regular", mimeType="application/x-font", unicodeRange = "U+0000-U+007e,U+00c7,U+00d6,U+00dc,U+00e7,U+00f6,U+00fc,U+0101-U+011f,U+0103-U+0131,U+015e-U+015f")]
		public var Roman:Class;
		
		
		//Embed fonts 
		[Embed(source="assets/fonts/HelveticaNeueLTPro-Roman.otf", embedAsCFF="false", fontName="helveregular", mimeType="application/x-font", unicodeRange = "U+0000-U+007e,U+00c7,U+00d6,U+00dc,U+00e7,U+00f6,U+00fc,U+0101-U+011f,U+0103-U+0131,U+015e-U+015f")]
		public var HelveRoman:Class;
		
		//Embed TimeCounter Images
		[Embed(source="assets/time.png")] 
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
			
			txt = new ATextSingleLine("00",FontParamVO.fontName, FontParamVO.fontColor, FontParamVO.fontSize);
			addChild(txt);
			Aligner.alignToCenterTopToBounds(txt,stage.stageWidth,0,10);
			
			timerHolder = new CasaSprite();
			addChild(timerHolder);
			timeBmp = new timeImage() as Bitmap;
			timerHolder.addChild(timeBmp);
			
			txtime = new ATextSingleLine(Math.ceil(Singleton.getInstance().timeLimit)+":"+"00",FontParamVO.timefontName,FontParamVO.timefontColor,FontParamVO.timefontSize);
			timerHolder.addChild(txtime);
			txtime.x = 45;
			txtime.y = 35;
			
			Aligner.alignTopRightToBounds(timerHolder,stage.stageWidth,stage.stageHeight,-20,27);
			
			
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
			
			
			
			return sMinutes + ":" + sSeconds;
		}
	}
}