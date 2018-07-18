package com.slots.machine {
    import com.slots.config.SlotConfig;

    import flash.display.Bitmap;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    public class SlotItem extends Sprite {
        private var _type:SlotType;

        private var _border:Shape;
        private var _icon:Bitmap;
        private var _name:TextField;

        public function SlotItem() {
            const itemSize:int = SlotConfig.item.size;
            const iconSize:int = SlotConfig.item.icon;

            _border = new Shape();
            _border.graphics.lineStyle(2, 0x000000);
            _border.graphics.beginFill(0xFFFFFF);
            _border.graphics.drawRect(0, 0, itemSize, itemSize);
            _border.graphics.endFill();
            addChild(_border);

            _icon = new Bitmap(SlotIcon.DUMMY);
            _icon.width = iconSize;
            _icon.height = iconSize;
            _icon.y = (itemSize - iconSize) / 2 - 10;
            _icon.x = (itemSize - iconSize) / 2;
            addChild(_icon);

            _name = new TextField();
            _name.defaultTextFormat = new TextFormat(
                'Verdana', 15, 0x000000,
                null, null, null, null, null,
                TextFormatAlign.CENTER
            );
            _name.multiline = false;
            _name.wordWrap = false;
            _name.selectable = false;
            _name.width = itemSize;
            _name.height = 30;
            _name.y = itemSize - 30;
            addChild(_name);
        }

        public function set type(value:SlotType):void {
            if (_type != null) {
                _type.icon.detachTarget(_icon);
                _name.text = '';
            }

            _type = value;

            if (_type != null) {
                _type.icon.attachTarget(_icon);
                _name.text = _type.name;
            }
        }

        public function get type():SlotType {
            return _type;
        }
    }
}
