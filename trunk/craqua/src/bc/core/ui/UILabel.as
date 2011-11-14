package bc.core.ui 
{
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author Elias Ku
	 */
	public class UILabel extends UIObject 
	{
		public static var defaultStyle:UIStyle;
		
		protected var _textField:TextField = new TextField();
		protected var _textFormat:TextFormat;
		protected var _stroke:DropShadowFilter;
	
		public function UILabel(layer:UIObject, x:Number, y:Number, text:String = "", style:UIStyle = null)
		{
			var strokeBlur:Number;
			
			super(layer, x, y);
			
			if(!style)
			{
				style = getDefaultStyle();
			}
			
			_textFormat = new TextFormat(style.getString("font"), style.getNumber("textSize"), 0xffffff);
			_textField.defaultTextFormat = _textFormat;
			_textField.embedFonts = true;
			_textField.selectable = false;
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.textColor = style.getUint("textColor");
			_textField.text = text;
			_textField.cacheAsBitmap = true;
			
			_sprite.addChild(_textField);
			
			if(text)
			{
				_textField.text = text;
			}
			
			strokeBlur = style.getNumber("strokeBlur");
			if(strokeBlur && strokeBlur > 0)
			{
				_stroke = new DropShadowFilter(0, 0, style.getUint("strokeColor"), style.getNumber("strokeAlpha"), strokeBlur, strokeBlur, style.getNumber("strokeStrength"), 2);
				_textField.filters = [_stroke];
			}
			
		}
		
		public function set html(value:String):void
		{
			if(value)
			{
				_textField.htmlText = value;
			}
			else
			{
				_textField.htmlText = "";
			}
		}
		
		public function set multiline(value:Boolean):void
		{
			_textField.multiline = value;
		}
		
		public function set text(value:String):void
		{
			if(value)
			{
				_textField.text = value;
			}
			else
			{
				_textField.text = "";
			}
		}
		
		public function get text():String
		{
			return _textField.text;
		}
		
		public function set centerX(x:Number):void
		{
			this.x = x + int(-0.5*_sprite.width); 
		}
		
		public static function getDefaultStyle() : UIStyle
		{
			if (defaultStyle == null)
			{
				defaultStyle = new UIStyle();
				defaultStyle.setString("font", "main");
				defaultStyle.setNumber("textSize", 15);
				defaultStyle.setNumber("textColor", 0xffffff);
				defaultStyle.setNumber("strokeBlur", 0);
				defaultStyle.setNumber("strokeColor", 0x0);
				defaultStyle.setNumber("strokeAlpha", 1);
				defaultStyle.setNumber("strokeStrength", 8);	
			}
			return defaultStyle;
		}
	}
}
