package com.slots.config {
    public class SlotMachineConfig extends SlotBaseConfig {
        private var _roulettesCount:int;
        private var _roulettesSpinDelay:int;

        override public function parse(data:Object):void {
            super.parse(data);

            _roulettesCount = parseIntValue(data, 'roulettesCount');
            _roulettesSpinDelay = parseIntValue(data, 'roulettesSpinDelay');

            markAsParsed();
        }

        public function get roulettesCount():int {
            checkIfParsed();
            return _roulettesCount;
        }

        public function get roulettesSpinDelay():int {
            checkIfParsed();
            return _roulettesSpinDelay;
        }
    }
}
