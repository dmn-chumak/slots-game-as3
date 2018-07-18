package com.slots.machine {
    import flash.events.Event;

    public class SlotEvent extends Event {
        public static const SPIN_COMPLETE:String = 'spinComplete';

        public function SlotEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
            super(type, bubbles, cancelable);
        }
    }
}
