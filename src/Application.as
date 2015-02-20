package 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.itpointlab.library.Utils;
	
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	
	import isle.susisu.twitter.Twitter;
	import isle.susisu.twitter.TwitterRequest;
	import isle.susisu.twitter.events.TwitterRequestEvent;
	
	import starling.core.Starling;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class Application extends Sprite
	{
		
		[Embed(source="/../assets/NotoSansCJKkr-Bold.otf",fontFamily="noto", fontWeight="bold", mimeType="application/x-font", embedAsCFF="false")]
		protected static const NOTO_BOLD:Class;
		
		[Embed(source="/../assets/bell.mp3")] 
		protected static const DING_SFX:Class;
		private var _dingSfx:Sound;
		
		// You can change hash tag you want
		private const HASH:String = "#GraffitiFlashlight";
		
		public function Application()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			_dingSfx = new DING_SFX();
		}

		/**
		 * The Feathers Button control that we'll be creating.
		 */
		protected var _authButton:Button;
		private var _twitter:Twitter;
		private var _authURL:String;
		private var _timer:Timer;
		private var _response:Object;
		private var _tweets:Vector.<String>;
		private var _lastId:String;
		private var _index:int;
		
		// UI
		private var _cover:Shape;
		private var _circle:Shape;
		private var _labels:Vector.<Label>;
		private var _labelContainer:Sprite;

		protected function addedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

			initUI();
			
			//
			// Change your twitter app key
			//
			_twitter = new Twitter("<CONSYMER_KEY>",
				"<CONSUMER_KEY_SECRET>",
				"<ACCESS_TOKEN>",
				"<ACCESS_TOKEN_SECRET>");
			
			var rtRequest:TwitterRequest = _twitter.oauth_requestToken();
			rtRequest.addEventListener( TwitterRequestEvent.COMPLETE, function(event:TwitterRequestEvent):void{
				_authURL = _twitter.getOAuthAuthorizeURL();
				startGetTweets();
			});
		}
		
		private function initUI():void
		{
			_circle = new Shape;
			_circle.graphics.beginFill(0xFFFFFF);
			_circle.graphics.drawCircle(0, 0, Starling.current.stage.stageHeight * .5 );
			_circle.graphics.endFill();
			_circle.x = Starling.current.stage.stageWidth * .5;
			_circle.y = Starling.current.stage.stageHeight * .5;
			addChild(_circle);
			
			_labelContainer = new Sprite;
			addChild(_labelContainer);
			
			_cover = new Shape;
			_cover.graphics.beginFill(0);
			_cover.graphics.drawRect(0, 0, Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
			_cover.graphics.endFill();
			_cover.visible = false;
			addChild(_cover);
			
			stage.addEventListener(TouchEvent.TOUCH, function(e:TouchEvent):void{
				var touch:Touch = e.getTouch(stage);       
				if( touch && touch.phase == TouchPhase.ENDED ){
					_cover.visible = !_cover.visible;	
				} 
			});
		}
		
		private function startGetTweets():void
		{
			_timer = new Timer(5200);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}
		
		protected function onTimer(event:TimerEvent):void
		{
			getTweets();
		}
		
		private function getTweets():void
		{
			var t:TwitterRequest = _twitter.search_tweets(HASH , null, null, null, null, 5 );
			t.addEventListener(TwitterRequestEvent.COMPLETE, function(e:TwitterRequestEvent):void{
				_response = JSON.parse(t.response);
				trace(">>> get tweets");
				// update tweets
				if(_lastId != _response.statuses[0].id){
					trace(">>> updated tweets");
					_dingSfx.play();
					destroyLabels();
					_tweets = new Vector.<String>;
					_labels = new Vector.<Label>;
					for each(var status:Object in _response.statuses){
						var msg:String = "";
						for each (var s:String in String(status.text).split(HASH)){
							if(s!=HASH) msg += s+" ";
						}
						var txt:String = msg + "\n<font size='96'>" + HASH+" - " + status.user.screen_name+"</font>";
						_tweets.push(txt);
						_labels.push(factoryLabel(txt));
					}
					
					// debug result 
					//Utils.deepTrace( _tweets );
					moveTweets();
					_lastId = _response.statuses[0].id;
				}
			});
			t.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void {
				factoryLabel( e.toString() );
			});
		}
		
		private function moveTweets(index:int = 0):void{
			if(_labels.length == 0) return;
			if(index>_labels.length-1) index = 0;
			
			_index = index;
			var l:Label = _labels[index];
			Utils.deepTrace(l.textRendererProperties);
			var msg:Array = l.text.split("\n");
			var t:int = (l.width==0) ? String(msg[0]).length * 1.15: l.width / 110;
			var tx:int = (l.width==0) ? String(msg[0]).length * 170: l.width * 1.7;
			l.alpha = 1;
			l.x = 0;
			trace(">>> moveTweets() ", l.x, l.y, t, tx);
			TweenLite.to(l, t, {x:tx, ease:Linear.easeNone, onComplete:function():void{
				l.alpha = 0;
				moveTweets(_index+1);
			}});
		}
		
		private function factoryLabel($text:String):Label
		{
			
			var label:Label = new Label;
			label.textRendererFactory = function():ITextRenderer
			{
				var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
				textRenderer.textFormat = new TextFormat( "noto", 128, 0x000000 );
				textRenderer.embedFonts = true;
				textRenderer.isHTML = true;
				return textRenderer;
			}
			label.text = $text;
			label.rotation = 180*0.0174532925;;
			label.x = -80;
			label.y = (Starling.current.stage.stageHeight * .5)+138;
			label.scaleX = 0.99;
			
			_labelContainer.addChild(label);
			return label;
		}
		
		private function destroyLabels():void
		{
			for each(var l:Label in _labels){
				TweenLite.killTweensOf(l);
				if(l.parent) l.parent.removeChild(l);
				l = null;
			}
			_labels = null;
		}
	}
}
