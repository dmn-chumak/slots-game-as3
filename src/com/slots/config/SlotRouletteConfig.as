package com.slots.config {
    public class SlotRouletteConfig extends SlotBaseConfig {
        private var _itemsCount:int;
        private var _accelerationTime:int;
        private var _spinTime:int;
        private var _decelerationTime:int;
        private var _spinSpeed:int;

        override public function parse(data:Object):void {
            super.parse(data);

            _itemsCount = parseIntValue(data, 'itemsCount');
            _accelerationTime = parseIntValue(data, 'accelerationTime');
            _spinTime = parseIntValue(data, 'spinTime');
            _decelerationTime = parseIntValue(data, 'decelerationTime');
            _spinSpeed = parseIntValue(data, 'spinSpeed');

            markAsParsed();
        }

        public function get itemsCount():int {
            checkIfParsed();
            return _itemsCount;
        }

        public function get accelerationTime():int {
            checkIfParsed();
            return _accelerationTime;
        }

        public function get spinTime():int {
            checkIfParsed();
            return _spinTime;
        }

        public function get decelerationTime():int {
            checkIfParsed();
            return _decelerationTime;
        }

        public function get spinSpeed():int {
            checkIfParsed();
            return _spinSpeed;
        }
    }
}
