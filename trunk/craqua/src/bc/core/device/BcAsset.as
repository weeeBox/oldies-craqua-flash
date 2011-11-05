package bc.core.device 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.media.Sound;
	import flash.utils.ByteArray;

	/**
	 * @author Elias Ku
	 */
	public class BcAsset implements BcLoaderCallback
	{	
		public static function addImage(id:String, bitmapData:BitmapData):void
		{
			images[id] = bitmapData;
		}
		
		public static function getImage(id:String):BitmapData
		{
			return images[id];
		}
		
		public static function embedImage(id:String, cls:Class, alpha:Boolean):void
		{
			images[id] = processBitmapData(Bitmap(new cls()).bitmapData, alpha);
		}
		
		public static function removeImage(id:String):void
		{
			delete images[id];
		}
		
		public static function addSound(id:String, sound:Sound):void
		{
			sounds[id] = sound;
		}
		
		public static function getSound(id:String):Sound
		{
			return sounds[id];
		}
		
		public static function embedSound(id:String, cls:Class):void
		{
			sounds[id] = Sound(new cls());
		}
		
		public static function removeSound(id:String):void
		{
			delete sounds[id];
		}
		
		public static function addXML(id:String, xml:XML):void
		{
			xmls[id] = xml;
		}	
				
		public static function getXML(id:String):XML
		{
			return xmls[id];
		}
		
		public static function embedXML(id:String, cls:Class):void
		{
			var ba:ByteArray = (new cls()) as ByteArray;
			xmls[id] = XML(ba.readUTFBytes(ba.length));
		}
		
		public static function removeXML(id:String):void
		{
			delete xmls[id];
		}
		
		public static function load(path:String, onLoadingCompleted:BcAssetCallback):void
		{
			impl.load(path, onLoadingCompleted);
		}
		
		private static function processBitmapData(bitmapData:BitmapData, alpha:Boolean):BitmapData
		{
			var bd:BitmapData = bitmapData;
			var temp:BitmapData;
			
			if(!alpha)
			{
				temp = new BitmapData(bd.width, bd.height, false, 0);
				temp.draw(bd);
				bd = temp;
				temp = null;
			}
			
			return bd;
		}
		
		internal static function get busy():Boolean
		{
			return impl.busyCounter > 0;
		}
		
		internal static function initialize():void
		{
			impl = new BcAsset(new BcAssetSingleton());
		}
		
		// Коллекции ресурсов, разделены по типам
		private static var images:Object = new Object();
		private static var xmls:Object = new Object();
		private static var sounds:Object = new Object();
		
		private static var impl:BcAsset;
		
		// Массив загрузчиков, чистится при завершении загрузки
		private var loaders:Vector.<BcLoader>;
		private var activeLoaders:uint;
		public var busyCounter:uint;
		
		private var loadingCallback:BcAssetCallback;
		
		public function BcAsset(singleton:BcAssetSingleton)
		{
			if(singleton)
			{
				loaders = new Vector.<BcLoader>();
			}
		}
		
		public function load(path:String, loadingCallback:BcAssetCallback):void
		{
			this.loadingCallback = loadingCallback;
			createLoader(BcLoader.LOADER_XML, "__desc", path, this, true);
			busyCounter++;
		}

		private function createLoader(type:String, id:String, source:String, _complete:BcLoaderCallback, descLoader:Boolean):BcLoader
		{
			var loader:BcLoader = new BcLoader(type, id, source, _complete, descLoader);
			
			loaders.push(loader);
			++activeLoaders;
			
			return loader;
		}
		
		private function releaseLoader():void
		{
			--activeLoaders;
			if(activeLoaders==0)
			{
				loaders.length = 0;
				busyCounter--;
				if(loadingCallback!=null)
				{
					loadingCallback.assetLoadingCompleted();
					loadingCallback = null;
				}
			}
		}
		
		public function onDescriptionLoaded(loader:BcLoader):void
		{
			var desc:XML = loader.xml;
			
			if(desc)
			{
				parseDescription(desc);
			}
			
			releaseLoader();
		}
		
		public function onResourceLoaded(loader:BcLoader):void
		{
			switch(loader.type)
			{
				case BcLoader.LOADER_IMAGE:
					images[loader.id] = processBitmapData(loader.bitmapData, loader.metaAlpha);
					break;
				case BcLoader.LOADER_XML:
					xmls[loader.id] = loader.xml;
					break;
				case BcLoader.LOADER_SOUND:
					sounds[loader.id] = loader.sound;
					break;
			}
			
			releaseLoader();
		}
		
		private function parseDescription(xml:XML):void
		{
			var res_node:XML;
			var path_full:String = xml.@path.toString();

			for each (res_node in xml.resource)
			{
				parseResource(res_node, path_full);
			}
		}

		private var RESOURCE_REG_EXP:RegExp = /[\\\/]/g;
		
		private function parseResource(xml:XML, assetPath:String):void
		{
			var id:String;
			var path:String;
			var ext:String;
			var alpha:Boolean = true;
			var loader:BcLoader;
			
			
			path = assetPath + xml.@path.toString();
			id = xml.@path.toString();
			
			ext = id.substr(id.length-4);
			id = id.slice(0, id.length-4);
			
			if(id.charAt(id.length-1) == "_")
			{
				alpha = false;
				id = id.slice(0, id.length-1);
			}
			
			id = id.replace(RESOURCE_REG_EXP, "_");
			
			switch(ext)
			{
				case ".png":
				case ".jpg":
					loader = createLoader(BcLoader.LOADER_IMAGE, id, path, this, false);
					loader.metaAlpha = alpha;
					break;
				case ".mp3":
				case ".wav":
					createLoader(BcLoader.LOADER_SOUND, id, path, this, false);
					break;
				case ".xml":
					createLoader(BcLoader.LOADER_XML, id, path, this, false);
					break;
				default:
					throw new Error("BcAsset: unknown resource type.");
					break;
			}
		}
	}
}

internal class BcAssetSingleton 
{
}