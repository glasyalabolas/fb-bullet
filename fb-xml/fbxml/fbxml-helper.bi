#ifndef __FBXML_HELPER__
#define __FBXML_HELPER__

'' Helper module that contains useful functions to parse FreeBasic primitive
'' data types from a XML node.
namespace Xml
  '' Parses a string from a XML attribute
  function stringAttribute( _
      byref aName as const string_t, anElement as XmlElement ptr ) _
    as string_t
    
    dim as string_t result = ""
    
    if( anElement->hasAttributes ) then
      var anAttribute = anElement->attributes.first
      
      for i as integer = 0 to anElement->attributes.count - 1
        var attrib = cptr( XmlAttribute ptr, anAttribute->item )
        
        if( lcase( attrib->name ) = lcase( aName ) ) then
          result = attrib->value
          exit for
        end if
        
        anAttribute = anAttribute->forward
      next
    end if
    
    return( result )
  end function
  
  '' Parses an integer from a XML attribute
  function integerAttribute( _
      byref aName as const string_t, anElement as XmlElement ptr ) _
    as integer
    
    return( int( val( stringAttribute( aName, anElement ) ) ) )
  end function
  
  '' Parses a long integer from a XML attribute
  function longIntAttribute( _
      byref aName as const string_t, anElement as XmlElement ptr ) _
    as longint
    
    return( clngint( val( stringAttribute( aName, anElement ) ) ) )
  end function
  
  '' Parses a single-precision float from a XML attribute
  function floatAttribute( _
      byref aName as const string_t, anElement as XmlElement ptr ) _
    as single
    
    return( csng( val( stringAttribute( aName, anElement ) ) ) )
  end function
  
  '' Parses a double-precision float from a XML attribute
  function doubleAttribute( _
      byref aName as const string_t, anElement as XmlElement ptr ) _
    as double
    
    return( val( stringAttribute( aName, anElement ) ) )
  end function
  
  '' Parses a boolean from a XML attribute
  function boolAttribute( _
      byref aName as const string_t, anElement as XmlElement ptr ) _
    as boolean
    
    return( cbool( lcase( stringAttribute( aName, anElement ) ) = "true" ) )
  end function
  
  '' Parses a string from a XML element
  function stringElement( _
      byref aName as const string_t, anElement as XmlElement ptr ) _
    as string_t
    
    dim as string_t result = ""
    
    if( anElement->hasChildNodes ) then
      var aNode = anElement->childNodes.first
      
      for i as integer = 0 to anElement->childNodes.count - 1
        var element = cptr( XmlElement ptr, aNode->item )
        
        if( lcase( element->name ) = lcase( aName ) ) then
          result = element->content
          exit for
        end if
        
        aNode = aNode->forward
      next
    end if
    
    return( result )
  end function
  
  '' Parses an integer from a XML element
  function integerElement( _
      byref aName as const string_t, anElement as XmlElement ptr ) _
    as integer
    
    return( int( val( stringElement( aName, anElement ) ) ) )
  end function
  
  '' Parses a long integer from a XML element
  function longIntElement( _
      byref aName as const string_t, anElement as XmlElement ptr ) _
    as longint
    
    return( clngint( val( stringElement( aName, anElement ) ) ) )
  end function
  
  '' Parses a single-precision float from a XML element
  function floatElement( _
      byref aName as const string_t, anElement as XmlElement ptr ) _
    as single
    
    return( csng( val( stringElement( aName, anElement ) ) ) )
  end function
  
  '' Parses a double-precision float from a XML element
  function doubleElement( _
      byref aName as const string_t, anElement as XmlElement ptr ) _
    as double
    
    return( val( stringElement( aName, anElement ) ) )
  end function
  
  '' Parses a boolean from a XML element
  function boolElement( _
      byref aName as const string_t, anElement as XmlElement ptr ) _
    as boolean
    
    return( cbool( lcase( stringElement( aName, anElement ) ) = "true" ) )
  end function
end namespace

#endif
