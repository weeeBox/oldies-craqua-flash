package bc.core.data 
{
	import bc.core.audio.BcMusic;
	import bc.core.audio.BcSound;
	import bc.core.device.BcAsset;
	import bc.core.display.BcBitmapData;
	import bc.core.display.BcModelData;
	import bc.core.display.BcSheetData;
	import bc.core.motion.BcAnimationData;
	import bc.core.motion.BcMotionData;

	import flash.utils.Dictionary;

	/**
	 * @author Elias Ku
	 */
	public class BcData 
	{
		public static function initialize():void
		{
			BcBitmapData.register();
			BcSheetData.register();
			BcModelData.register();
			
			BcSound.register();
			BcMusic.register();
			
			BcMotionData.register();
			BcAnimationData.register();
		}
		
		public static function load(xmlArray:Vector.<String>):void
		{
			var xmlName:String;
			
			for each (xmlName in xmlArray)
			{
				preload(BcAsset.getXML(xmlName));
			}
			
			for each (xmlName in xmlArray)
			{
				parse(BcAsset.getXML(xmlName));
			}
			
			for each (xmlName in xmlArray)
			{
				BcAsset.removeXML(xmlName);
			}
		}
		
		public static function getData(typeName:String, id:String):BcIObjectData
		{
			return BcIObjectData( BcDataTypeInfo( types[typeName] ).collection[id] );
		}
		
		private static var types:Dictionary = new Dictionary();		
		
		private static var ERROR_BAD_XML:String = "BcData: XML not found.";
		private static var ERROR_BAD_TYPE:String = "BcData: object data type not found.";
		
		public static function register(typeName:String, dataCreator:BcObjectDataCreator, collection:Object):void
		{
			types[typeName] = new BcDataTypeInfo(dataCreator, collection);
		}
		
		private static function preload(xml:XML):void
		{
			var typeInfo:BcDataTypeInfo;
			var list:XMLList = xml.children();
			
			if(xml != null)
			{
				for each (var node:XML in list)
				{
					typeInfo = types[ String( node.name() ) ];
					if(typeInfo != null)
					{
						typeInfo.collection[ String( node.@id ) ] = typeInfo.dataCreator.create();
					}
					else
					{
						throw new Error(ERROR_BAD_TYPE);
					}
				}
			}
			else
			{
				throw new Error(ERROR_BAD_XML);
			}
		}
		
		private static function parse(xml:XML):void
		{
			var typeInfo:BcDataTypeInfo;
			var list:XMLList = xml.children();

			if(xml != null)
			{			
				for each (var node:XML in list)
				{
					typeInfo = types[ String( node.name() ) ];
					if(typeInfo != null)
					{
						BcIObjectData( typeInfo.collection[ String( node.@id ) ] ).parse(node);
					}
					else
					{
						throw new Error(ERROR_BAD_TYPE);
					}
				}
			}
			else
			{
				throw new Error(ERROR_BAD_XML);
			}
		}

	}
}

