package com.slots.view.ui {
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    public class SimpleButton extends Sprite {
        public static const HEIGHT:Number = 50;

        private var _enabledTitle:String;
        private var _disabledTitle:String;
        private var _title:TextField;
        private var _border:Shape;

        public function SimpleButton(enabledTitle:String, disabledTitle:String, width:Number) {
            _border = new Shape();
            addChild(_border);

            _title = new TextField();
            _title.defaultTextFormat = new TextFormat(
                'Verdana', 25, 0x000000,
                null, null, null, null, null,
                TextFormatAlign.CENTER
            );
            _title.multiline = false;
            _title.wordWrap = false;
            _title.selectable = false;
            _title.width = width - 10;
            _title.text = enabledTitle;
            _title.height = HEIGHT - 10;
            _title.x = 5;
            _title.y = 5;
            addChild(_title);

            _enabledTitle = enabledTitle;
            _disabledTitle = disabledTitle;

            updateButton(0x000000, 0x00DD00);
            buttonMode = true;
            mouseChildren = false;
        }

        public function compose():void {
            addEventListener(MouseEvent.MOUSE_OVER, mouseStateHandler);
            addEventListener(MouseEvent.MOUSE_OUT, mouseStateHandler);
        }

        public function dispose():void {
            removeEventListener(MouseEvent.MOUSE_OVER, mouseStateHandler);
            removeEventListener(MouseEvent.MOUSE_OUT, mouseStateHandler);
        }

        private function updateButton(borderColor:uint, groundColor:uint):void {
            _border.graphics.clear();
            _border.graphics.lineStyle(2, borderColor);
            _border.graphics.beginFill(groundColor);
            _border.graphics.drawRect(0, 0, _title.width + 10, _title.height + 10);
            _border.graphics.endFill();

            _title.textColor = borderColor;
        }

        private function mouseStateHandler(event:MouseEvent):void {
            if (event.type == MouseEvent.MOUSE_OVER) {
                updateButton(0x000000, 0x00FF00);
            } else {
                if (mouseEnabled) {
                    updateButton(0x000000, 0x00DD00);
                } else {
                    updateButton(0x999999, 0xDDDDDD);
                }
            }
        }

        override public function set mouseEnabled(enabled:Boolean):void {
            super.mouseEnabled = enabled;

            if (enabled) {
                updateButton(0x000000, 0x00DD00);
                _title.text = _enabledTitle;
            } else {
                updateButton(0x999999, 0xDDDDDD);
                _title.text = _disabledTitle;
            }
        }
    }
}
