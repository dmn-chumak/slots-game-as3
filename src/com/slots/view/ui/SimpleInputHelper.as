package com.slots.view.ui {
    import com.slots.config.SlotConfig;
    import com.slots.machine.SlotType;

    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.geom.Point;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    public class SimpleInputHelper extends Sprite {
        private static var _instance:SimpleInputHelper;
        private var _field:TextField;

        public function SimpleInputHelper() {
            _field = new TextField();
            _field.defaultTextFormat = new TextFormat('Verdana', 15);
            _field.autoSize = TextFieldAutoSize.LEFT;
            _field.multiline = true;
            _field.wordWrap = true;
            _field.selectable = false;
            _field.backgroundColor = 0xF0F0F0;
            _field.background = true;
            _field.border = true;
            addChild(_field);
        }

        public static function show(input:SimpleInput, search:String):void {
            var stage:Stage = input ? input.stage : null;
            if (stage == null) {
                return;
            }

            const itemTypes:Vector.<SlotType> = SlotConfig.item.types;
            var foundItems:String = '';
            var foundItemsCount:int = 0;

            for (var i:int = 0; i < itemTypes.length; i++) {
                if (itemTypes[i].name.indexOf(search) != -1) {
                    if (++foundItemsCount < 5) {
                        foundItems += itemTypes[i].name + '\n';
                    } else {
                        foundItems += '...';
                        break;
                    }
                }
            }

            if (foundItemsCount == 0) {
                if (_instance.parent != null) {
                    stage.removeChild(_instance);
                }

                return;
            }

            var point:Point = new Point(input.x, input.y);
            point = input.parent.localToGlobal(point);

            _instance ||= new SimpleInputHelper();
            _instance._field.width = input.width;
            _instance._field.text = foundItems;
            _instance.x = point.x;
            _instance.y = point.y + input.height;

            stage.addChild(_instance);
        }

        public static function hide():void {
            var stage:Stage = _instance ? _instance.stage : null;
            if (stage != null) {
                stage.removeChild(_instance);
            }
        }
    }
}
