package bloxley.controller.pen {

    import bloxley.controller.game.BXPlayController;
    import bloxley.model.data.BXDirection;
    
    public class BXGameOverPen extends BXPen {

        public function BXGameOverPen(controller:BXPlayController) {
            super(controller);
        }
        
        public function press_Rr(key, shift, alt, ctrl) {
            controller.respondTo("reset");
        }

        override public function press_space() {
            // controller.respondTo( "nextLevel" );
        }
    }
    
}