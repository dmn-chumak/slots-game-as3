package com.slots.config {
    import com.slots.machine.SlotIcon;
    import com.slots.machine.SlotType;

    public class SlotItemConfig extends SlotBaseConfig {
        private var _typesList:Vector.<SlotType>;
        private var _size:int;
        private var _icon:int;

        public function SlotItemConfig() {
            _typesList = new <SlotType>[];
        }

        private function parseTypes(data:Object):void {
            if ((data.types as Array) == null) {
                throw new Error('Game config is empty or invalid.');
            }

            const length:int = data.types.length;

            for (var i:int = 0; i < length; i++) {
                var typeData:Object = data.types[i];
                var type:SlotType = new SlotType();

                type.id = parseIntValue(typeData, 'id');
                type.icon = new SlotIcon(parseStringValue(typeData, 'icon'));
                type.name = parseStringValue(typeData, 'name');

                _typesList[i] = type;
            }
        }

        override public function parse(data:Object):void {
            super.parse(data);

            _size = parseIntValue(data, 'size');
            _icon = parseIntValue(data, 'icon');
            parseTypes(data);

            markAsParsed();
        }

        public function getTypeByName(name:String):SlotType {
            const length:int = _typesList.length;

            for (var i:int = 0; i < length; i++) {
                if (_typesList[i].name == name) {
                    return _typesList[i];
                }
            }

            return null;
        }

        public function get types():Vector.<SlotType> {
            checkIfParsed();
            return _typesList;
        }

        public function get size():int {
            checkIfParsed();
            return _size;
        }

        public function get icon():int {
            checkIfParsed();
            return _icon;
        }
    }
}
