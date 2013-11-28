package com.filika
{
	import com.alptugan.layout.Aligner;
	import com.filika.character.InsectVO;
	import com.filika.events.EnergyBarEvent;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	
	import org.casalib.display.CasaSprite;
	import org.casalib.math.Percent;
	import org.casalib.time.Interval;
	import org.casalib.util.ColorUtil;
	
	public class GameStart extends CasaSprite
	{
		[Embed(source="assets/char-fantorya.png")] 
		public static const image:Class;
		
		
		private var charSprite:CasaSprite = new CasaSprite();
		private var myChar:Bitmap;
			
		
		
		// Insects Vector Class
		private var insect:InsectVO;
		
		// Max - Min range of insect moving speed
		private var moveMax:int = 6;
		private var moveMin : int  = 2;
		
		// Amount of health reduction
		private var hitPower:Number = 20;
		
		// Collision Detection - 
		private var hitTest:Boolean = false;
		
		// Bitmapdata of charSprite to draw exact pixels for hit collision 
		private var myCharBmpData:BitmapData;
		
		//
		
		private var healthBar:EnergyBar;
		
		protected var _interval:Interval;
		
		private var i:int;
		
		
		private var Altitude:int;

		private var identity:int = 0;
		public var InsectContainer:CasaSprite;
		
		private var delay:int = 4000;
		// Mic threshold
		private var thresh: Number;

		public var counter:ItemCounter;

		private var colCounter:int;
		private var Score:String;
		
		public function GameStart()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		
		protected function onRemoved(e:Event):void
		{
			
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			this._interval.destroy();
			removeEventListener(EnergyBarEvent.ENERGY_FINISHED,onEnergyFinished,true);
			removeEventListener('isCollision',onCollision,true);
			
			stage.removeEventListener(Event.ENTER_FRAME, ControlCharacter);
		}		
		
		
		protected function onAdded(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			initGame();
		}
		
		private function initGame():void
		{
			InsectContainer = new CasaSprite();
			addChild(InsectContainer);
			
			myChar = new image();
			
			charSprite.addChild(myChar);
			myChar.x = -myChar.width>>1;
			//charSprite.x = (stage.stageWidth - charSprite.width) * 0.5;
			charSprite.x = 20 + myChar.width*0.5;
			charSprite.y = 600;//(stage.stageHeight - charSprite.height) * 0.5;
			
			
			// draw Bitmap for bitmap hittest
			var redRect:Rectangle = charSprite.getBounds(this);
			myCharBmpData = new BitmapData(redRect.width, redRect.height, true,0);
			myCharBmpData.draw(charSprite);
			
		
			this.addChild(charSprite);

			
			createInsectTimer();
			//createEnergyBar();
			createItemCounter();
			
			
			
			thresh = Singleton.getInstance().micLevel;
			
			addEventListener(EnergyBarEvent.ENERGY_FINISHED,onEnergyFinished,true);
			addEventListener('isCollision',onCollision,true);
			
			stage.addEventListener(Event.ENTER_FRAME, ControlCharacter);
			
		}
		
			
		
		
		private function ControlCharacter(e:Event):void{
			
		
			
			
			var MicLevel:int = 6 * (50 - Singleton.getInstance().myMic.activityLevel);
			Altitude = (stage.stageHeight - charSprite.height) * 0.5 + MicLevel;
			
			if(Altitude > stage.stageHeight - charSprite.height) Altitude = stage.stageHeight - charSprite.height ;

			TweenMax.to(charSprite, 1, {y:Altitude});
		
			
			/*if(charSprite.y < stage.stageHeight - charSprite.height - 10)
			{
				charSprite.scaleX=1;
				
			}else{
				charSprite.scaleX=-1;
			}*/
		}
	
		
		/**
		 * SANİYEDE BİR BÖCEK ÜRETİYOR 
		 * 
		 */
		private function createInsectTimer():void
		{	
			i = 0;
			this._interval = Interval.setInterval(CreateInsects,delay);
			this._interval.repeatCount = 1;
			this._interval.start();
		}
		
		/**
		 * CREATES INSETCS
		 * 
		 */
		private function CreateInsects():void
		{
			
			insect  = new InsectVO(String(identity),Math.random()*moveMax+moveMin,myCharBmpData,charSprite);
			InsectContainer.addChild(insect);
			
			insect.x = stage.stageWidth - insect.width;
			insect.y = Math.random()*(stage.stageHeight - insect.height) + insect.height ;
			
			// Reset timer and restart it again. Loop it until hatun dies
			this._interval.reset();
			this._interval.start();
			identity++;
			
			if(identity > 10 && identity < 30)
			{
				moveMax = 8;
				moveMin = 3;
				this._interval.delay = 3000;
			}
				
			
			if(identity < 50 && identity > 30 )
			{
				moveMax = 11;
				moveMin = 5;
				this._interval.delay = 2000;
			}
				
			
			if(identity > 80)
			{
				moveMax = 15;
				moveMin = 8;
				this._interval.delay = 1000;
			}
				
			
		}
		
		/**
		 * GAME IS FINISHED 
		 * @param e
		 * 
		 */
		public function onEnergyFinished(e:Event=null):void
		{
			this._interval.destroy();
			removeEventListener('isCollision',onCollision,true);
			removeEventListeners();
			
			//Stop EnterframeHAndler
			stage.removeEventListener(Event.ENTER_FRAME, ControlCharacter);
			
			//Move Hatun out of the stage
			TweenMax.to(charSprite, 1, {y:-charSprite.height - 100,ease:Expo.easeOut});
			
			
			

			/*for (var k:int = 0; k < InsectContainer.numChildren; k++) 
			{
				TweenMax.to(InsectContainer.getChildAt(k), 1, {delay:0.5*k, ease:Expo.easeOut, onComplete:RemoveEverything,onCompleteParams:[k]});
			}*/
			
			while( InsectContainer.numChildren > 0 )
			{					
				InsectContainer.removeChildAt( 0 );
			}
			
			removeEventListener(EnergyBarEvent.ENERGY_FINISHED,onEnergyFinished,true);
			InsectContainer.removeAllChildrenAndDestroy(true,true);
			removeAllChildrenAndDestroy(true,true);
			
		}
		
		protected function RemoveEverything(ko:int):void
		{
			if(ko == InsectContainer.numChildren-1)
			{
				/*myCharBmpData.dispose();
				myChar = null;*/
				
				
				
			}
			
			//removeAllChildrenAndDestroy(true,true);
			removeAllChildrenAndDestroy(true,true);
			removeEventListener(EnergyBarEvent.ENERGY_FINISHED,onEnergyFinished,true);
		}
		
		/**
		 * COUNT COLLECTED ITEMS 
		 * 
		 */
		private function createItemCounter():void
		{
			counter = new ItemCounter();
			addChild(counter);
			counter.addEventListener(Event.ADDED_TO_STAGE,onItemCounterAddedToStage);
		}	
		
		protected function onItemCounterAddedToStage(e:Event):void
		{
			counter.removeEventListener(Event.ADDED_TO_STAGE,onItemCounterAddedToStage);
			
			trace("counter added to stage");
		}		
		
		
		/**
		 * CREATES ENERGY BAR ON TOP OF THE STAGE 
		 * 
		 */
		private function createEnergyBar():void
		{
			healthBar = new EnergyBar();
			addChild(healthBar);
			
			Aligner.alignToCenterTopToBounds(healthBar,stage.stageWidth,0,10);
		}		
		
		/**
		 * ON COLLISION 
		 * @param e
		 * 
		 */
		protected function onCollision(e:Event):void
		{
			colCounter++;
			//healthBar.energy = hitPower;
			
			if(colCounter < 10)
				Score = "0"+String(colCounter);
			else
				Score = String(colCounter);
			
			counter.txt.SetText( Score);

			tint(charSprite,0xff0000,0.7);
			new delayedFunctionCall(onNoCollision,1,{});
		}
		
		
		private function tint (clip:Object, newColor:uint,alp:Number):void
		{
			var myColor:ColorTransform = new ColorTransform();
			myColor.color              = newColor;
			
			clip.transform.colorTransform = ColorUtil.interpolateColor(new ColorTransform(), myColor, new Percent(alp));
			
		}
		
		protected function onNoCollision(ko:Object):void
		{
			//if(!Singleton.getInstance().bolHit)
			tint(charSprite,0,0);
		}
		
		
		
	}
	
}