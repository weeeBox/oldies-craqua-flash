package bc.ui 
{
	import bc.core.ui.UIObject;
	import bc.core.ui.UIPanel;
	import bc.game.BcGameGlobal;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Elias Ku
	 */
	public class UIGameEffect extends UIPanel
	{
//#if PLATFORM_FLASH
//		protected var _bmWorld:Bitmap = new Bitmap(new BitmapData(640, 480, false, 0x0));

//		protected var _shFader:Shape = new Shape();
		
//		protected var _filterBlur:BlurFilter = new BlurFilter(8, 8, 2);
//		protected var _filterRect:Rectangle = new Rectangle(0, 0, 640, 480);
//		protected var _filterPoint:Point = new Point();
//#endif
		
		
		public function UIGameEffect(layer:UIObject)
		{
			super(layer, 0, 0);

//#if PLATFORM_FLASH
//			_sprite.addChild(_bmWorld);
//			_sprite.addChild(_shFader);
//#endif
		}
		
		public override function reset():void
		{
			super.reset();
			
			_sprite.transform.colorTransform = new ColorTransform();
			
		}
		
		public function initFader():void
		{
//#if PLATFORM_FLASH
//			_bmWorld.visible = false;
//			
//			_shFader.graphics.clear();
//			_shFader.graphics.beginFill(0x000000);
//			_shFader.graphics.drawRect(0, 0, 640, 480);
//			_shFader.graphics.endFill();
//#endif
		}
		
		public function initBack():void
		{
//#if PLATFORM_FLASH
//			_bmWorld.bitmapData.draw(BcGameGlobal.world.sprite);
//			_bmWorld.bitmapData.applyFilter(_bmWorld.bitmapData, _filterRect, _filterPoint, _filterBlur);
//			_bmWorld.visible = true;
//			
//			_shFader.graphics.clear();
//			_shFader.graphics.beginFill(0x000000, 0.5);
//			_shFader.graphics.drawRect(0, 0, 640, 480);
//			_shFader.graphics.endFill();
//#endif
		}
	}
}
