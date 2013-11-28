package com.filika.ulker
{
	import com.filika.Singleton;
	import com.filika.events.EnergyBarEvent;
	import com.filika.events.GameEvents;
	import com.filika.ulker.character.InsectVO;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Expo;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import org.casalib.display.CasaSprite;
	import org.casalib.events.LoadEvent;
	import org.casalib.load.ImageLoad;
	import org.casalib.time.Interval;
	
	public class GameStart extends CasaSprite
	{
		//private var charSprite:MovieClip = new Hamham();
		
		private var charSprite:CasaSprite;
		private var charLoader:ImageLoad;
		
		// Insects Vector Class
		private var insect:InsectVO;
		
		// Max - Min range of insect moving speed
		private var moveMax:int = 6;
		private var moveMin : int  = 2;
		
		// Amount of health reduction
		private var enemyPosFac:int = 150;
		
		// Collision Detection - 
		private var hitTest:Boolean = false;
		
		// Bitmapdata of charSprite to draw exact pixels for hit collision 
		private var myCharBmpData:BitmapData;
		
		//
		
		
		protected var _interval:Interval;
		
		private var i:int;
		
		
		private var Altitude:int;

		private var identity:int = 0;
		public var InsectContainer:CasaSprite;
		
		private var delay:int = 4000;


		public var counter:ItemCounter;

		private var colCounter:int;
		

		private var charSpriteH:int;

		private var stageH:int;

		private var stageW:*;
		private var mainCharSrc:String = "assets/tatu/promoter - rasgele.png";
		
		public function GameStart()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		
		protected function onRemoved(e:Event):void
		{
			
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			this.removeEventListeners();
			this._interval.destroy();
			removeEventListener(EnergyBarEvent.ENERGY_FINISHED,onEnergyFinished,true);
			removeEventListener('isCollision',onCollision,true);
			
			
		}		
		
		
		protected function onAdded(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			initCharacter();
			
		}
		
		private function initCharacter():void
		{
			charSprite = new CasaSprite();
			this.addChild(charSprite);
			
			charLoader = new ImageLoad(mainCharSrc);
			charLoader.addEventListener(LoadEvent.COMPLETE, this._onComplete);
			charLoader.start();
		}
		
		/**
		 * ADD CHARACTER TO THE STAGE 
		 * THEN START TO LOAD GAME 
		 * @param e
		 * 
		 */
		protected function _onComplete(e:Event):void
		{
			charLoader.removeEventListener(LoadEvent.COMPLETE, this._onComplete);
			charSprite.addChild(this.charLoader.contentAsBitmap);
			charLoader.contentAsBitmap.smoothing = true;
			
			// Set To Default Height
			var orgW:int = this.charLoader.contentAsBitmap.width;
			var orgH:int = this.charLoader.contentAsBitmap.height;
			
			this.charLoader.contentAsBitmap.height = Singleton.getInstance().charDefH;
			this.charLoader.contentAsBitmap.width = Singleton.getInstance().charDefH*orgW/orgH;
			
			// load game
			initGame();
		}
		
		private function initGame():void
		{
			InsectContainer = new CasaSprite();
			addChild(InsectContainer);
			
	
			charSprite.x = 10;
			//charSprite.x = 10+charSprite.width*0.5;
			charSprite.y = stage.stageHeight - charSprite.height;
			
			// draw Bitmap for bitmap hittest
			var redRect:Rectangle = getBounds(charSprite);
			//redRect.x = charSprite.x;
			myCharBmpData = new BitmapData(redRect.width, redRect.height, true,0);
			
			myCharBmpData.draw(charSprite);
			
			createInsectTimer();
			//createEnergyBar();
			createItemCounter();
			
			
			addEventListener(EnergyBarEvent.ENERGY_FINISHED,onEnergyFinished,true);
			addEventListener('isCollision',onCollision,true);
			
			
			charSpriteH = charSprite.height*0.5;
			
			stage.addEventListener(Event.ENTER_FRAME, ControlCharacter);
			
			stageH = stage.stageHeight;
			stageW = stage.stageWidth;
		}
		
			
		
		
		private function ControlCharacter(e:Event):void
		{
			var MicLevel:int = stageH  / 100 * (Singleton.getInstance().myMic.activityLevel);
			
			Altitude = (stageH - charSpriteH) - MicLevel*Singleton.getInstance().myMicMultiplier;
			
			if(Altitude < 0) Altitude = charSpriteH;

			TweenMax.to(charSprite, 1, {y:Altitude});
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
			
			insect.x = stageW - insect.width;
			insect.y = Math.random()*(stageH - insect.height - enemyPosFac) + enemyPosFac ;
			
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
			while( InsectContainer.numChildren > 0 )
			{					
				InsectContainer.removeChildAt( 0 );
			}
			
			removeChild(InsectContainer);
			InsectContainer = null;
			
			while(this.numChildren > 0)
			{
				removeChildAt(0);
			}
			
			
			
			removeEventListener(EnergyBarEvent.ENERGY_FINISHED,onEnergyFinished,true);
			//InsectContainer.removeAllChildrenAndDestroy(true,true);
			removeAllChildrenAndDestroy(true,true);
			
		}
		
		
		/**
		 * COUNT COLLECTED ITEMS 
		 * 
		 */
		private function createItemCounter():void
		{
			counter = new ItemCounter();
			counter.addEventListener(GameEvents.COUNTER_ADDED,onItemCounterAddedToStage);
			addChild(counter);
			
		}	
		
		protected function onItemCounterAddedToStage(e:Event):void
		{
			counter.removeEventListener(GameEvents.COUNTER_ADDED,onItemCounterAddedToStage);
			var ev:GameEvents = new GameEvents(GameEvents.COUNTER_ADDED);
			dispatchEvent(ev);
			trace("counter added to stage\n----------------------------------------------------------");
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
				Singleton.getInstance().Score = "0"+String(colCounter);
			else
				Singleton.getInstance().Score = String(colCounter);
			
			counter.txt.SetText( Singleton.getInstance().Score);
			
			//charSprite.gotoAndStop(1);
			TweenMax.to(charSprite, 0.3, {scaleX:1.1,x:"10",scaleY: 1.1, ease:Elastic.easeOut,onComplete:function():void{
				TweenMax.to(charSprite, 0.3, {scaleX:1,x:10,scaleY: 1,ease:Expo.easeOut});
				//charSprite.play();
			}});
		}
	}
	
}