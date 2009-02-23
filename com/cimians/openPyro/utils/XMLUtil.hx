package com.cimians.openPyro.utils;

    typedef XmlArrayItem = { data:Xml, order:String }

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
		public static function isItemParentOf(item:Xml, newNode:Xml):Bool{
			var foundAsChild:Bool = false;
            if(item.nodeType == Xml.Document)
                item = item.firstElement();

 			for(e in item.elements()){
                if(newNode.toString() == e.toString()) {
                    return true;
                } else {
                    if(isItemParentOf(e, newNode)) {
                        return true;
                    }
                }
			}
			return foundAsChild;
		}
		
		// Source:http://www.nuff-respec.com/technology/sort-xml-by-attribute-in-actionscript-3
		public static function sortXMLByAttribute(
				_S_xml		:	Xml,
				_S_attribute	:	String,
//				?_S_options	:	Dynamic	=	null,
				?_S_copy		:	Bool	=	false
			)
			:Xml
		 {
            var isDocument = false;
            var ogXml = _S_xml;
            if(_S_xml.nodeType == Xml.Document) {
                _S_xml = _S_xml.firstElement();
                isDocument = true;
            }

			//store in array to sort on
			var xmlArray:Array<XmlArrayItem>	= new Array();
			var item:Xml;
			for (item in _S_xml.elements())
			{
                var f = new haxe.xml.Fast(item);
				var object:XmlArrayItem = {
					data	: item, 
					order	: f.att.resolve(_S_attribute)
				};
				xmlArray.push(object);
			}
		
			//sort using the power of Array.sortOn()
			xmlArray.sort(sortOrder);
		
			//create a new XMLList with sorted XML
			var sortedXmlList:Xml = Xml.createDocument();
			for ( xmlObject in xmlArray )
			{
				sortedXmlList.addChild(xmlObject.data);
			}

            // create a copy of the _S_xml element
            var e:Xml;
            e = Xml.createElement(_S_xml.nodeName);
            for(a in _S_xml.attributes()) {
                e.set(a, _S_xml.get(a));
            }
            e.addChild(sortedXmlList);

			if(_S_copy)
			{
				//don't modify original
                if(isDocument) {
                    var copy:Xml = Xml.createDocument();
                    copy.addChild(e);
                    return copy;
                } else {
                    return e;
                }
			}
			else
			{
                if(isDocument) {
                    ogXml.removeChild(_S_xml);
                    ogXml.addChild(e);
                    return ogXml;
                } else {
                    for(e in _S_xml.elements()){
                        _S_xml.removeChild(e);
                    }
                    _S_xml.addChild(sortedXmlList);
                }
				return _S_xml;
			}
		 }
        
        public static function sortOrder( a:XmlArrayItem, b:XmlArrayItem):Int {
            if(a.order == b.order) {
                return 0;
            } else if (a.order < b.order) {
                return -1;
            } else {
                return 1;
            }
        }
	}
