package bc.core.resources.xml
{
	/**
	 * @author weee
	 */
	public class BcXMLAttribute extends BcXMLNode
	{
		private var value : String;
		
		public function BcXMLAttribute(name : String, value : String)
		{
			super(BcXMLNodeType.ATTRIBUTE, name);
			setValue(value);	
		}
		
		public function getValue() : String
		{
			return value;
		}
		
		public function setValue(value : String) : void
		{
			this.value = value;
		}
	}
}
