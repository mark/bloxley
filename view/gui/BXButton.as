package bloxley.view.gui {

    // import bloxley.base.JSON;
    import bloxley.view.gui.*;

    public class BXButton {

        public static var DEFAULT_BUTTON_ICON_SET = "Button Icons";
        public static var DEFAULT_BUTTON_BACKGROUND_SET = "Button Background";

        var method:String;

        var objects:Array;

        var options:Object;
        
        var owner:Object;

        public function BXButton(owner, method, objects, options) {
            this.owner = owner;
            this.method = method;

            if (objects is Array)
                this.objects = objects;
            else if (objects)
                this.objects = [ objects ];
            else
                this.objects = [];

            this.options = options;
        }

        public function icon():String {
            if (options.icon)
                return options.icon;            
            else if (objects[0])
                return objects[0].toString();
            else
                return method;            
        }

        public function iconSet():String {
            if (options.iconSet)
                return options.iconSet;
            else
                return DEFAULT_BUTTON_ICON_SET;
        }

        public function background():String {
            if (options.background)
                return options.background;
            else
                return null;
        }

        public function backgroundSet():String {
            if (options.backgroundSet)
                return options.backgroundSet;
            else
                return DEFAULT_BUTTON_BACKGROUND_SET;
        }

        public function group():String {
            return options.group;
        }

        public function callOnDown():Boolean {
            return options.onDown;
        }

        
        public function call() {
            owner.respondTo(method, objects);
        }

        public function toString():String { return "<Button: " + method + ">"; }

        /*

        static function loadFromXml(xml:XML) {
            var meth = xml.attributes.action;

            var objects = null;
            var options = new Object();

            if (xml.attributes.params) {
                var json = new JSON();

                try {
                    objects = json.parse(xml.attributes.params);
                } catch(ex) {
                    //trace(ex.name + ":" + ex.message + ":" + ex.at + ":" + ex.text);
                }
            }

            options.icon          = xml.attributes.icon;
            options.iconSet       = xml.attributes.iconSet;
            options.background    = xml.attributes.background;
            options.backgroundSet = xml.attributes.backgroundSet;
            options.group         = xml.attributes.group;
            options.onDown        = xml.attributes.onDown != null;

            return new BXButton(meth, objects, options);
        }

        function toXml() {
            var s = new String();

            s += "<button action='" + method + "'";

            if (objects.length > 0) {
                var json = new JSON();
                s += " params='" + json.stringify(objects) + "'";
            }

            if (options.icon)          s += " icon='" + options.icon + "'";
            if (options.iconSet)       s += " iconSet='" + options.iconSet + "'";
            if (options.background)    s += " background='" + options.background + "'";
            if (options.backgroundSet) s += " backgroundSet='" + options.backgroundSet + "'";
            if (options.group)         s += " group='" + options.group + "'";
            if (options.onDown)        s += " onDown='true'";
            s += " />\n";

            return s;
        }

        */
    }
    
}
