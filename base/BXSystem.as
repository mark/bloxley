package bloxley.base {

    import flash.display.Stage;

    import bloxley.base.BXObject;
    import bloxley.view.clock.BXClock;
    import bloxley.controller.mailbox.BXMailbox;
    import bloxley.view.gui.BXScreen;
    
    public class BXSystem extends BXObject {

        static var initialized = false;

        public static var screen:BXScreen;
        
        // Set up the game: create a clock, a mailbox, and a top level graphics container
        public static function initialize(stage:Stage) {
            if (initialized) return;

            new BXClock(stage);
            new BXMailbox();
            BXSystem.screen = new BXScreen(stage);

            initialized = true;
        }
    }
    
}

