package com.filika.character
{
	import com.filika.Singleton;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.casalib.display.CasaMovieClip;
	import org.casalib.display.CasaSprite;
	import org.casalib.time.Interval;
	
	public class InsectVO extends CasaSprite
	{
		[Embed(source="assets/ball.png")] 
		public static const Enemy:Class;
		
		
		//public var mc:ApproachingBird;
		public var mc:MovieClip;
		private var mcBmp:Bitmap;
		public var speed:Number;
		public var id:int;
		private var _xPos:Number;
		private var _bolHit:Boolean;

		public var insectBmdData:BitmapData;
		private var _interval:Interval;
		
	    private var myCharBmpData:BitmapData;
		private var charSprite:Sprite;
		private var isim:String;
		
		public function InsectVO(isim:String,speed:Number,myCharBmpData:BitmapData,charSprite:Sprite)
		{
			this.speed = speed;
			this.myCharBmpData = myCharBmpData;
			this.charSprite = charSprite;
			this.name = isim;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		
		protected function onRemoved(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			//trace('bölcük gittüüüüü');
			_interval.destroy();
		}	
		
		

		protected function onAdded(event:Event):void
		{
			
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			mc = new MovieClip();
			addChild(mc);
			
			mcBmp = new Enemy() as Bitmap;
			mcBmp.smoothing = true;
			mc.addChild(mcBmp);
			/*mc = new ApproachingBird();
			addChild(mc);*/
			
			var blueRect:Rectangle = mc.getBounds(this);
			
			insectBmdData = new BitmapData(blueRect.width, blueRect.height, true, 0);
			insectBmdData.draw(mc);
			
			createInsectTimer();
			
			
			
		}
		
		private function createInsectTimer():void
		{	
			this._interval = Interval.setInterval(updateInsectPos, 2);
			this._interval.repeatCount = 1;
			this._interval.start();
		}
		
		public function updateInsectPos():void
		{
			this.x -= speed;
			mc.rotation ++;
			this._interval.reset();
			this._interval.start();
			updateCharPos();
		}
		
		public function updateCharPos():void
		{
			if(myCharBmpData.hitTest(new Point(charSprite.x, charSprite.y), 255, this.insectBmdData,new Point(this.x, this.y),0))
			{
				dispatchEvent(new Event('isCollision'));
				if(!this.bolHit /*&& this != null*/)
				{
					Singleton.getInstance().bolHit = true;
					
					
					//healthBar.energy = hitPower;
					this._interval.destroy();
					
					this.bolHit = true;
					
					
					
					
					TweenMax.to(this,0.5,{ease:Expo.easeOut,alpha:0,scaleX:1.3,scaleY:1.3,tint:0xff0000,onComplete:function():void{
						
						
						removeChild(mc);
						mc = null;
						insectBmdData.dispose();
						removeAllChildrenAndDestroy(true,true);
						
					}});
					
				}else{
					
				}
				
			}else{
				//charSprite.filters = [];
				
			
			}
		}
		
	
		public function get bolHit():Boolean
		{
			return _bolHit;
		}
		
		public function set bolHit(value:Boolean):void
		{
			_bolHit = value;
		}
		
		public function set xPos(value:Number):void
		{
			_xPos = value;
		}
		
		public function get xPos():Number
		{
			return this.x;
		}
		
		
	}
}