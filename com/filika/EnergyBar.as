package com.filika
{
	import com.alptugan.drawing.shape.RoundRectShape;
	import com.alptugan.drawing.style.FillStyle;
	import com.alptugan.layout.Aligner;
	import com.filika.events.EnergyBarEvent;
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	import org.casalib.display.CasaShape;
	import org.casalib.display.CasaSprite;
	
	public class EnergyBar extends CasaSprite
	{
		[Embed(source="assets/energy/heart.png")]
		protected var HeartClass:Class;
		
		private var heart:Bitmap;
		private var heartHolder:CasaSprite;
		private var bgRect : RoundRectShape;
		
		private var rect:RoundRectShape;
		

		public function EnergyBar()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		
		
		protected function onAdded(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			heartHolder = new CasaSprite();
			addChild(heartHolder);
			
			heart = new HeartClass() as Bitmap;
			heart.cacheAsBitmap = true;
			heart.smoothing = true;
			heartHolder.addChild(heart);
			heart.x = -heart.width*0.5;
			heart.y = -heart.height*0.5;
			
			
			
			
			
			bgRect = new RoundRectShape(new Rectangle(0,0,258,6),new FillStyle(0xffffff,0.3));
			addChild(bgRect);
			bgRect.y = 70;
			
			
			rect = new RoundRectShape(new Rectangle(0,0,258,6),new FillStyle(0xf84545,1));
			addChild(rect);
			rect.y = 70;
			
			rect.filters = [new GlowFilter(0xff0000,0.5,12,12)];
			
			
			heartHolder.y = heart.height*0.5;
			heartHolder.x =((bgRect.width - (heart.width)) >> 1)  + heart.width*0.5;
			
			
			TweenMax.to(heartHolder,1.5,{scaleX:0.95,scaleY:0.95,repeat: -1,yoyo: true});
		}
		
		public function set energy(val:Number):void
		{
			if(rect.width - val <  0)
			{
				rect.width = 0;
				heartHolder.scaleX = 1;
				heartHolder.scaleY = 1;
				TweenMax.to(rect,0.5,{width:bgRect.width});
				var evt:EnergyBarEvent = new EnergyBarEvent(EnergyBarEvent.ENERGY_FINISHED);
				dispatchEvent(evt);
			}else{
				TweenMax.to(rect,0.5,{width:rect.width - val,onComplete:setHeartBeat});
				//rect.width = rect.width - val;
				
			}
		}
		
		private function setHeartBeat():void
		{
			
			
 			
			if(rect.width < bgRect.width*0.1) {
				heartHolder.scaleX = 1;
				heartHolder.scaleY = 1;
				TweenMax.to(heartHolder,0.2,{scaleX:0.8,scaleY:0.8,repeat: -1,yoyo: true});
			}
		}
	}
}