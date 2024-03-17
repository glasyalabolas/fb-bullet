#ifndef __FBXML_DOCUMENT_ROOT__
#define __FBXML_DOCUMENT_ROOT__

namespace Xml
  /'
    Represents the root node for the Xml document hierarchy.
    
    Note that this node is not the same as the 'document element', which
    contains the outermost Xml element. This is simply an abstraction that
    will contain all the Xml nodes for a document once parsed.
  '/
  type XmlDocumentRoot extends XmlElement
    public:
      declare constructor()
      declare virtual destructor() override
      
      declare function getDocumentElement() as XmlElement ptr
  end type
  
  constructor XmlDocumentRoot()
    _name = "<root>"
    _nodeType = XmlNodeType.DocumentRoot
  end constructor
  
  destructor XmlDocumentRoot() : end destructor
  
  function XmlDocumentRoot.getDocumentElement() as XmlElement ptr
    dim as XmlElement ptr documentElement
    
    if( base.hasChildNodes ) then
      var node = childNodes.first
      
      for i as integer => 0 to childNodes.count - 1
        if( cptr( XmlElement ptr, node->item )->nodeType = XmlNodeType.Element ) then
          documentElement = cptr( XmlElement ptr, node->item )
          exit for
        end if
        
        node = node->forward
      next
    end if
    
    return( documentElement )
  end function
end namespace

#endif
