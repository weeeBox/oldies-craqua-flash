package bc.core.device 
{
	import bc.core.debug.BcDebug;
	import bc.core.resources.loaders.BcResLoaderFactory;
	import bc.core.resources.loaders.BcResLoader;
	import bc.core.resources.BcResLoaderListener;
	import flash.display.BitmapData;
	import flash.media.Sound;

	/**
	 * @author Elias Ku
	 */
	public class BcAsset implements BcResLoaderListener
	{	
		public static function addImage(id:String, bitmapData:BitmapData):void
		{
			images[id] = bitmapData;
		}
		
		public static function getImage(id:String):BitmapData
		{
			return images[id];
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
		
		public static function removeXML(id:String):void
		{
			delete xmls[id];
		}
		
		public static function load(path:String, assetCallback:BcAssetCallback):void
		{
			instance.load(path, assetCallback);
		}
		
		internal static function get busy():Boolean
		{
			return instance.busyCounter > 0;
		}
		
		internal static function initialize():void
		{
			new BcResLoaderFactory();
			instance = new BcAsset(new BcAssetSingleton());
		}
		
		public static function getInstance() : BcAsset
		{
			return instance;
		}
		
		private static var XML_DEST_ID : String = "__desc";
		
		// Коллекции ресурсов, разделены по типам
		private static var images:Object = new Object();
		private static var xmls:Object = new Object();
		private static var sounds:Object = new Object();
		
		private static var instance:BcAsset;
		
		// Массив загрузчиков, чистится при завершении загрузки
		private var loaders:Vector.<BcResLoader>;
		private var activeLoaders:uint;
		public var busyCounter:uint;
		
		private var loadingCallback:BcAssetCallback;
		
		public function BcAsset(singleton:BcAssetSingleton)
		{
			if(singleton)
			{
				loaders = new Vector.<BcResLoader>();
			}
		}
		
		public function load(path:String, loadingCallback:BcAssetCallback):void
		{
			this.loadingCallback = loadingCallback;
			createLoader(XML_DEST_ID, path, this);
			busyCounter++;
		}

		private function createLoader(id:String, path:String, listener:BcResLoaderListener):BcResLoader
		{
			// var loader:BcLoader = new BcLoader(type, id, source, _complete, descLoader);			
			var loader : BcResLoader = BcResLoaderFactory.getInstance().createLoader(id, path, listener);
			
			loaders.push(loader);
			++activeLoaders;
		
			loader.load();
			
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
		
		private function parseDescription(xml:XML):void
		{
			var res_node:XML;
			var path_full:String = xml.attribute("path");
			var resources:XMLList = xml.elements("resource");

			for each (res_node in resources)
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
			
			path = assetPath + xml.attribute("path");
			id = xml.attribute("path");
			
			ext = id.substr(id.length-4);
			id = id.slice(0, id.length-4);
			
			id = id.replace(RESOURCE_REG_EXP, "_");
		
			createLoader(id, path, this);
		}

		public function resLoadingComplete(loader : BcResLoader, data : Object) : void
		{
			var id : String = loader.getId();
			
			switch(loader.getType())
			{
				case BcResLoaderFactory.LOADER_IMAGE:
				{
					images[id] = BitmapData(data);
					break;
				}
				case BcResLoaderFactory.LOADER_XML:
				{
					var xml : XML = XML(data);
					if (id == XML_DEST_ID)
					{
						parseDescription(xml);
					}
					else
					{
						xmls[id] = xml;
					}
					break;
				}
				case BcResLoaderFactory.LOADER_SOUND:
				{
					sounds[id] = Sound(data);
					break;
				}
			}
			
			releaseLoader();
		}

		public function resLoadingFailed(loader : BcResLoader) : void
		{
			BcDebug.assert(false);
		}
	}
}

internal class BcAssetSingleton 
{
}