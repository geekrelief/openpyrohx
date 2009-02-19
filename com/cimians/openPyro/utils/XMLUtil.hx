package com.cimians.openPyro.utils;

	class XMLUtil
	 {
		/**
		 * Returns a boolean whether the newNode exists 
		 * anywhere deeper in the item node. For example
		 * to find node  
		 * 
		 * <pre>
		 * <deepNode>one</deepNode> 
		 * </pre>
		 * 
		 * in something like 
		 * 
		 * <pre>
		 * <parent>
		 * 			<node1>
		 * 				<node2>
		 * 	`				<node3>
		 * 						<deepNode>one</deepNode>
		 * 					</node3>
		 *				</node2>
		 * 			</node1>
		 *		</parent>
		 * </pre>
		 */ 
		public function new() { }
		
		/**
		 * Returns a boolean whether the newNode exists 
		 * anywhere deeper in the item node. For example
		 * to find node  
		 * 
		 * <pre>
		 * <deepNode>one</deepNode> 
		 * </pre>
		 * 
		 * in something like 
		 * 
		 * <pre>
		 * <parent>
		 * 			<node1>
		 * 				<node2>
		 * 	`				<node3>
		 * 						<deepNode>one</deepNode>
		 * 					</node3>
		 *				</node2>
		 * 			</node1>
		 *		</parent>
		 * </pre>
		 */ 
		public static function isItemParentOf(item:XML, newNode:XML):Bool{
			if(item.contains(newNode)) return true;
			var foundAsChild:Bool = false
 			for(i in 0...item.children().length()){
				foundAsChild = isItemParentOf(item.children()[i],newNode)
				if(foundAsChild){
					break;
				}
			}
			return foundAsChild;
		}
		
		// Source:http://www.nuff-respec.com/technology/sort-xml-by-attribute-in-actionscript-3
		public static function sortXMLByAttribute(
				_S_xml		:	XML,
				_S_attribute	:	String,
				?_S_options	:	Dynamic	=	null,
				?_S_copy		:	Bool	=	false
			)
			:XML
		 {
			//store in array to sort on
			var xmlArray:Array<Dynamic>	= new Array();
			var item:XML;
			for (item in _S_xml.children())
			{
				var object:Dynamic = {
					data	: item, 
					order	: item.attribute(_S_attribute)
				};
				xmlArray.push(object);
			}
		
			//sort using the power of Array.sortOn()
			xmlArray.sortOn('order',_S_options);
		
			//create a new XMLList with sorted XML
			var sortedXmlList:XMLList = new XMLList();
			var xmlObject:Dynamic;
			for (xmlObject in xmlArray )
			{
				sortedXmlList += xmlObject.data;
			}
			
			if(_S_copy)
			{
				//don't modify original
				return	_S_xml.copy().setChildren(sortedXmlList);
			}
			else
			{
				//original modified
				return _S_xml.setChildren(sortedXmlList);
			}
		 }

	}
