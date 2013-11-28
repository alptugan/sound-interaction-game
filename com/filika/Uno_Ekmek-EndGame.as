package com.filika
{
	import com.alptugan.globals.Root;
	import com.alptugan.layout.Aligner;
	import com.filika.events.GameEvents;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import org.casalib.display.CasaSprite;
	
	public class EndGame extends Root
	{
		
		[Embed(source="assets/end/end.png")]
		protected var GameOverClass:Class;
		
		
		[Embed(source="assets/end/ivy.png")]
		protected var IvyMessageClass:Class;
		
		private var ivy:Bitmap;

		private var gameOver:Bitmap;
		
		
		
		public function EndGame()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		
		
		protected function onAdded(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			// Add game over text
			gameOver = new GameOverClass() as Bitmap;
			addChild(gameOver);
			Aligner.alignCenterMiddleToBounds(gameOver,W,H,0,-350);
			
			TweenMax.from(gameOver, 0.5,{alpha:0,y:'-40',ease:Expo.easeOut,onComplete:ShowMessage});
		}
		
		private function ShowMessage():void
		{
			ivy = new IvyMessageClass() as Bitmap;
			
			addChildAt(ivy,0);
			
			Aligner.alignToCenterTopToBounds(ivy,W,0,340);
			TweenMax.from(ivy, 0.5,{alpha:0,y:-ivy.height,ease:Expo.easeOut,onComplete:function():void{dispatchEvent(new GameEvents(GameEvents.GAME_END))}});
		}
	}
}