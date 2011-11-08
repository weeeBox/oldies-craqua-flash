package bc.core.resources.xml
{
	/**
	 * @author weee
	 */
	public class BcXMLText extends BcXMLNode
	{
		private var text : String;
		
		public function BcXMLText(name : String, text : String)
		{
			super(BcXMLNodeType.TEXT, name);
			setText(text);	
		}
		
		public function getText() : String
		{
			return text;
		}
		
		public function setText(text : String) : void
		{
			this.text = text; 
		}
	}
}
