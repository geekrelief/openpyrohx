package com.cimians.openPyro.core;

	
	/**
	 *  A ClassFactory instance is a "factory object" which can be used
	 *  to generate instances of another class, each with identical properties.
	 * 
	 */	

	class ClassFactory
	 {
		
		/**
	     *  The Class that the <code>newInstance()</code> method uses
		 *  to generate objects from this factory object.
	     */
	    
		
		/**
	     *  The Class that the <code>newInstance()</code> method uses
		 *  to generate objects from this factory object.
	     */
	    public var generator:Class<Dynamic>;
		
		/**
		 *	An Object whose name/value pairs specify the properties to be set
		 *  on each object generated by the <code>newInstance()</code> method.
		 *
		 *  <p>For example, if you set <code>properties</code> to
		 *  <code>{ text: "Hello", width: 100 }</code>, then every instance
		 *  of the <code>generator</code> class that is generated by calling
		 *  <code>newInstance()</code> will have its <code>text</code> set to
		 *  <code>"Hello"</code> and its <code>width</code> set to
		 *  <code>100</code>.</p>
		 *
		 *  @default null
		 */
		public var properties:Dynamic ;		
		
	    /**
	     *  Constructor.
	     *
	     *  @param generator The Class that the <code>newInstance()</code> method uses
		 *  to generate objects from this factory object.
	     */
		public function new(?generator:Class<Dynamic> = null)
		{
			
			properties = null;
			super();
			
    		this.generator = generator;
			
		}

		/**
		 *  Creates a new instance of the <code>generator</code> class,
		 *  with the properties specified by <code>properties</code>.
		 *
		 *  <p>This method implements the <code>newInstance()</code> method
		 *  of the IFactory interface.</p>
		 *
		 *  @return The new instance that was created.
		 */
		public function newInstance():Dynamic
		{
			var instance:Dynamic = new generator();
	
	        if (properties != null)
	        {
	        	for (var p:String in properties)
				{
	        		instance[p] = properties[p];
				}
	       	}
	
	       	return instance;
		}
		
	}
