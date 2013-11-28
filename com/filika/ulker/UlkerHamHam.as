package com.filika.ulker
{
	import com.alptugan.globals.Root;
	import com.alptugan.layout.Aligner;
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
	
	import src.com.azinliklarittifaki.gallery.control.Control;
	
	
	[SWF(width="1366", height="768")]
	public class UlkerHamHam extends Root
	{
		
		
		[Embed(source="assets/ulker/ulker-bg.png")] 
		public static const BackgroundImage:Class;
		private var myBackgroundImage:Bitmap;
		
		private var start:GameStart;
		
		private var end:EndGame;
		
		private var controller:ControlWindow;
		
		public function UlkerHamHam	()
		{
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		public function restartAndDestroy():void
		{
			removeEventListeners();
			removeAllChildrenAndDestroy(true,true);
		}
		
		protected function onAdded(e:Event):void
		{
			initStage();
			initStyle();
			
			this.MicrophoneController();
			
			Mouse.hide();
			myBackgroundImage = new BackgroundImage();
			this.addChild(myBackgroundImage);
			myBackgroundImage.width = stage.stageWidth;
			myBackgroundImage.height = stage.stageHeight;
			removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			
			
			//initDebugView();
			
			// Start Game And Init Characters
			start = new GameStart();
			start.addEventListener(Event.ADDED_TO_STAGE,onGameStartAdded);
			addChild(start);
			
			
			//Keyboard
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			stage.addEventListener(Event.RESIZE, onResize);
			addEventListener(EnergyBarEvent.ENERGY_FINISHED,onEnergyFinished,true);
			
		/*	end = new EndGame();
			end.addEventListener(Event.ADDED_TO_STAGE,onEndAddedToStage);
			addChild(end);*/
			
			
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
			try
			{
				myBackgroundImage.width = stage.stageWidth;
				myBackgroundImage.height = stage.stageHeight;
			} 
			catch(error:Error) 
			{
				
			}
			
			
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
			
			start.counter.addEventListener(Event.ADDED_TO_STAGE,onCounterAddedToStage);
			trace("startGame class added to stage\n----------------------------------------------------------");
		}
		
		/**
		 * COUNTER & TIMER ADDED TO STAGE 
		 * @param e
		 * 
		 */
		protected function onCounterAddedToStage(e:Event):void
		{
			start.counter.removeEventListener(Event.ADDED_TO_STAGE,onCounterAddedToStage);
			trace("counter added on Ülker stage\n----------------------------------------------------------");
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
			end.addEventListener(Event.ADDED_TO_STAGE,onEndAddedToStage);
			addChild(end);
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
			end.removeEventListener(Event.ADDED_TO_STAGE,onEndAddedToStage);
			end.addEventListener(GameEvents.GAME_END,onGameEnd);
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
			trace("buraya girebildin mi _? 111");
			
			if(start)
			{
				start.destroy();
			}
				trace("buraya girebildin mi _? 222");
				start = new GameStart();
				addChild(start);
				start.counter.initTimer();
				
				if(end)
					end.removeAllChildrenAndDestroy(true,true);
				
					
					
			
				trace("game is restarted\n----------------------------------------------------------");
				stage.removeEventListener(Event.ENTER_FRAME,checkForStart);
			
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
				/*if(!start.destroyed || start == null)
				{
					if(end)
						end.removeAllChildrenAndDestroy(true,true);
					
					removeChild(start);
					start = null;					
				}else{
					if(end)
						end.removeAllChildrenAndDestroy(true,true);
					
				}*/
				
				//restartGame();
				
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
			Singleton.getInstance().myMic.gain = 100;
		}
		
		protected function onMicActiveHandler(event:Event):void
		{
			trace("microphone is activated\n----------------------------------------------------------");
			Singleton.getInstance().myMic.removeEventListener(Event.ACTIVATE,onMicActiveHandler);
			start.counter.initTimer();
		}		
		
		
	}
}