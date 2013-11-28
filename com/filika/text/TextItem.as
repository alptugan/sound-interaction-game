package com.filika.text
{
	import caurina.transitions.*;
	import caurina.transitions.properties.*;
	
	import com.alptugan.text.ATextSingleLine;
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flupie.textanim.*;
	
	import org.casalib.display.CasaSprite;
	
	public class TextItem extends CasaSprite
	{
		private var str:String;
		private var _fm:TextFormat;
		public var _tf:TextField;
			
		private var i:int = 0;
		
		private var charLen:int;

		private var lastVal:int;

		private var lk:int;
		public var floor : int =0;
		private var isSet:Boolean = false;
		
		public function TextItem(str:String)
		{
			this.str = str;
			
			ColorShortcuts.init();
			DisplayShortcuts.init();
			FilterShortcuts.init();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			
			//Manager.getInstance().len = Manager.getInstance().len + 1;
			
			_fm = new TextFormat(FontParamVO.fontName, FontParamVO.fontSize, FontParamVO.fontColor);
			
			_tf = new TextField();
			_tf.embedFonts = true;
			_tf.autoSize = "left";
			_tf.multiline         = false;
			_tf.condenseWhite     = true;
			_tf.wordWrap          = false;
			_tf.selectable        = false;
			
			_tf.defaultTextFormat = _fm;
			_tf.height = 100;
			
		
			_tf.text = this.str;
			
			addChild(_tf);
			
			charLen = _tf.text.length;
			
			var myAnim:TextAnim = new TextAnim(_tf);
			myAnim.mode = TextAnimMode.CENTER_EDGES;
			myAnim.blocksVisible = false;
			myAnim.effects = myEffect;
			myAnim.start();
		}
		
		private function myEffect(block:TextAnimBlock):void 
		{
			block.scaleX = block.scaleY = 0;
			Tweener.addTween(block, {delay:0,scaleX:1, scaleY:1, time:1, transition:"easeoutelastic"/*,onComplete:effInComplete,onCompleteParams:[block]*/});
		}
		
		private function effInComplete(b:TextAnimBlock):void
		{
		
			//Tweener.addTween(block, {scaleX:0, scaleY:0, time:1, transition:"easeoutelastic",onComplete:effOutComplete,onCompleteParams:[block]});
			Tweener.addTween(b, {_Blur_blurY:20, _Blur_blurX:20, time:1, transition:"easeinoutquart", delay:2});
			Tweener.addTween(b, {y:-(10 - Math.random()*20), rotation:Math.random()*30, time:1, transition:"easeinback", delay:2});
			Tweener.addTween(b, {alpha:0., time:.5, transition:"easeoutquart", delay:2.7,onComplete:effOutComplete,onCompleteParams:[b]});
		}
		
		private function effOutComplete(block:TextAnimBlock):void
		{
			
			//trace(this.destroyed);
			block.dispose();
			removeAllChildrenAndDestroy(true,true);
			//trace("i ler : ",i);
			if(isSet != true)
			{
				isSet = true;
			}
			
		}
	}
}