package com.slots.config {
    public final class SlotConfig extends SlotBaseConfig {
        private static var _instance:SlotConfig;

        private var _itemConfig:SlotItemConfig;
        private var _rouletteConfig:SlotRouletteConfig;
        private var _machineConfig:SlotMachineConfig;

        public function SlotConfig() {
            if (_instance != null) {
                throw new Error("Use SlotConfig.instance instead of new.");
            }

            _itemConfig = new SlotItemConfig();
            _rouletteConfig = new SlotRouletteConfig();
            _machineConfig = new SlotMachineConfig();

            _instance = this;
        }

        override public function parse(data:Object):void {
            super.parse(data);

            _itemConfig.parse(data.slotItem);
            _rouletteConfig.parse(data.slotRoulette);
            _machineConfig.parse(data.slotMachine);

            markAsParsed();
        }

        private static function get instance():SlotConfig {
            return (_instance != null) ? _instance : new SlotConfig();
        }

        public static function parse(data:Object):void {
            instance.parse(data);
        }

        public static function get item():SlotItemConfig {
            instance.checkIfParsed();
            return instance._itemConfig;
        }

        public static function get roulette():SlotRouletteConfig {
            instance.checkIfParsed();
            return instance._rouletteConfig;
        }

        public static function get machine():SlotMachineConfig {
            instance.checkIfParsed();
            return instance._machineConfig;
        }
    }
}
