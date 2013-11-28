package com.filika.ulker
{
	import com.alptugan.drawing.shape.RectShape;
	import com.alptugan.drawing.style.FillStyle;
	import com.alptugan.globals.Root;
	import com.alptugan.layout.Aligner;
	import com.alptugan.text.ATextSingleLine;
	import com.filika.Singleton;
	import com.filika.events.GameEvents;
	import com.filika.text.FontParamVO;
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Expo;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	import org.casalib.display.CasaSprite;
	
	public class EndGame extends Root
	{
		
		[Embed(source="assets/tatu/ciglikh.png")]
		protected var GameOverClass:Class;
		
		
		[Embed(source="assets/tatu/yeter.png")]
		protected var IvyMessageClass:Class;
		
		
		private var ivy:Bitmap;

		private var gameOver:Bitmap;
		
		private var scoreBg:RectShape;
		private var score:ATextSingleLine;
		private var scoreTxt:ATextSingleLine;
		
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
			//gameOver.x = stage.stageWidth - gameOver.width >> 1;
			//gameOver.y = -stage.stageHeight;
			gameOver.alpha = 0;
			
			
			ivy = new IvyMessageClass() as Bitmap;
			addChildAt(ivy,0);
			//ivy.x = stage.stageWidth - ivy.width >> 1;
			//ivy.y = stage.stageHeight;
			ivy.alpha = 0;

			initScore();
			
		}
		
		private function initScore():void
		{
			scoreBg = new RectShape(new Rectangle(0,0,stage.stageWidth,stage.stageHeight),new FillStyle(0xcccccc));
			addChild(scoreBg);
			
			TweenMax.from(scoreBg,1,{alpha:0,ease:Expo.easeOut,onComplete:showScore});
			
			
		}
		
		private function showScore():void
		{
			scoreTxt = new ATextSingleLine("SKOR",FontParamVO.fontName,0x333333,80);
			addChild(scoreTxt);
			//scoreTxt.filters = [new GlowFilter(0xff0000,0.6,20,20)];
			Aligner.alignCenterMiddleToBounds(scoreTxt,stage.stageWidth,stage.stageHeight,0,-180);
			TweenMax.from(scoreTxt,1,{alpha:0,ease:Expo.easeOut});
			
			var tx :String = Singleton.getInstance().Score;
			if(int(tx) < int(10))
				tx = tx.charAt(1);
		
				
			score = new ATextSingleLine(tx,FontParamVO.fontName,0x333333,90);
			addChild(score);
			score.setTextPos(-score.width*0.5,-score.height*0.5);
			//score.filters = [new GlowFilter(FontParamVO.fontColor,0.5,15,15)];
			score.scaleX = score.scaleY = 2;
			Aligner.alignCenterMiddleToBounds(score,stage.stageWidth,stage.stageHeight,score.width+4,scoreTxt.height+score.height*0.5+100);
			
			TweenMax.from(score,0.8,{delay:0.5,alpha:0,scaleX:0,scaleY:0,ease:Elastic.easeInOut,onComplete:showGameOverTitle()});
		}
		
		private function showGameOverTitle():void
		{
			TweenMax.to(score,1,{delay:5,y:"100",alpha:0,scaleX:0,scaleY:0,ease:Elastic.easeInOut});
			TweenMax.to(scoreTxt,1,{delay:5.5,alpha:0,y:"-100",ease:Expo.easeOut});
			TweenMax.to(scoreBg,0.5,{delay:7,alpha:0,ease:Expo.easeOut});
			
			gameOver.alpha = 1;
			TweenMax.from(gameOver, 0.5,{delay:7.5,alpha:0,y:'-40',ease:Expo.easeOut,onComplete:ShowMessage});
		}
		
		private function ShowMessage():void
		{
			ivy.alpha = 1;
			TweenMax.from(ivy, 0.5,{alpha:0,y:-ivy.height,ease:Expo.easeOut,onComplete:function():void{
				Singleton.getInstance().Score = "00";
				var ev :GameEvents = new GameEvents(GameEvents.GAME_END);
				dispatchEvent(ev);
			}});
		}
	}
}