package bloxley.controller.event {
    
    import bloxley.controller.event.BXAction;

    public class BXGroupAction extends BXAction {

        var groupedActions:Array;
        var groupedCauseKey:String;
        
    	public function BXGroupAction(actions:Array, causeKey:String = "effect") {
    	    super();
    	    
    	    this.groupedActions = actions;
    	    this.groupedCauseKey = causeKey;
    	}
    	
    	override public function act() {
            for (var i = 0; i < groupedActions.length; i++) {
                causes(groupedActions[i], groupedCauseKey);
            }
    	}

    }
    
}