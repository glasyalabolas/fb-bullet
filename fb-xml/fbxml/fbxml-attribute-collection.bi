#ifndef __FBXML_ATTRIBUTE_COLLECTION__
#define __FBXML_ATTRIBUTE_COLLECTION__

namespace Xml
  '' Represents the collection of attributes for a Xml node
  type XmlAttributeCollection extends Object
    public:
      declare constructor()
      declare virtual destructor()
      
      declare property count() as integer
      
      declare property first() as LinkedListNode ptr
      declare property last() as LinkedListNode ptr
      
      declare sub append( as XmlAttribute ptr )
      declare sub prepend( as XmlAttribute ptr )
    
    private:
      as LinkedList _attributes
  end type
  
  constructor XmlAttributeCollection() : end constructor
  
  destructor XmlAttributeCollection()
    do while( _attributes.count > 0 )
      delete( cptr( XmlAttribute ptr, _attributes.removeLast() ) )
    loop
  end destructor
  
  property XmlAttributeCollection.count() as integer
    return( _attributes.count )
  end property
  
  property XmlAttributeCollection.first() as LinkedListNode ptr
    return( _attributes.first )
  end property
  
  property XmlAttributeCollection.last() as LinkedListNode ptr
    return( _attributes.last )
  end property
  
  sub XmlAttributeCollection.append( anAttribute as XmlAttribute ptr )
    _attributes.addLast( anAttribute )
  end sub
  
  sub XmlAttributeCollection.prepend( anAttribute as XmlAttribute ptr )
    _attributes.addFirst( anAttribute )
  end sub
end namespace

#endif