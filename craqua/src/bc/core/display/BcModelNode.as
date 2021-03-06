package bc.core.display 
{
	import bc.game.BcStrings;
	import bc.core.math.Vector2;
	import bc.core.util.BcStringUtil;

	/**
	 * @author Elias Ku
	 */
	public class BcModelNode 
	{
		internal var children:Vector.<BcModelNode>;
		
		public var id:String;
		public var index:int;
		public var parent:int;
		
		public var visible:Boolean = true;
		
		public var x:Number = 0;
		public var y:Number = 0;
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		public var rotation:Number = 0;
		
		public var bitmap:Boolean;
		public var bitmapData:BcBitmapData;
		
		public function BcModelNode()
		{
		}
		
		public function addNode(node:BcModelNode):void
		{
			if(children == null)
			{
				children = new Vector.<BcModelNode>();
			}
			
			children.push(node);
		}

		internal function parseChildren(xml:XML):void
		{
			var node:BcModelNode;
			var xmlNode:XML;
			var xmlList:XMLList = xml.children();
			
			for each (xmlNode in xmlList)
			{
				node = new BcModelNode();
				node.parseInfo(xmlNode);

				var xmlNodeName : String = xmlNode.name().toString();
				if (xmlNodeName == "bitmap")
				{
					node.parseBitmap(xmlNode);	
				}
				else if (xmlNode == "sprite")
				{
					node.parseSprite(xmlNode);	
				}
				
				node.parseChildren(xmlNode);
				addNode(node);
			}
		}
		
		internal function parseInfo(xml:XML):void
		{
			if(xml.hasOwnProperty("@id"))
			{
				id = xml.@id.toString();
			}
		}
		
		internal function parseBitmap(xml:XML):void
		{
			bitmap = true;
			if(xml.hasOwnProperty("@data"))
			{
				bitmapData = BcBitmapData.getData(xml.@data);
			}
		}
		
		internal function parseSprite(xml:XML):void
		{
			bitmap = false;
					
			if(xml.hasOwnProperty("@position"))
			{
				BcStringUtil.parseVector2(xml.@position, VECTOR);
				x = VECTOR.x;
				y = VECTOR.y;
			}
			
			if(xml.hasOwnProperty("@rotation"))
			{
				rotation = BcStringUtil.parseNumber(xml.@rotation);
			}
			
			if(xml.hasOwnProperty("@scale"))
			{
				BcStringUtil.parseVector2(xml.@scale, VECTOR);
				scaleX = VECTOR.x;
				scaleY = VECTOR.y;
			}
			
			if(xml.hasOwnProperty("@visible"))
			{
				visible = BcStringUtil.parseBoolean(xml.@visible);
			}
		}
		
		private static var VECTOR:Vector2 = new Vector2();
	}
}
