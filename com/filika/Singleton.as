package com.filika {
	import flash.media.Microphone;
	
	public class Singleton {
		
		private static var instance:Singleton;      //This will be the unique instance created by the class
		private static var isOkayToCreate:Boolean=false;    //This variable will help us to determine whether the instance can be created
		
		public var micLevel:Number = 50;
		public var bolHit:Boolean = false;
		// Microphone
		public var myMic:Microphone;
		
		//Score
		public var Score:String = "0";
		
		// Collecting Based Game Side
		public var timeLimit:Number = 0.3;
		
		// Global Mic boostMultiplier
		public var myMicMultiplier : Number = 8;
		
		
		// Character default height
		public var charDefH:int = 250;
		
		// Character default height
		public var enemyDefH:int = 100;
		
		public function Singleton() {
			//If we can't create an instance, throw an error so no instance is created
			if(!isOkayToCreate) throw new Error(this + " is a Singleton. Access using getInstance()");
		}
		
		//With this method we will create and access the instance of the method
		public static function getInstance():Singleton
		{
			//If there's no instance, create it
			if (!instance)
			{
				//Allow the creation of the instance, and after it is created, stop any more from being created
				isOkayToCreate = true;
				instance = new Singleton();
				isOkayToCreate = false;
				trace("Singleton instance created!");
			}
			return instance;
		}
	}
}