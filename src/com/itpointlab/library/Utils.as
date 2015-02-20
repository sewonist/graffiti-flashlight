/*
VERSION: 1.0
DATE: 2008-08-05 오후 8:55
DESCRIPTION:
각족 유용한 유틸리티 모음 클래스

ARGUMENTS:

EXAMPLES: 
var randomNum:Number = Utils.randomRange(1, 10);

NOTES:
KIM JOON HYEOK

Copyright 2008, dTribe
*/

package com.itpointlab.library {
	//-------------------------------------------------------------------------------------------
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.external.ExternalInterface;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.media.Video;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	//-------------------------------------------------------------------------------------------
	public class Utils {
		
		public static function extractClassName( $tar:Object ):String
		{
			var str:String = String( $tar );
			var ns:uint = str.indexOf(" ") + 1;
			var nl:uint = str.lastIndexOf("]");
			str = str.substring( ns, nl );
			
			return str;
		}
		//stage.displayState = StageDisplayState.FULL_SCREEN;
		//-------------------------------------------------------------------------------------------
		// 난수생성
		//-------------------------------------------------------------------------------------------
		public static function randomRange( $min:Number, $max:Number ):Number {
			return (Math.floor(Math.random() * ($max - $min + 1)) + $min);
		}
		//-------------------------------------------------------------------------------------------
		//  경고팝업
		//-------------------------------------------------------------------------------------------
		public static function msg( $msg:String ):void {
			ExternalInterface.call( "alert", $msg );
		}
		//-------------------------------------------------------------------------------------------
		//  자바스크립트 파라메타 리턴
		//-------------------------------------------------------------------------------------------
		public static function getValueFunc( $func:String, $param:String ):String {
			var url:String = ExternalInterface.call( $func, $param );
			return url
		}
		//-------------------------------------------------------------------------------------------
		//  페이지 링크
		//-------------------------------------------------------------------------------------------
		public static function goURL( $url:String, $tar:String = "_self" ):void
		{
			var req:URLRequest = new URLRequest( $url );
			navigateToURL( req, $tar );
		}
		//-------------------------------------------------------------------------------------------
		//  빈무비클립생성
		//-------------------------------------------------------------------------------------------
		public static function createFunc( $mcName:String, $xNum:Number, $yNum:Number ):MovieClip {
			var mc:MovieClip = new MovieClip();
			mc.name = $mcName;
			mc.x = $xNum;
			mc.y = $yNum;
			
			return mc;
		}
		//-------------------------------------------------------------------------------------------
		//  무비클립 어테치
		//-------------------------------------------------------------------------------------------
		public static function attachMovieClip( $class:MovieClip, $xNum:Number, $yNum:Number ):MovieClip {
			var mc:MovieClip = $class;
			mc.x = $xNum;
			mc.y = $yNum;
			
			return mc;
		}
		//-------------------------------------------------------------------------------------------
		//  외부파일 로더
		//-------------------------------------------------------------------------------------------
		public static function loadFunc( $url:String ):Loader {
			var req:URLRequest = new URLRequest($url);
			var loader:Loader = new Loader();
			loader.load(req);
			//--
			return loader;
		}
		//-------------------------------------------------------------------------------------------
		// 그림자 필터
		//-------------------------------------------------------------------------------------------
		public static function dropShadowFunc( $color:uint, $blurX:int, $blurY:int, $alpha:Number, $distance:int, $angle:Number ):BitmapFilter {
			var Shadow:DropShadowFilter=new DropShadowFilter;
			Shadow.color = $color;
			Shadow.blurX = $blurX;
			Shadow.blurY = $blurY;
			Shadow.alpha = $alpha;
			Shadow.angle = $angle;
			Shadow.distance = $distance;
			Shadow.quality = BitmapFilterQuality.HIGH;
			
			return Shadow;
		}
		//-------------------------------------------------------------------------------------------
		// 배열 섞기
		//-------------------------------------------------------------------------------------------
		public static function Suffle( $arr:Array):* {
			var ar1:Array = new Array();
			var ar2:Array = new Array();
			//
			for (var i:int = 0; i < $arr.length; i++) 
			{
				ar1.push( [ Math.random(), i ] );
			}
			
			ar1.sort();
			
			for (var j:int = 0; j < $arr.length; j++) 
			{
				var row:Number = ar1[j][1];
				ar2[j] = $arr[row];
			}
			return ar2;
		}
		
		//-------------------------------------------------------------------------------------------
		// UTC 타임
		//-------------------------------------------------------------------------------------------
		public static function getDate(utc_time:Number, isDayOn:Boolean=true, isTime:Boolean=false, dayDigit:int=3, divChar:String='.'):String
		{
			var date:Date=new Date(utc_time);
			var dayOfWeek:Array = new Array("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday");
			var newDate:String=date.getFullYear()+divChar+Utils.addZero(String(date.getMonth()+1))+divChar+Utils.addZero(date.getDate().toString());
			if(isDayOn) newDate=newDate+divChar+String(dayOfWeek[date.getDay()]).substring(0,dayDigit);
			if(isTime) newDate=newDate+divChar+addZero(String(date.getHours()))+":"+addZero(String(date.getMinutes()));
			return newDate;
		}
		
		//-------------------------------------------------------------------------------------------
		// 0으로 칸수 채우기
		//-------------------------------------------------------------------------------------------
		public static function addZero($num:String, $digit:int = 2):String
		{
			var num:String = "";
			var lenth:int = int($num.length);
			//
			for( var i:int = 0; i<$digit; i++ )
				if( i>=lenth ) num+="0";
			num+=$num;
			//
			return num as String;
		}
		//-------------------------------------------------------------------------------------------
		// 무비클립 그리기
		//-------------------------------------------------------------------------------------------
		public static function drawFunc( $target:MovieClip, $xNum:Number, $yNum:Number, $wNum:Number, $hNum:Number ):Bitmap {
			//--
			var bitData:BitmapData = new BitmapData( $wNum, $hNum, true, 0x000000FF );
			bitData.draw( $target );
			var bitImg:Bitmap = new Bitmap( bitData );
			bitImg.smoothing = true;
			bitImg.x = $xNum;
			bitImg.y = $yNum;
			
			return bitImg;
		}
		//-------------------------------------------------------------------------------------------
		// 사각형 그리기
		//-------------------------------------------------------------------------------------------
		public static function doRectFunc( $color:int, $xNum:Number, $yNum:Number, $wNum:int, $hNum:int ):Shape {
			var shapeRect:Shape = new Shape();
			shapeRect.graphics.beginFill( $color );
			shapeRect.graphics.drawRect( $xNum, $yNum, $wNum, $hNum );
			shapeRect.graphics.endFill();
			
			return shapeRect;
		}
		//-------------------------------------------------------------------------------------------
		// 앞에 0붙이기
		//-------------------------------------------------------------------------------------------
		private function addZero( $strNumber:String, $numAdd:int=2 ):String
		{
			var strAdd	:String = "";
			var numLen	:int 	= int( $strNumber.length )
			
			for ( var i:int = 0; i < $numAdd; i++ )
			{
				if ( i >= numLen ) strAdd += "0";
			}
			
			strAdd += $strNumber;	
			
			return strAdd;
		}
		
		//-------------------------------------------------------------------------------------------
		// 처음에서 끝으로 / 끝에서 처음으로.. 숫자 롤링
		//-------------------------------------------------------------------------------------------
		public static function rollingNumber( $now:int, $min:int, $max:int ):int
		{	
			if ($now < $min) {
				$now = ($max + 1) - ($min - $now);
				if ($now < $min) {
					$now = rollingNumber( $now, $min, $max );
				}
			} else if ($now > $max) {
				$now = ($min - 1) - ($max- $now);
				if ($now > $max) {
					$now = rollingNumber( $now, $min, $max );
				}
			} else {
				$now = $now;
			}
			
			return $now;
		}
		//-------------------------------------------------------------------------------------------
		// 오른쪽 마우스버튼 메뉴 추가
		//-------------------------------------------------------------------------------------------
		public static function contextFunc( $path:MovieClip, $str:String ):void
		{
			var ctMenu:ContextMenu = new ContextMenu();
			ctMenu.hideBuiltInItems();
			
			var item:ContextMenuItem = new ContextMenuItem( $str );
			ctMenu.customItems.push( item );
			item.enabled = false;
			
			MovieClip($path).contextMenu = ctMenu;
		}
		//-------------------------------------------------------------------------------------------
		public static function arrayMin( $num_array:Array ):Number {
			if ($num_array.length == 0) {
				return Number.NaN;
			}
			$num_array.sort(Array.NUMERIC | Array.DESCENDING);
			var min:Number=Number($num_array.pop());
			return min;
		}
		//-------------------------------------------------------------------------------------------
		public static function arrayMax( $num_array:Array ):Number {
			if ($num_array.length == 0) {
				return undefined;
			}
			$num_array.sort(Array.NUMERIC);
			var max:Number=Number($num_array.pop());
			return max;
		}
		
		//-------------------------------------------------------------------------------------------
		//
		// href 는 url: , javascript: 에 맞는 것을 실행
		//
		//-------------------------------------------------------------------------------------------
		public static function href(url:String, target:String):void
		{
			if ( url.split("javascript:").length > 1) {
				gotoScript(url, target);
			} else {
				gotoURL(url, target);
			}
		}
		public static function gotoURL($url:String, $target:String):void
		{
			var arr:Array = $url.split("url:");
			if ( arr.length > 1 ) {
				$url = arr[1];
			}
			
			//navigateToURL(new URLRequest($url), $target);
			
			var req:URLRequest= new URLRequest( $url );
			if (! ExternalInterface.available) {
				navigateToURL(req, $target);
			} else {
				var strUserAgent:String=String(ExternalInterface.call("function() {return navigator.userAgent;}")).toLowerCase();
				if (strUserAgent.indexOf("firefox") != -1 || (strUserAgent.indexOf("msie") != -1 && uint(strUserAgent.substr(strUserAgent.indexOf("msie") + 5, 3)) >= 7)) {
					ExternalInterface.call("window.open", req.url, $target);
				} else {
					navigateToURL(req, $target);
				}
			}
		}
		
		
		public static function gotoScript($func:String, $args:String):void
		{
			var arr:Array = $func.split("javascript:");
			if ( arr.length > 1 ) {
				$func = arr[1];
			}
			var argsArr:Array = $args.split(",");
			
			ExternalInterface.call($func, argsArr[0], argsArr[1], argsArr[2]);
		}
		
		public static function whitespace($str:String,$replace:String=''):String
		{
			var pattern:RegExp=/^\s*|\s*$/gim;
			$str = $str.replace(pattern,$replace);
			return $str;
		}
		
		/**
		 * URL에 있는 인자값 분리하여 오브젝트로 리턴
		 */
		public static function getParamsFromURL($url:String):Object
		{
			var obj:Object={};
			var params:Array=$url.substr($url.indexOf('?')+1).split('&');
			for(var i:uint=0;i<params.length;i++)
			{
				var param:Array=(params[i] as String).split('=');
				obj[param[0]]=param[1];
			}
			
			return obj;
		}
		
		/**
		 * 지정한 String이 한글인지 판별해줍니다.
		 */
		public static function isKorean(str:String):Boolean
		{
			for(var i:Number=0; i<str.length; i++)
			{
				if(str.charCodeAt(i) < 44032 || str.charCodeAt(i) > 56023) 
				{
					//trace(str.substr(i,1), str.charCodeAt(i));
				}
				else
				{
					if(str.charCodeAt(i)!=32 || str.charCodeAt(i)!=46)
					{
						return true;
					}
				}
				//					
			}
			//
			return false;
		}
		
		//-------------------------------------------------------------------------------------------
		//
		//	전체 url 에서 base 부분만 추출
		//
		//-------------------------------------------------------------------------------------------
		public static function getBaseURL( url:String ):String
		{
			var baseUrl:String = url.substring(0, url.lastIndexOf('/') + 1);  
			return baseUrl; 
		}
		
		public static function getLastCharInString( $s:String ):String
		{
			return $s.substr( $s.length-1, $s.length );
		}
		
		public static function safeDestory( $target:DisplayObject ):void
		{
			if( $target ){
				if( $target.parent ) $target.parent.removeChild( $target );
				$target = null;
			}
		}
		public static function smoothVideo( $target:DisplayObjectContainer ):void
		{
			for (var i:uint = 0; i < $target.numChildren; i++){
				if( $target.getChildAt( i ) is Video ){
					( $target.getChildAt( i ) as Video ).deblocking = 3;
					( $target.getChildAt( i ) as Video ).smoothing = true;	
				}
			}
		}
		public static function deepTrace( obj : *, level : int = 0 ) : void{
			var tabs : String = "";
			for ( var i : int = 0 ; i < level ; i++, tabs += "\t" );
			
			for ( var prop : String in obj ){
				trace( tabs + "[" + prop + "] -> " + obj[ prop ] );
				deepTrace( obj[ prop ], level + 1 );
			}
		}
	}
	
}
