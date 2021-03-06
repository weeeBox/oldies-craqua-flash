package bc.core.ui 
{
	import bc.core.boxing.BcNumber;
	import bc.core.boxing.BcBoolean;
	import flash.utils.Dictionary;

	/**
	 * @author Elias Ku
	 */
	public class UIStyle 
	{
		private var properties:Dictionary;
		private var baseStyle:UIStyle;
		
		public function UIStyle(base:UIStyle = null, moreProperties:Dictionary = null)
		{
			baseStyle = base;
			
			if(moreProperties != null)
			{
				this.properties = moreProperties;
			}
			else
			{
				this.properties = new Dictionary;
			}
		}
		
		public function setObject(name:String, value:Object):void
		{
			properties[name] = value;
		}
		
		public function setString(name:String, value:String):void
		{
			properties[name] = value;
		}
		
		public function setNumber(name:String, value:Number):void
		{
			properties[name] = new BcNumber(value);
		}		
		
		public function getObject(name:String):Object
		{
			var style:UIStyle = this;
			while(style != null)
			{
				if (style.properties.hasOwnProperty(name))
				{
					return style.properties[name];
				}
								
				style = style.baseStyle;
			}
			
			return null;
		}
		
		public function hasProperty(name : String) : Boolean
		{
			return getObject(name) != null;
		}
		
		public function getString(name:String):String
		{
			var value : Object = getObject(name);
			return value == null ? null : String(value);
		}
		
		public function getBoolean(name:String):Boolean
		{
			var value : Object = getObject(name);
			return value == null ? false : (BcBoolean(value)).value;
		}
		
		public function getUint(name:String):uint
		{
			var value : Object = getObject(name);
			return value == null ? 0 : (BcNumber(value)).uintValue();
		}
		
		public function getInt(name:String):int
		{
			var value : Object = getObject(name);
			return value == null ? 0 : (BcNumber(value)).intValue();
		}
		
		public function getNumber(name:String):Number
		{
			var value : Object = getObject(name);
			return value == null ? 0 : (BcNumber(value)).value;
		}
	}
}
