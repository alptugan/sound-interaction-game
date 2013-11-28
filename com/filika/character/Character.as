package com.filika.character
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.casalib.display.CasaSprite;
	
	
	public class Character extends CasaSprite
	{
		[Embed(source="assets/TINKERBELL_size.png")] 
		public static const image:Class;
		
		private var myChar:Bitmap;
		
		// Vars
		private var particleArray:Array;
		
		// Settings
		private var particleMaxSpeed:Number = 1;
		private var particleFadeSpeed:Number = .025;
		private var particleTotal:Number = 3;
		private var particleRange:Number = 15;
		private var particleCurrentAmount:Number = 0;
		private var mouseTrailer:MouseTrailer;
		
		
		
		public function Character()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		
		
		protected function onAdded(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			myChar = new image();
			this.addChild(myChar);
			
			mouseTrailer = new MouseTrailer();
			addChild(mouseTrailer);
			mouseTrailer.init();
			mouseTrailer.x = 180;
			mouseTrailer.y = -myChar.height-100;
		}
		
	
		//========================================================================================================
		// PUBLIC METHODS
		//========================================================================================================
		/**
		 * createParticle(target X position, target Y position)
		 */
		public function createParticle(targetX:Number, targetY:Number):void
		{
			mouseTrailer.createParticle(targetX,targetY);
		}
		public function updateParticle():void
		{
			mouseTrailer.updateParticle();
		}
		
		
	}
}