package
{
	import com.alptugan.utils.keys.KeyCode;
	import com.filika.ControlWindow;
	import com.filika.Singleton;
	import com.filika.events.EnergyBarEvent;
	import com.filika.events.GameEvents;
	import com.filika.text.FontParamVO;
	import com.filika.ulker.EndGame;
	import com.filika.ulker.GameStart;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.Bitmap;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.media.Microphone;
	import flash.ui.Mouse;
	
	import org.casalib.display.CasaSprite;
	
	

	public class Core extends CasaSprite
	{
		//Embed fonts 
		[Embed(source="assets/fonts/akaDylan.ttf", embedAsCFF="false", fontName="regular", mimeType="application/x-font", unicodeRange = "U+0000-U+007e,U+00c7,U+00d6,U+00dc,U+00e7,U+00f6,U+00fc,U+0101-U+011f,U+0103-U+0131,U+015e-U+015f")]
		public var Roman:Class;
		
		
		//Embed fonts 
		[Embed(source="assets/fonts/HelveticaNeueLTPro-Roman.otf", embedAsCFF="false", fontName="helveregular", mimeType="application/x-font", unicodeRange = "U+0000-U+007e,U+00c7,U+00d6,U+00dc,U+00e7,U+00f6,U+00fc,U+0101-U+011f,U+0103-U+0131,U+015e-U+015f")]
		public var HelveRoman:Class;
		
		[Embed(source="assets/tatu/bg.jpg")] 
		public static const BackgroundImage:Class;
		private var myBackgroundImage:Bitmap;
		
		private var start:GameStart;
		
		private var end:EndGame;
		
		private var controller:ControlWindow;
		
		public function Core()
		{
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(e:Event):void
		{
			
			initStyle();
			
			
			
			//Mouse.hide();
			myBackgroundImage = new BackgroundImage();
			this.addChild(myBackgroundImage);
			
			myBackgroundImage.width = stage.stageWidth;
			myBackgroundImage.height = stage.stageHeight;
			removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			
			
			//initDebugView();
			
			// Start Game And Init Characters
			start = new GameStart();
			addChild(start);
			start.addEventListener(Event.ADDED_TO_STAGE,onGameStartAdded);
			
			//Keyboard
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			stage.addEventListener(Event.RESIZE, onResize);
			addEventListener(EnergyBarEvent.ENERGY_FINISHED,onEnergyFinished,true);
			
		/*	end = new EndGame();
			end.addEventListener(Event.ADDED_TO_STAGE,onEndAddedToStage);
			addChild(end);*/
			this.MicrophoneController();
			
			//Control Panel
			controller = new ControlWindow();
			addChild(controller);
			controller.hide();
			controller.addEventListener("save",onClickSave);
			
			
		}
		
		/**
		 * TEXT STYLES COLOR, FONTSIZE, FONTNAME 
		 * 
		 */
		private function initStyle():void
		{
			FontParamVO.timefontColor = 0xd41c2f;
			FontParamVO.timefontSize  = 32;
			FontParamVO.fontColor     = 0xd41c2f;
		}
		
		/**
		 * ON SCREEN RESIZE 
		 * @param e
		 * 
		 */
		protected function onResize(e:Event):void
		{
			myBackgroundImage.width = stage.stageWidth;
			myBackgroundImage.height = stage.stageHeight;
			
			trace("Screen Resized\nScreen Resolution : "+myBackgroundImage.width+" x "+myBackgroundImage.height+" px"+"\n----------------------------------------------------------");
		}
		
		/**
		 * CLIKED <SAVE> ON CONTROL PANEL 
		 * @param e
		 * 
		 */
		protected function onClickSave(e:Event):void
		{
			if(start.counter)
				start.counter.resetTimer();
			
			controller.visible ? controller.hide() : void;
		}
		
		/**
		 * GAMESTART CLASS ADDED TO STAGE 
		 * @param e
		 * 
		 */
		protected function onGameStartAdded(e:Event):void
		{
			start.removeEventListener(Event.ADDED_TO_STAGE,onGameStartAdded);
			
			start.addEventListener(GameEvents.COUNTER_ADDED,onCounterAddedToStage);
			trace("startGame class added to stage\n----------------------------------------------------------");
		}
		
		/**
		 * COUNTER & TIMER ADDED TO STAGE 
		 * @param e
		 * 
		 */
		protected function onCounterAddedToStage(e:GameEvents):void
		{
			start.removeEventListener(GameEvents.COUNTER_ADDED,onCounterAddedToStage);
			trace("counter added on Fartonya stage\n----------------------------------------------------------");
			//Check whether the mic is enabled or not
			//if(Singleton.getInstance().myMic.)
				start.counter.initTimer();
			//else
				//Singleton.getInstance().myMic.addEventListener(Event.ACTIVATE,onMicActiveHandler);
		}
		
		/**
		 * DISPATCHED WHEN TIME ENDS 
		 * @param e
		 * 
		 */
		protected function onEnergyFinished(e:Event):void
		{
			end = new EndGame();
			//end.addEventListener(Event.ADDED_TO_STAGE,onEndAddedToStage);
			addChild(end);
			end.addEventListener(GameEvents.GAME_END,onGameEnd);
			trace("time is up game is finished\n----------------------------------------------------------");
		}		
		
		/**
		 * ENDGAME CLASS ADDED TO STAGE HANDLER 
		 * @param e
		 * 
		 */
		protected function onEndAddedToStage(e:Event):void
		{
			//Aligner.alignCenterMiddleToBounds(end,stage.stageWidth,stage.stageHeight,0,0);
			trace("Start to Check for fresh start\n----------------------------------------------------------");
			end.removeEventListener(Event.ADDED_TO_STAGE,onEndAddedToStage);
			
		}
		
		/**
		 * WHEN TWEENS ANIMATIONS FINISH, RESTART GAME  
		 * @param e
		 * 
		 */
		protected function onGameEnd(e:GameEvents):void
		{
			end.removeEventListener(GameEvents.GAME_END,onGameEnd);
			stage.addEventListener(Event.ENTER_FRAME,checkForStart);
			trace("Start to Check for fresh start\n----------------------------------------------------------");
			
		}
		
		/**
		 * CHECK FOR MICROPHONE LEVEL TO RESTART GAME AGAIN 
		 * @param e
		 * 
		 */
		protected function checkForStart(e:Event):void
		{
			if(Singleton.getInstance().myMic.activityLevel*Singleton.getInstance().myMicMultiplier > 90)
			{
				restartGame();
			}
		}		
		
		private function restartGame():void
		{
			if(start.destroyed )
			{
				
				if(end)
					end.removeAllChildrenAndDestroy(true,true);
				
				start = new GameStart();
				addChild(start);
				start.addEventListener(GameEvents.COUNTER_ADDED,onCounterAddedToStage);
				
				trace("game is restarted\n----------------------------------------------------------");
				stage.removeEventListener(Event.ENTER_FRAME,checkForStart);
			}
			this.setChildIndex(controller,this.numChildren-1);
		}		
		
		
		/**
		 * KEYBOARD EVENTS 
		 * @param e
		 * 
		 */
		protected function onKeyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == KeyCode.R)
			{
				if(!start.destroyed)
				{
					if(end)
						end.removeAllChildrenAndDestroy(true,true);
					
					/*removeChild(start);
					start = null;*/
					start.removeAllChildrenAndDestroy(true,true);
					
				}else{
					if(end)
						end.removeAllChildrenAndDestroy(true,true);
					
				}
				
				restartGame();
				
			}
			
			if(e.keyCode == KeyCode.F)
			{
				if(StageDisplayState.NORMAL)
					stage.displayState=StageDisplayState.FULL_SCREEN;
				else
					stage.displayState=StageDisplayState.NORMAL;
			}
			
			if(e.keyCode == KeyCode.C)
			{
				controller.visible ? controller.hide() : controller.show();
			}
		}
		
		
		
		private function MicrophoneController():void
		{
			Singleton.getInstance().myMic = Microphone.getMicrophone();
			//Security.showSettings(SecurityPanel.MICROPHONE);
			Singleton.getInstance().myMic.setLoopBack(true);
			Singleton.getInstance().myMic.setUseEchoSuppression(true);
			Singleton.getInstance().myMic.gain = Singleton.getInstance().micLevel;
		}
		
		protected function onMicActiveHandler(event:Event):void
		{
			trace("microphone is activated\n----------------------------------------------------------");
			Singleton.getInstance().myMic.removeEventListener(Event.ACTIVATE,onMicActiveHandler);
			start.counter.initTimer();
		}		
		
		
	}
}