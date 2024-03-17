#ifndef __FBXML_NODE_LIST__
#define __FBXML_NODE_LIST__

#include once "fb-linkedlist.bi"

namespace Xml
  '' Represents a list of Xml nodes
  type XmlNodeList extends Object
    public:
      declare constructor()
      declare virtual destructor()
      
      declare property count() as integer
      declare property nodes() as LinkedList ptr
      
      declare property first() as LinkedListNode ptr
      declare property last() as LinkedListNode ptr
      
      declare sub append( as XmlNode ptr )
      declare sub prepend( as XmlNode ptr )
      
    private:
      as LinkedList _nodes
  end type
  
  constructor XmlNodeList() : end constructor
  
  destructor XmlNodeList()
    do while( _nodes.count > 0 )
      delete( cptr( XmlNode ptr, _nodes.removeLast() ) )
    loop
  end destructor
  
  property XmlNodeList.count() as integer
    return( _nodes.count )
  end property
  
  property XmlNodeList.first() as LinkedListNode ptr
    return( _nodes.first )
  end property
  
  property XmlNodeList.last() as LinkedListNode ptr
    return( _nodes.last )
  end property
  
  property XmlNodeList.nodes() as LinkedList ptr
    return( @_nodes )
  end property
  
  sub XmlNodeList.append( byval aNode as XmlNode ptr )
    _nodes.addLast( aNode )
  end sub
  
  sub XmlNodeList.prepend( aNode as XmlNode ptr )
    _nodes.addFirst( aNode )
  end sub
end namespace

#endif
