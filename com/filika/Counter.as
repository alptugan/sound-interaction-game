package com.filika
{
	import com.alptugan.text.ATextSingleLine;
	import com.filika.text.FontParamVO;
	
	import flash.events.Event;
	
	import org.casalib.display.CasaSprite;
	
	public class Counter extends CasaSprite
	{
		//Embed fonts 
		[Embed(source="assets/fonts/HelveticaNeueLTPro-Roman.otf", embedAsCFF="false", fontName="helveregular", mimeType="application/x-font", unicodeRange = "U+0000-U+007e,U+00c7,U+00d6,U+00dc,U+00e7,U+00f6,U+00fc,U+0101-U+011f,U+0103-U+0131,U+015e-U+015f")]
		public var HelveRoman:Class;
		
		private var txt : ATextSingleLine;
		
		public function Counter()
		{
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			
			txt = new ATextSingleLine("0:"+Singleton.getInstance().timeLimit+":"+"59",FontParamVO.timefontName,FontParamVO.timefontColor,FontParamVO.timefontSize);
			addChild(txt);
		}
	}
}