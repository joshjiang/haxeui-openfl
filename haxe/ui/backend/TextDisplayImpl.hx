package haxe.ui.backend;

import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;

class TextDisplayImpl extends TextBase {
    private var PADDING_X:Int = 2;
    private var PADDING_Y:Int = 2;

    public var textField:TextField;

    public function new() {
        super();

        textField = createTextField();

        _text = "";
    }

    private function createTextField() {
        var tf:TextField = new TextField();
        tf.type = TextFieldType.DYNAMIC;
        tf.selectable = false;
        tf.mouseEnabled = false;
        tf.autoSize = TextFieldAutoSize.LEFT;
        
        return tf;
    }

    //***********************************************************************************************************
    // Validation functions
    //***********************************************************************************************************

    private override function validateData() {
        if (_text != null) {
            textField.text = normalizeText(_text);
        } else if (_htmlText != null) {
            textField.htmlText = _htmlText;
        }
    }

    private override function validateStyle():Bool {
        var measureTextRequired:Bool = false;

        var format:TextFormat = textField.getTextFormat();

        if (_textStyle != null) {
            if (format.align != _textStyle.textAlign) {
                format.align = _textStyle.textAlign;
            }

            var fontSizeValue = Std.int(_textStyle.fontSize);
            if (format.size != fontSizeValue) {
                format.size = fontSizeValue;

                measureTextRequired = true;
            }

            if (_fontInfo != null && format.font != _fontInfo.data) {
                format.font = _fontInfo.data;
                measureTextRequired = true;
            }

            if (format.color != _textStyle.color) {
                format.color = _textStyle.color;
            }
            
            if (format.bold != _textStyle.fontBold) {
                format.bold = _textStyle.fontBold;
                measureTextRequired = true;
            }
            
            if (format.italic != _textStyle.fontItalic) {
                format.italic = _textStyle.fontItalic;
                measureTextRequired = true;
            }
            
            if (format.underline != _textStyle.fontUnderline) {
                format.underline = _textStyle.fontUnderline;
                measureTextRequired = true;
            }
        }

        textField.defaultTextFormat = format;
        textField.setTextFormat(format);
        if (_htmlText != null) {
            textField.htmlText = normalizeText(_htmlText);
        }

        if (textField.wordWrap != _displayData.wordWrap) {
            textField.wordWrap = _displayData.wordWrap;
            measureTextRequired = true;
        }

        if (textField.multiline != _displayData.multiline) {
            textField.multiline = _displayData.multiline;
            measureTextRequired = true;
        }

        return measureTextRequired;
    }

    private override function validatePosition() {
        #if html5
<<<<<<< HEAD
        textField.x = _left - PADDING_X + 1;
        textField.y = _top - PADDING_Y + 1;
        #elseif flash
        textField.x = _left - PADDING_X + 0;
        textField.y = _top - PADDING_Y + 0;
=======
        textField.x = _left - 1;// + (PADDING_X / 2);
        textField.y = _top + 1;// + (PADDING_Y / 2);
>>>>>>> parent of 50af547... textdisplay visual improvments
        #else
        textField.x = _left - PADDING_X + 1;// + (PADDING_X / 2);
        textField.y = _top - PADDING_Y;// + (PADDING_Y / 2);
        #end
    }

    private override function validateDisplay() {
        if (textField.width != _width) {
            textField.width = _width;
        }

        if (textField.height != _height) {
            textField.height = _height;
        }
    }

    private override function measureText() {
        textField.width = _width;
        
        #if !flash
        _textWidth = textField.textWidth + PADDING_X;
        #else
        _textWidth = textField.textWidth;
        #end
        _textHeight = textField.textHeight;
        if (_textHeight == 0) {
            var tmpText:String = textField.text;
            textField.text = "|";
            _textHeight = textField.textHeight;
            textField.text = tmpText;
        }
        #if !flash
        _textHeight += PADDING_Y;
        #end
    }
    
    private function normalizeText(text:String):String {
        text = StringTools.replace(text, "\\n", "\n");
        return text;
    }
}