package com.slots.view.ui {
    import com.slots.config.SlotConfig;
    import com.slots.machine.SlotType;

    import flash.display.Shape;
    import flash.display.Sprite;

    public class SimpleTable extends Sprite {
        private var _inputsList:Vector.<SimpleInput>;
        private var _border:Shape;
        private var _rows:int;
        private var _cols:int;

        public function SimpleTable(rows:int, cols:int, columnWidth:Number = 200) {
            _inputsList = new <SimpleInput>[];

            for (var col:int = 0; col < cols; col++) {
                for (var row:int = 0; row < rows; row++) {
                    var index:int = col * rows + row;

                    var input:SimpleInput = new SimpleInput(columnWidth, index);
                    input.x = col * columnWidth;
                    input.y = row * SimpleInput.HEIGHT;
                    addChild(input);

                    _inputsList[index] = input;
                }
            }

            _border = new Shape();
            _border.graphics.lineStyle(2, 0x000000);
            _border.graphics.drawRect(0, 0, cols * columnWidth, rows * 22);
            addChild(_border);

            _rows = rows;
            _cols = cols;
        }

        public function compose():void {
            const length:int = _inputsList.length;

            for (var i:int = 0; i < length; i++) {
                _inputsList[i].compose();
            }
        }

        public function dispose():void {
            const length:int = _inputsList.length;

            for (var i:int = 0; i < length; i++) {
                _inputsList[i].dispose();
            }
        }

        public function collectItemsTypes():Vector.<Vector.<SlotType>> {
            var itemsTypes:Vector.<Vector.<SlotType>> = new <Vector.<SlotType>>[];

            for (var col:int = 0; col < _cols; col++) {
                itemsTypes[col] = new <SlotType>[];

                for (var row:int = 0; row < _rows; row++) {
                    var name:String = _inputsList[col * _rows + row].text;

                    var type:SlotType = SlotConfig.item.getTypeByName(name);
                    if (type == null) {
                        return null;
                    }

                    itemsTypes[col][row] = type;
                }
            }

            return itemsTypes;
        }
    }
}
