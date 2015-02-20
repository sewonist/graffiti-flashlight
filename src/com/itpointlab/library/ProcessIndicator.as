package com.itpointlab.library
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	import starling.utils.rad2deg;
	
	public class ProcessIndicator extends DisplayObjectContainer
	{
		private var _spinnerSkin:Image;
		
		private var timer:Timer;
		private var slices:int;
		private var radius:int;
		private var _image:Image;
		
		public function ProcessIndicator(slices:int = 12, radius:int = 6)
		{
			super();
			this.slices = slices;
			this.radius = radius;
			
			spinnerSkin = makeSpinner();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			timer = new Timer(1000/30);
			timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
			timer.start();
		}
		
		private function onRemovedFromStage(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			timer.reset();
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
			timer = null;
		}
		
		private function onTimer(event:TimerEvent):void
		{
			spinnerSkin.rotation = deg2rad(( rad2deg(spinnerSkin.rotation) + (360 / slices)) % 360);
		}
		
		private function makeSpinner():Image
		{
			var i:int = slices;
			var degrees:int = 360 / slices;
			var slider:flash.display.Sprite = new flash.display.Sprite;
			while (i--)
			{
				var slice:Shape = getSlice();
				slice.alpha = Math.max(0.2, 1 - (0.1 * i));
				var radianAngle:Number = (degrees * i) * Math.PI / 180;
				slice.rotation = -degrees * i;
				slice.x = (Math.sin(radianAngle) * radius)+radius*2;
				slice.y = (Math.cos(radianAngle) * radius)+radius*2;
				
				slider.addChild(slice);
			}
			
			var bitamp:BitmapData = new BitmapData(slider.width, slider.height, true, 0);
			bitamp.draw(slider);
			
			var texture:Texture = Texture.fromBitmapData(bitamp, false, false);
			var spinner:Image = new Image(texture);
			spinner.pivotX = spinner.width >> 1;
			spinner.pivotY = spinner.height >> 1;
			
			return spinner; 
		}
		
		private function getSlice():Shape
		{
			var slice:Shape = new Shape();
			slice.graphics.beginFill(0x222222);
			slice.graphics.drawRoundRect(-1, 0, 2, radius, radius*2, radius*2);
			slice.graphics.endFill();
			
			return slice;
		}
		
		//=====================================================================
		//
		// getter & setter
		//
		//=====================================================================
		
		public function get spinnerSkin():Image
		{
			return _spinnerSkin;
		}
		
		public function set spinnerSkin(value:Image):void
		{
			if(_spinnerSkin == value)
			{
				return;
			}
			
			if(_spinnerSkin)
			{
				removeChild(_spinnerSkin);
			}
			
			_spinnerSkin = value;
			
			
			if(this._spinnerSkin && this._spinnerSkin.parent != this)
			{
				_spinnerSkin.visible = true;
				_spinnerSkin.touchable = false;
				addChild(_spinnerSkin);
			}
		}
		
		
	}
}