package bloxley.model.collection {

    public class BXSet {

        var hash:Object;
        var length:Number;

    	/**********************
    	*                     *
    	* Constructor methods *
    	*                     *
    	**********************/

        public function BXSet(of:Object = null) {
            this.hash = new Object();
            length = 0;

            if (of is Array) {
                for (var i = 0; i < of.length; i++) {
                    insert( of[i] );
                }
            } else if (of) {
                this.hash = of;
                for (var k in of) { length++; }
            }
        }

    	public function another(of:Object = null):BXSet {
    		return new BXSet(of);
    	}

    	/****************
    	*               *
    	* Array methods *
    	*               *
    	****************/

    	public function fetch(id:Number) {
    	    return hash[ id ];
    	}

        public function theFirst() {
    		for (var k in hash) {
    		    return hash[ k ];
    		}
    	}

    	public function theNextAfter(current:Object) {
    	    var foundCurrent = false;

    	    for (var k in hash) {
                if (foundCurrent) return hash[k]; // We already found the current, so this one is next

    	        if (current == hash[k]) foundCurrent = true; // We've found the current, so next one is golden.
    	    }

    	    return theFirst(); // We got to the end of the list & didn't find another.
    	}

    	/********************
    	*                   *
    	* Insert and Remove *
    	*                   *
    	********************/

    	public function insert(what:Object) {
    	    if ( contains(what) ) return;
    	    length++;
            hash[ what.id() ] = what;
    	}

    	public function remove(what:Object) {
    	    if (! contains(what) ) return;
    	    length--;
    	    delete hash[ what.id() ];
    	}

    	/**************
    	*             *
    	* Set methods *
    	*             *
    	**************/

    	public function contains(obj:Object):Boolean {
    	    if (obj)
    		    return hash[ obj.id() ] != null;
    		else
    		    return false;
    	}

    	public function union(other:BXSet):BXSet {
    		var newSet = another();

    		each( function(obj) { newSet.insert(obj); } );
    		other.each( function(obj) { newSet.insert(obj); } );

    		return newSet;
    	}

    	public function intersection(other:BXSet):BXSet {
    		var newSet = another();

    		each( function(obj) { if (other.contains(obj)) newSet.insert(obj); } );

    		return newSet;
    	}

    	public function minus(other:BXSet):BXSet {
    		var newSet = another();

    		each( function(obj) { if (! other.contains(obj)) newSet.insert(obj); } );

    		return newSet;
    	}

        /*********************
        *                    *
        * Functional methods *
        *                    *
        *********************/

        public function each(meth) {
            for (var k in hash) {
                _call(meth, [ hash[k] ], k);
            }
    	}

    	public function select(meth) {
    	    var newSet = another();

    		for (var k in hash) {
    			if (_call(meth, [ hash[k] ])) {
    				newSet.insert(hash[k]);
    			}
    		}

    		return newSet;
    	}

    	public function reject(meth) {
    		var newSet = another();

    		for (var k in hash) {
    			if (_call(meth, [ hash[k] ])) {
    				newSet.insert(hash[k]);
    			}
    		}

    		return newSet;
    	}

    	public function map(meth) {
    		var newSet = another();

    		for (var k in hash) {
    		    var result = _call(meth, [ hash[k] ]);
    			newSet.insert(result);
    		}

    		return newSet;
    	}

    	public function inject(initial, meth) {
    		var newObject = initial;

            for (var k in hash) {
                newObject = _call(meth, [ newObject, hash[k] ]);
            }

    		return newObject;
    	}

    	/*********
    	*        *
    	* _call* *
    	*        *
    	*********/

        public function _call(meth, args, key = null) {
            if (! meth is Function) meth = args[0][meth];
            
            return meth.apply(null, args);
        }

    	/***********
    	*          *
    	* That Are *
    	*          *
    	***********/

        public function thatAre(meth) {
    		return select(meth);
    	}

        public function thatAreNot(meth) {
    		return reject(meth);
    	}

    	/**********
    	*         *
    	* Of Type *
    	*         *
    	**********/

        public function ofType(key:String) {
    		return select( function(obj) { return obj.key() == key; } );
    	}

        public function notOfType(key:String) {
    		return reject( function(obj) { return obj.key() == key; } );
    	}

        public function areAllOfType(key:String):Boolean {
    		return inject(true, function(accum, obj) { return accum && obj.isA(key); } );
    	}

    	/***********
    	*          *
    	* How Many *
    	*          *
    	***********/

        public function howMany():Number			  { return length; }

        public function areThereAny():Boolean         { return howMany() > 0;  }

        public function isEmpty():Boolean		      { return howMany() == 0; }

        public function mustBeNone():Boolean		  { return howMany() == 0; }

        public function areMoreThan(n:Number):Boolean { return howMany() >  n; }

        public function areAtLeast(n:Number):Boolean  { return howMany() >= n; }

        public function areAtMost(n:Number):Boolean   { return howMany() <= n; }

        public function areLessThan(n:Number):Boolean { return howMany() <  n; }

    	/**********
    	*         *
    	* Must Be *
    	*         *
    	**********/

        public function mustBe(meth):Boolean {
    		var newSet = select(meth);
    		return howMany() == newSet.howMany();
    	}

        public function mustNotBe(meth):Boolean {
    		var newSet = reject(meth);
    		return howMany() == newSet.howMany();
    	}

        public function someMustBe(meth):Boolean {
    		var newSet = select(meth);
    		return newSet.areThereAny();
    	}

    	/***************
    	*              *
    	* Must Be Only *
    	*              *
    	***************/

    	public function mustBeOnly(obj):Boolean {
    		return (length == 1) && (theFirst() == obj);
    	}

        /*****************
        *                *
        * Random Methods *
        *                *
        *****************/
        
        public function random() {
            var index = Math.floor(Math.random() * length);
            var c = 0;
            
            for (var k in hash) {
                if (c == index)
                    return hash[k];
                else
                    c++;
            }
        }
        
    	/******************
    	*                 *
    	* Utility methods *
    	*                 *
    	******************/

    	public function toString():String {
    		var string = "{ ";

    		for (var k in hash) {
    			string += hash[k] + ", ";
    		}

    		string += " }";

    		return string;
    	}

    }

}
