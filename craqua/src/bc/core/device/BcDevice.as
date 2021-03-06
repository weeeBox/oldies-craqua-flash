package bc.core.device 
{
	import bc.core.audio.BcAudio;
	import bc.core.audio.BcMusic;
	import bc.core.data.BcData;
	import bc.core.device.messages.BcKeyboardMessage;
	import bc.core.device.messages.BcMouseMessage;
	import bc.core.motion.BcEasing;
	import bc.core.motion.tweens.BcTweenFactory;
	import bc.core.ui.UI;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuBuiltInItems;
	import flash.ui.ContextMenuItem;
	import flash.utils.Dictionary;

	/**
	 * @author Elias Ku
	 */
	public final class BcDevice 
	{
		private static const DISPLAY_WIDTH:uint = 640;
		private static const DISPLAY_HEIGHT:uint = 480;
		private static const BACKGROUND_COLOR:uint = 0x000000;
		private static const FRAME_RATE:uint = 60;
		public static const DEBUG:Boolean = true;
		
		public static var impl:BcDevice;

		public static function initialize(stage:Stage):void
		{
			if(impl != null || stage == null)
			{
				throw new Error("BcDevice: initialization error");
			}
			else
			{
				new BcDevice(new BcDeviceSingleton(), stage);
			}
		}
		
		public static function get display():DisplayObjectContainer
		{
			return impl.display;
		}
		
		public static function get stage():Stage
		{
			return impl.stage;
		}
		
		
		public static function get width():uint
		{
			return DISPLAY_WIDTH;
		}
		
		public static function get height():uint
		{
			return DISPLAY_HEIGHT;
		}
			
		public static function get fps():int
		{
			return impl.timer.fps;
		}
		
		public static function get application():BcIApplication
		{
			return impl.application;
		}
		
		public static function set application(value:BcIApplication):void
		{
			impl.application = value;
		}
		
		public static function get quality():uint
		{
			return impl.quality;
		}
		
		public static function set quality(value:uint):void
		{
			impl.quality = value;
		}
		
		public static function get fullscreen():Boolean
		{
			return impl.fullscreen;
		}
		
		public static function set fullscreen(value:Boolean):void
		{
			impl.fullscreen = value;
		}
		
//#if PLATFORM_FLASH
//		public static function get contextMenu():ContextMenu
//		{
//			return impl.display.contextMenu;
//		}
//		
//		public static function set contextMenu(value:ContextMenu):void
//		{
//			impl.contextMenu = value;
//		}
//#endif
		
		// device
		private var timer:BcTimer = new BcTimer();
		private var display:Sprite = new Sprite();
		private var displaySize:Rectangle = new Rectangle();
		
		// messages
		private var mouseMessage:BcMouseMessage = new BcMouseMessage();
		private var keyboardMessage:BcKeyboardMessage = new BcKeyboardMessage();
		private var keysState:Dictionary = new Dictionary();
		
		// Stage, главный, глобальный
		private var stage:Stage;
		
		private var application:BcIApplication;
		
//#if PLATFORM_FLASH
//		private var defaultContextMenu:ContextMenu;
//#endif
	
		public function BcDevice(singleton:BcDeviceSingleton, stage:Stage)
		{
			if(singleton != null)// && cd(DEBUG, stage, ["jeux-gratuits.com"]))
			{
				impl = this;
				
				this.stage = stage;
//#if PLATFORM_FLASH
//				createDefaultContextMenu();
//#endif
				initialize();
				
				BcAsset.initialize();
				BcAudio.initialize();
				BcData.initialize();
				BcEasing.initialize();
			}
		}
		
//#if PLATFORM_FLASH
//		private function createDefaultContextMenu():void
//		{
//			var cm:ContextMenu = new ContextMenu();
//			var bii:ContextMenuBuiltInItems = cm.builtInItems;
//			var items:Array = new Array();
//			
//			bii.loop = false;
//			bii.forwardAndBack = false;
//			bii.play = false;
//			bii.print = false;
//			bii.rewind = false;
//			bii.save = false;
//			bii.zoom = false;
//			var cmi:ContextMenuItem;
//			cmi = new ContextMenuItem("eliasku (c) 2009", true, true, true);
//			items.push(cmi);
//			cm.customItems = items;
//			 
//			defaultContextMenu = cm;
//		}
//#endif
		
		private function initialize():void
		{
			displaySize.width = stage.stageWidth = BcDevice.DISPLAY_WIDTH;
			displaySize.height = stage.stageHeight = BcDevice.DISPLAY_HEIGHT;
	
			stage.frameRate = Number(BcDevice.FRAME_RATE);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.fullScreenSourceRect = displaySize;
			stage.stageFocusRect = false;
			stage.tabChildren = false;
			stage.addEventListener(Event.ENTER_FRAME, onFrame);
			
			// События мыши
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			
			// События клавиатуры
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			// деактивация окна
			stage.addEventListener(Event.DEACTIVATE, onDeactivate);
			stage.addEventListener(Event.ACTIVATE, onActivate);
			
			// Главный рисовальщик
			display.scrollRect = displaySize;
			display.opaqueBackground = BcDevice.BACKGROUND_COLOR;
				
//			TODO: preprocessor
//			display.contextMenu = defaultContextMenu;
//			display.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, onSelectContextMenu);
			
			stage.addChildAt(display, 0);
		}
		
		private function get quality():uint
		{
			var stageQuality:String = stage.quality;
			var quality:uint = 2;
			if(stageQuality == "LOW")
				quality = 0;
			else if(stageQuality == "MEDIUM")
				quality = 1;
			
			return quality;
		}
		
		private function set quality(value:uint):void
		{
			switch(value)
			{
				case 0:
					stage.quality = StageQuality.LOW;
					break;
				case 1:
					stage.quality = StageQuality.MEDIUM;
					break;
				case 2:
					stage.quality = StageQuality.HIGH;
					break;
			}
		}
		
		private function get fullscreen():Boolean
		{
			return (stage.displayState == StageDisplayState.FULL_SCREEN);
		}
		
		private function set fullscreen(value:Boolean):void
		{
			if(value)
				stage.displayState = StageDisplayState.FULL_SCREEN;
			else
				stage.displayState = StageDisplayState.NORMAL;
		}
				
//#if PLATFORM_FLASH
//		private function set contextMenu(value:ContextMenu):void
//		{
//			display.contextMenu.removeEventListener(ContextMenuEvent.MENU_SELECT, onSelectContextMenu);
//			
//			if(value != null)
//			{
//				display.contextMenu = value;
//			}
//			else
//			{
//				display.contextMenu = defaultContextMenu;
//			}
//			
//			display.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, onSelectContextMenu);
//		}
//#endif
	
		public static function get mouseX():Number {return impl.mouseX;}
		public static function get mouseY():Number {return impl.mouseY;}
		public static function get mousePushed():Boolean {return impl.mousePushed;}

		// Позиция мыши на Stage объекте
		private var mouseX:Number = 0;
		private var mouseY:Number = 0;
	
		// Состояние кнопки
		private var mousePushed:Boolean;
		
		// Курсор вне области stage
		private var mouseLeaved:Boolean = true;
	
		// Обновляется кадр
		private function onFrame(event:Event):void
		{
			const dt:Number = timer.update();
			
			if(application != null && !BcAsset.busy)
			{
				application.update(dt);
			}
			
			BcMusic.update(dt);
			UI.update(dt);
		}
		
//#if PLATFORM_FLASH
//		private function onSelectContextMenu(event:ContextMenuEvent):void
//		{
//			if(application != null)
//			{
//				application.contextMenu();
//			}
//		}
//#endif
		
		// активация/деактивация окна
		private function onDeactivate(event:Event):void
		{
			if(application != null)
			{
				application.activate(false);
			}
		}
		
		private function onActivate(event:Event):void
		{
			if(application != null)
			{
				application.activate(true);
			}
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			mouseX = event.stageX;
			mouseY = event.stageY;
					
			if(mouseLeaved)
			{
				mouseLeaved = false;
			}
			
			mouseMessage.processEvent(BcMouseMessage.MOUSE_MOVE, event);
			
			if(application != null)
			{
				application.mouseMessage(mouseMessage);
			}
			
			UI.mouseMessage(mouseMessage);
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			mousePushed = true;
			
			if(mouseLeaved)
			{
				onMouseMove(event);
			}
			
			mouseMessage.processEvent(BcMouseMessage.MOUSE_DOWN, event);
				
			if(application != null)
			{
				application.mouseMessage(mouseMessage);
			}
			
			UI.mouseMessage(mouseMessage);
		}
	
		private function onMouseUp(event:MouseEvent):void
		{
			mousePushed = false;
			mouseMessage.processEvent(BcMouseMessage.MOUSE_UP, event);
			
			if(application != null)
			{
				application.mouseMessage(mouseMessage);
			}
			
			UI.mouseMessage(mouseMessage);
		}
	
		private function onMouseLeave(event:Event):void
		{
			mouseLeaved = true;
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			const code:uint = event.keyCode;
			const obj:Object = keysState[code];
			const repeated:Boolean = (obj!=null && obj==true);
			
			if(!repeated)
			{
				keysState[code] = true;
			}
			
			keyboardMessage.processEvent(BcKeyboardMessage.KEY_DOWN, repeated, event);
		
			if(application != null)
			{
				application.keyboardMessage(keyboardMessage);
			}
			
			UI.keyboardMessage(keyboardMessage);
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			const code:uint = event.keyCode;
					
			keysState[code] = false;
			keyboardMessage.processEvent(BcKeyboardMessage.KEY_UP, false, event);
			
			if(application != null)
			{
				application.keyboardMessage(keyboardMessage);
			}
			
			UI.keyboardMessage(keyboardMessage);
		}
			
	}
}

import flash.display.Stage;
import flash.utils.getTimer;

internal final class BcDeviceSingleton 
{
}

/**
 * Встроенный таймер. Следит за таймингом между кадрами и подсчитывает FPS. 
 */
internal final class BcTimer
{
	// Время с предыдущего кадра в секундах
	public var dt:Number = 0.001;
	
	// Кадров в секунду
	public var fps:int;
	
	// Абсолютное значение времени с запуска флешки
	private var last:int;
	
	// Счётчик кадров
	private var frames:int;
	
	// Счёткик обновления fps
	private var fpsLastMeas:int; 
	
	public function BcTimer()
	{
		fpsLastMeas = last = getTimer();
	}
	
	public function update():Number
	{
		const now:int = getTimer();
		const ms:int = now - last;
		
		last = now;
		dt = ms*0.001;
		if ( dt > 0.1 )
		{
			dt = 0.1;
		}
		
		++frames;
		if ( ( last - fpsLastMeas ) > 1000 )
		{
			fpsLastMeas = last;
			fps = frames;
			frames = 0;
		}
		
		return dt;
	}
}

internal function cd(o:Boolean, s:Stage, a:Array):Boolean
{
	var allowed:Boolean = false;
	var url:String = s.loaderInfo.url;
	var urlStart:int = url.indexOf("://")+3;
	var urlEnd:int = url.indexOf("/", urlStart);
	var domain:String = url.substring(urlStart, urlEnd);
	var lastDot:int = domain.lastIndexOf(".")-1;
	var domEnd:int = domain.lastIndexOf(".", lastDot)+1;
			
	domain = domain.substring(domEnd, domain.length);
	
	for each(var x:String in a)
		if(x==domain)
			allowed = true;
			
	if(!allowed && o)
		allowed = (url.substr(0, 4)=="file");
	
	return allowed;
}


