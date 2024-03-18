#ifndef __FBXML_XMLATTRIBUTE__
#define __FBXML_XMLATTRIBUTE__

''  Represents a Xml attribute
namespace Xml
  type XmlAttribute extends XmlNode
    public:
      declare constructor( _
        byref as const string_t, _
        byref as string_t )
      declare destructor()
      
      as string_t value
    
    private:
      declare constructor()
  end type
  
  constructor XmlAttribute() : end constructor
  
  constructor XmlAttribute( _
      byref aName as const string_t, _
      byref aValue as string_t )
    
    _name = aName
    _nodeType = XmlNodeType.Attribute
    value = aValue
  end constructor
  
  destructor XmlAttribute() : end destructor
end namespace

#endif
