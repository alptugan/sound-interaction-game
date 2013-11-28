package com.filika.ulker.character
{

	import com.alptugan.utils.maths.MathUtils;
	import com.filika.Singleton;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.casalib.display.CasaSprite;
	import org.casalib.events.LoadEvent;
	import org.casalib.load.ImageLoad;
	import org.casalib.time.Interval;
	
	public class InsectVO extends CasaSprite
	{
		[Embed(source="assets/ulker/ulker-enemy.png")] 
		public static const Enemy:Class;
		
		private var enemyArr:Array = ["assets/tatu/promoter1.png","assets/tatu/promoter2.png","assets/tatu/promoter3.png","assets/tatu/promoter4.png","assets/tatu/promoter5.png"];
		
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
		
		
		
		protected var _imageLoad:ImageLoad;
		
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
			removeEventListeners();
			//trace('bölcük gittüüüüü');
			_interval.destroy();
		}	
		
		

		protected function onAdded(event:Event):void
		{
			
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			this._imageLoad = new ImageLoad(enemyArr[MathUtils.getRandomInt(0,enemyArr.length-1)]);
			this._imageLoad.addEventListener(LoadEvent.COMPLETE, this._onComplete);
			this._imageLoad.start();
			
			mc = new MovieClip();
			addChild(mc);
			
			/*mcBmp = new Enemy() as Bitmap;
			mcBmp.smoothing = true;
			mc.addChild(mcBmp);*
			/
			/*mc = new ApproachingBird();
			addChild(mc);*/
			
			
			
			
			
		}
		
		protected function _onComplete(event:LoadEvent):void
		{
			this._imageLoad.removeEventListener(LoadEvent.COMPLETE, this._onComplete);
			

			// Set To Default Height
			var orgW:int = this._imageLoad.contentAsBitmap.width;
			var orgH:int = this._imageLoad.contentAsBitmap.height;
			
			this._imageLoad.contentAsBitmap.height = Singleton.getInstance().enemyDefH;
			this._imageLoad.contentAsBitmap.width = Singleton.getInstance().enemyDefH*orgW/orgH;
			this._imageLoad.contentAsBitmap.smoothing = true;
			
			mc.addChild(this._imageLoad.contentAsBitmap);
			
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
			
			//mc.rotation ++;
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
					
					
					
					
					TweenMax.to(this,0.5,{ease:Expo.easeOut,alpha:0,scaleX:0,scaleY:0,x:"-20",y:"50",onComplete:function():void{
						
						
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