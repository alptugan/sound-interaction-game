package com.filika
{
	import flash.display.StageDisplayState;
	import flash.events.Event;
	
	import org.casalib.display.CasaSprite;
	
	import uk.co.soulwire.gui.SimpleGUI;
	
	public class ControlWindow extends CasaSprite
	{
		public var gui:SimpleGUI;
		
		public var fullScreen:Boolean = false;
		public var timeValue : Number = 2.;
		public var microphoneVolume : int = 50;
		
		public function ControlWindow()
		{
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(e:Event):void
		{
			timeValue = Singleton.getInstance().timeLimit;
			microphoneVolume = Singleton.getInstance().myMic.gain;
			
			removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			
			gui = new SimpleGUI(this,"FiLiKA SOUND INTERACTION GAME PARAMETER CONTROLS");
		
			gui.addGroup();
			//gui.addButton("Browse", {callback:BrowseForFiles,width:appWin.bounds.width - 10});
		
			gui.addToggle('fullScreen',{callback:ChangeScreenRes});
			gui.addGroup('CALIBRATION');
			gui.addStepper('timeValue',0.9,6.,{callback:setTimeValues,step:0.5,labelPrecision:2});
			gui.addStepper("microphoneVolume",0,100,{callback:setMicrophoneInputVol,step:1,labelPrecision:1});
			gui.addButton("save parameters",{callback:saveAndStartGame});
			//gui.hotKey = "c";
			hide();
		}
		
		public function show():void
		{
			this.visible = true;
			gui.show();
		}
		
		public function hide():void
		{
			this.visible = false;
			gui.hide();
		}
		
		protected function ChangeScreenRes():void
		{
			if(fullScreen)
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE; 
			else
				stage.displayState = StageDisplayState.NORMAL; 
		}
		
		protected function setTimeValues():void
		{
			
			var secTotal : Number = timeValue*60;
			var sec:String = String(Math.ceil(secTotal % 60));
			sec == "0" ? sec = "00" : sec = sec;
			var min:Number = Math.floor(secTotal/60);
			
			trace("Game Time is set to "+min + ":" + sec + " minutes"+"\n----------------------------------------------------------");
		}
		
		protected function setMicrophoneInputVol():void
		{
			Singleton.getInstance().myMic.gain = microphoneVolume;
		}
		
		protected function saveAndStartGame():void
		{
			Singleton.getInstance().timeLimit = timeValue;
			trace("parameters are saved...\nready to start\n----------------------------------------------------------");
			dispatchEvent(new Event("save"));
			hide();
		}
	}
}