package com.slots.view.ui {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;

    public class SimpleInput extends Sprite {
        public static const HEIGHT:Number = 22;

        private var _field:TextField;

        public function SimpleInput(width:Number = 200, index:int = -1) {
            _field = new TextField();
            _field.defaultTextFormat = new TextFormat('Verdana', 15, 0x000000);
            _field.multiline = false;
            _field.wordWrap = false;
            _field.selectable = true;
            _field.background = true;
            _field.border = true;
            _field.type = TextFieldType.INPUT;
            _field.width = width;
            _field.height = HEIGHT;
            _field.tabIndex = index;
            addChild(_field);
        }

        public function compose():void {
            _field.addEventListener(Event.CHANGE, textChangeHandler);
            _field.addEventListener(FocusEvent.FOCUS_OUT, focusStateHandler);
            _field.addEventListener(FocusEvent.FOCUS_IN, focusStateHandler);
        }

        public function dispose():void {
            _field.removeEventListener(Event.CHANGE, textChangeHandler);
            _field.removeEventListener(FocusEvent.FOCUS_OUT, focusStateHandler);
            _field.removeEventListener(FocusEvent.FOCUS_IN, focusStateHandler);
        }

        private function textChangeHandler(event:Event):void {
            SimpleInputHelper.show(this, _field.text);
        }

        private function focusStateHandler(event:FocusEvent):void {
            if (event.type == FocusEvent.FOCUS_IN) {
                SimpleInputHelper.show(this, _field.text);
            } else {
                SimpleInputHelper.hide();
            }
        }

        public function get text():String {
            return _field.text;
        }
    }
}
