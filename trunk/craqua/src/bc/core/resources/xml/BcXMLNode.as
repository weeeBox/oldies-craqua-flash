package bc.core.resources.xml
{
	/**
	 * @author weee
	 */
	public class BcXMLNode
	{
		private var name : String;
		private var type : int;
	
		public function BcXMLNode(type : int, name : String = null)
		{
			this.type = type;
			setName(name);
		}
		
		public function getName() : String
		{
			return name;
		}
		
		public function setName(name : String) : void
		{
			this.name = name;
		}
		
		public function getType() : int
		{
			return type;
		}
	}
}
