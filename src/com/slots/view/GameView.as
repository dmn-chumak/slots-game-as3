package com.slots.view {
    import com.slots.config.SlotConfig;
    import com.slots.machine.SlotEvent;
    import com.slots.machine.SlotMachine;
    import com.slots.machine.SlotType;
    import com.slots.view.ui.SimpleButton;
    import com.slots.view.ui.SimpleInput;
    import com.slots.view.ui.SimpleTable;

    import flash.events.MouseEvent;

    public class GameView extends View {
        private var _slotMachine:SlotMachine;
        private var _spinTable:SimpleTable;
        private var _spinButton:SimpleButton;

        public function GameView() {
            const roulettesCount:int = SlotConfig.machine.roulettesCount;
            const itemSize:int = SlotConfig.item.size;
            const itemsCount:int = SlotConfig.roulette.itemsCount;

            const blockWidth:Number = itemSize * roulettesCount;
            const horizontalSpace:Number = (CONTENT_WIDTH - blockWidth * 2) / 3;

            const machineHeight:Number = itemSize * itemsCount;
            const tableHeight:Number = itemsCount * SimpleInput.HEIGHT;
            const blockHeight:Number = tableHeight + SimpleButton.HEIGHT + 20;
            const verticalSpace:Number = (CONTENT_HEIGHT - blockHeight) / 2;

            _slotMachine = new SlotMachine();
            _slotMachine.x = horizontalSpace;
            _slotMachine.y = (CONTENT_HEIGHT - machineHeight) / 2;
            addChild(_slotMachine);

            _spinTable = new SimpleTable(itemsCount, roulettesCount, itemSize);
            _spinTable.x = horizontalSpace * 2 + blockWidth;
            _spinTable.y = verticalSpace;
            addChild(_spinTable);

            _spinButton = new SimpleButton('Spin', '...', blockWidth);
            _spinButton.x = horizontalSpace * 2 + blockWidth;
            _spinButton.y = verticalSpace + tableHeight + 20;
            addChild(_spinButton);
        }

        override public function compose(params:Object = null):void {
            super.compose(params);

            _spinTable.compose();
            _spinButton.addEventListener(MouseEvent.CLICK, spinClickHandler);
            _spinButton.compose();
        }

        override public function dispose():void {
            _spinTable.dispose();
            _spinButton.removeEventListener(MouseEvent.CLICK, spinClickHandler);
            _spinButton.dispose();

            super.dispose();
        }

        private function spinClickHandler(event:MouseEvent):void {
            var lastItemsTypes:Vector.<Vector.<SlotType>> = _spinTable.collectItemsTypes();
            if (lastItemsTypes == null) {
                return;
            }

            _spinButton.mouseEnabled = false;
            _slotMachine.addEventListener(SlotEvent.SPIN_COMPLETE, spinCompleteHandler);
            _slotMachine.start(lastItemsTypes);
        }

        private function spinCompleteHandler(event:SlotEvent):void {
            _slotMachine.removeEventListener(SlotEvent.SPIN_COMPLETE, spinCompleteHandler);
            _spinButton.mouseEnabled = true;
        }
    }
}
