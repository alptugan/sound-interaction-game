// Generated with http://projects.stroep.nl/ValueObjectGenerator/ 
package com.filika.events
{
	import flash.events.Event;

	/**
	 * @author filika
	*/
	public class EnergyBarEvent extends Event
	{
		/** 
		 * 
		 */
		public static const ENERGY_FINISHED:String = "EnergyBarEvent.Energy_finished";

		
		public function EnergyBarEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false):void 
		{ 
			super(type, bubbles, cancelable);
			
		}

	

		override public function clone():Event 
		{ 
			return new EnergyBarEvent(this.type,  this.bubbles, this.cancelable);
		} 

		override public function toString():String 
		{ 
			return formatToString("EnergyBarEvent", "type",  "bubbles", "cancelable", "eventPhase"); 
		}
	}
}
