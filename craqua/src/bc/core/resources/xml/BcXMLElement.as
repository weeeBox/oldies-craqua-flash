package bc.core.resources.xml
{
	/**
	 * @author weee
	 */
	public class BcXMLElement extends BcXMLNode
	{
		private var attributesList : Vector.<BcXMLAttribute>;
		private var nodeList : Vector.<BcXMLNode>;
		
		public function BcXMLElement(name : String)
		{
			super(BcXMLNodeType.ELEMENT, name);
			nodeList = new Vector.<BcXMLNode>();
		}
		
		public function nodes() : Vector.<BcXMLNode>
		{
			return nodeList;
		}
		
		public function nodeCount() : int
		{
			return nodeList.length;	
		}
		
		public function elements(name : String = null) : Vector.<BcXMLElement>
		{
			var result : Vector.<BcXMLElement> = new Vector.<BcXMLElement>();
			
			var ignoreName: Boolean = name == null;
			for each (var node : BcXMLNode in nodeList)
			{
				if (node.getType() == BcXMLNodeType.ELEMENT)
				{
					if (ignoreName || node.getName() == name)
					{
						result.push(BcXMLElement(node));
					}
				}
			}
			
			return result;
		}
		
		public function element(name : String) : BcXMLElement
		{			
			for each (var node : BcXMLNode in nodeList)
			{
				if (node.getType() == BcXMLNodeType.ELEMENT && node.getName() == name)
				{
					return BcXMLElement(node);
				}
			}
			return null;
		}
		
		public function addElement(name : String) : BcXMLElement
		{
			var element : BcXMLElement = new BcXMLElement(name);
			nodeList.push(element);
			return element;
		}
		
		public function addText(name : String, text : String) : BcXMLText
		{
			var textElement : BcXMLText = new BcXMLText(name, text);
			nodeList.push(textElement);
			return textElement;
		}
		
		public function elementText(name : String, defaultText : String = null) : String
		{			
			for each (var node : BcXMLNode in nodeList)
			{
				if (node.getType() == BcXMLNodeType.TEXT && node.getName() == name)
				{
					return (BcXMLText(node)).getText();
				}
			}
			return defaultText;
		}
		
		public function attributeCount() : int
		{
			return attributesList == null ? 0 : attributesList.length;
		}
		
		public function attributes() : Vector.<BcXMLAttribute>
		{
			return attributesList; 
		}
		
		public function addAttribute(name : String, value : String) : BcXMLAttribute
		{
			if (attributesList == null)
			{
				attributesList = new Vector.<BcXMLAttribute>();
			}
			var attribute : BcXMLAttribute = new BcXMLAttribute(name, value);
			attributesList.push();
			return attribute;
		}
		
		public function attributeValue(name : String, defaultValue : String = null) : String
		{
			for each (var attr : BcXMLAttribute in attributesList)
			{
				if (attr.getName() == name)
				{
					return attr.getValue();
				}
			}
			return defaultValue;
		}
	}
}
