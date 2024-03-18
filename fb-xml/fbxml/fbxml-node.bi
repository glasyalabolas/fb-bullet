#ifndef __FBXML_NODE__
#define __FBXML_NODE__

'' Base class for all Xml nodes
namespace Xml
  type as XmlElement __XmlElement
  
  type XmlNode extends Object
    public:
      declare virtual destructor()
      
      declare operator cast() as __XmlElement ptr
      
      declare property name() as string_t
      declare property nodeType() as XmlNodeType
      declare virtual property hasAttributes() as boolean
      declare virtual property hasChildNodes() as boolean
      
    protected:
      declare constructor()
      
      as string_t _name
      as XmlNodeType _nodeType = XmlNodeType.None
  end type
  
  constructor XmlNode() : end constructor
  
  destructor XmlNode() : end destructor
  
  property XmlNode.name() as string_t
    return( _name )
  end property
  
  property XmlNode.nodeType() as XmlNodeType
    return( _nodeType )
  end property
  
  property XmlNode.hasAttributes() as boolean
    return( false )
  end property
  
  property XmlNode.hasChildNodes() as boolean
    return( false )
  end property
end namespace

#endif
