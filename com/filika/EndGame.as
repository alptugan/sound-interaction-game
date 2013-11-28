package com.filika
{
	import com.alptugan.globals.Root;
	import com.alptugan.layout.Aligner;
	import com.filika.events.GameEvents;
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Expo;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import org.casalib.display.CasaSprite;
	
	public class EndGame extends Root
	{
		
		[Embed(source="assets/end/fantorya-oyun-bitti.png")]
		protected var GameOverClass:Class;
		
		
		[Embed(source="assets/end/fantorya-ciglik.png")]
		protected var IvyMessageClass:Class;
		
		[Embed(source="assets/end/cfantor.png")]
		protected var FantorClass:Class;
		
		[Embed(source="assets/end/crobot.png")]
		protected var RobotClass:Class;
		
		[Embed(source="assets/end/cpurple.png")]
		protected var PurpleClass:Class;
		
		[Embed(source="assets/end/cufo.png")]
		protected var UfoClass:Class;
		
		[Embed(source="assets/end/crocket.png")]
		protected var RocketClass:Class;
		
		[Embed(source="assets/end/ccat.png")]
		protected var CatClass:Class;
		
		[Embed(source="assets/end/cyellow.png")]
		protected var YellowClass:Class;
		
		[Embed(source="assets/end/cgreen.png")]
		protected var GreenClass:Class;
		
		[Embed(source="assets/end/castro.png")]
		protected var AstroClass:Class;
		
		[Embed(source="assets/end/title.png")]
		protected var TitleClass:Class;
		
		
		
		private var fantor:Bitmap;
		private var robot:Bitmap;
		private var purple:Bitmap;
		private var ufo:Bitmap;
		private var rocket:Bitmap;
		private var cat:Bitmap;
		private var yellow:Bitmap;
		private var green:Bitmap;
		private var astro:Bitmap;
		private var title:Bitmap;	
		
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
			gameOver.x = 190;
			gameOver.y = 43;
			gameOver.alpha = 0;
			
			
			ivy = new IvyMessageClass() as Bitmap;
			addChildAt(ivy,0);
			ivy.x = 41;
			ivy.y = 194;
			ivy.alpha = 0;
			
			
			var del:Number = 0.1;
			fantor = new FantorClass() as Bitmap;
			addChild(fantor);
			fantor.x = 275;
			fantor.y = 354;
			TweenMax.from(fantor, 0.5,{alpha:0,y:'-40',ease:Expo.easeOut});
			
			robot = new RobotClass() as Bitmap;
			addChild(robot);
			robot.x = 342;
			robot.y = 530;
			TweenMax.from(robot, 0.5,{delay:del,alpha:0,y:-100,ease:Expo.easeOut});
			
			purple = new PurpleClass() as Bitmap;
			addChild(purple);
			purple.x = 282;
			purple.y = 541;
			TweenMax.from(purple, 0.5,{delay:del*2,alpha:0,y:-100,ease:Expo.easeOut});
			
			ufo = new UfoClass() as Bitmap;
			addChild(ufo);
			ufo.x = 303;
			ufo.y = 466;
			TweenMax.from(ufo, 0.5,{delay:del*3,alpha:0,y:-100,ease:Expo.easeOut});
			
			cat = new CatClass() as Bitmap;
			addChild(cat);
			cat.x = 444;
			cat.y = 323;
			TweenMax.from(cat, 0.5,{delay:del*4,alpha:0,y:-100,ease:Expo.easeOut});
			
			yellow = new YellowClass() as Bitmap;
			addChild(yellow);
			yellow.x = 483;
			yellow.y = 322;
			TweenMax.from(yellow, 0.5,{delay:del*5,alpha:0,y:-100,ease:Expo.easeOut});
			
			green = new GreenClass() as Bitmap;
			addChild(green);
			green.x = 532;
			green.y = 319;
			TweenMax.from(green, 0.5,{delay:del*6,alpha:0,y:-100,ease:Expo.easeOut});
			
			astro = new AstroClass() as Bitmap;
			addChild(astro);
			astro.x = 636;
			astro.y = 391;
			TweenMax.from(astro, 0.5,{delay:del*7,alpha:0,y:-100,ease:Expo.easeOut});
			
			title = new TitleClass() as Bitmap;
			addChild(title);
			title.x = 400;
			title.y = 552;
			TweenMax.from(title, 1,{delay:del*10,alpha:0,scaleX:0,scaleY:0,y:900,ease:Elastic.easeOut,onComplete:showGameOverTitle});
			
			
			
		}
		
		private function showGameOverTitle():void
		{
			
			gameOver.alpha = 1;
			TweenMax.from(gameOver, 0.5,{alpha:0,y:'-40',ease:Expo.easeOut,onComplete:ShowMessage});
		}
		
		private function ShowMessage():void
		{
			ivy.alpha = 1;
			TweenMax.from(ivy, 0.5,{alpha:0,y:-ivy.height,ease:Expo.easeOut,onComplete:function():void{
				dispatchEvent(new GameEvents(GameEvents.GAME_END))
			}});
		}
	}
}