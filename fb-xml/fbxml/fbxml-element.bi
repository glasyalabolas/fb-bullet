#ifndef __FBXML_ELEMENT__
#define __FBXML_ELEMENT__

namespace Xml
  '' Represents a Xml element
  type XmlElement extends XmlNode
    public:
      declare constructor( as XmlNodeType )
      declare constructor( byref as const string_t, as XmlNodeType )
      declare virtual destructor() override
      
      declare property childNodes() byref as XmlNodeList
      declare property attributes() byref as XmlAttributeCollection
      
      declare virtual property hasAttributes() as boolean override
      declare virtual property hasChildNodes() as boolean override
      
      as string_t content
      
    protected:
      declare constructor()
    
    private:
      as XmlNodeList _childNodes
      as XmlAttributeCollection _attributes
  end type
  
  constructor XmlElement() : end constructor
  
  constructor XmlElement( aNodeType as XmlNodeType )
    constructor( "", aNodeType )
  end constructor
  
  constructor XmlElement( byref aName as const string_t, aNodeType as XmlNodeType )
    _name = aName : _nodeType = aNodeType
  end constructor
  
  destructor XmlElement() : end destructor
  
  property XmlElement.childNodes() byref as XmlNodeList
    return( _childNodes )
  end property
  
  property XmlElement.attributes() byref as XmlAttributeCollection
    return( _attributes )
  end property
  
  property XmlElement.hasAttributes() as boolean
    return( cbool( _attributes.count > 0 ) )
  end property
  
  property XmlElement.hasChildNodes() as boolean
    return( cbool( _childNodes.count > 0 ) )
  end property
  
  operator XmlNode.cast() as XmlElement ptr
    return( cptr( XmlElement ptr, @this ) )
  end operator
end namespace

#endif
