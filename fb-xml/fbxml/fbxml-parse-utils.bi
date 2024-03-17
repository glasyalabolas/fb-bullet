#ifndef __FBXML_PARSE_UTILS__
#define __FBXML_PARSE_UTILS__

#include once "file.bi"

/'
  Parsing helper module for the Xml framework.
  It contains some useful functions to deal with the parsing of XML entities.
'/
namespace Xml
  '' Special characters used during parsing
  enum SpecialChars
    NullChar = 0
    Tab = 9
    Lf = 10
    Cr = 13
    Space = 32
  end enum
  
  const as string_t _
    fbCr = chr( SpecialChars.Cr ), _
    fbLf = chr( SpecialChars.Lf ), _
    fbCrLf = chr( SpecialChars.Cr, SpecialChars.Lf )
  
  '' Defines a string containing the chars considered whitespace
  const as string_t WhiteSpace = _
    chr( SpecialChars.Tab ) + _
    chr( SpecialChars.Lf ) + _
    chr( SpecialChars.Cr ) + _
    chr( SpecialChars.Space )
  
  '' Returns whether or not the subject string is white space. Note that while it
  '' accepts a string, only a single char is considered for consistency.
  function isWhiteSpace( byref subject as const string_t ) as boolean
    return( cbool( inStr( subject, any WhiteSpace ) > 0 ) )
  end function
  
  '' Returns whether or not a string matches a subject string at the specified
  '' position.
  function match( _
      byref subject as const string_t, _
      byref aMatch as const string_t, _
      position as uinteger ) _
    as boolean
    
    return( cbool( _
      aMatch <> "" andAlso _
      mid( subject, position, len( aMatch ) ) = aMatch ) )
  end function
  
  '' Returns the char from the subject string at the specified position.
  function char( _
      byref subject as const string_t, position as uinteger ) _
    as string_t
    
    return( chr( subject[ position - 1 ] ) )
  end function
  
  '' Returns whether or not any char of a substring is within another subject string.
  function within( _
      byref subject as const string_t, byref substring as const string_t ) _
    as boolean
    
    return( cbool( inStr( subject, any substring ) > 0 ) )
  end function
  
  '' Retrieves a substring from a subject string starting at the specified position
  '' and up to (but not including) the specified delimiter chars.
  function getString( _
      byref subject as const string_t, _
      byref delimiters as const string_t, _
      position as uinteger, _
      byref aName as string_t ) _
    as uinteger
    
    dim as integer _
      startPosition = position, _
      endPosition = inStr( startPosition, subject, any delimiters )
      
    aName = mid( subject, startPosition, endPosition - startPosition )
    
    return( position + ( endPosition - startPosition ) )
  end function
  
  '' Skips all white space in the given subject string, starting at the specified
  '' position.
  function skipWhiteSpace( _
      byref subject as const string_t, position as uinteger ) _
    as uinteger
    
    do while( _
      position < len( subject ) andAlso _
      isWhiteSpace( char( subject, position ) ) )
      
      position += 1
    loop
    
    return( position )
  end function
  
  '' Returns whether or not a subject string is 'empty', that is, it only contains
  '' white space.
  function isEmptyString( byref subject as const string_t ) as boolean
    for i as integer = 1 to len( subject )
      if( not isWhiteSpace( char( subject, i ) ) ) then
        return( false )
      end if
    next
    
    return( true )
  end function
  
  /'
    Returns the namespace from a XML symbol name, or an empty string if there's no
    namespace.
    
    getXMLNamespace( "svg:path" ) -> "svg"
    getXMLNamespace( "svg" ) -> ""
     
  '/
  function getXMLNamespace( byref aName as const string_t ) as string_t
    dim as integer separator = inStr( aName, ":" )
    
    return( iif( separator, mid( aName, 1, separator - 1 ), "" ) )
  end function
  
  /'
    Returns the name from a XML symbol name with namespace. If there's no namespace,
    then the name is returned.
    
    getXMLName( "svg:path" ) -> "path" 
    getXMLName( "path" ) -> "path" 
  '/
  function getXMLName( byref aName as const string_t ) as string_t
    dim as integer separator = inStr( aName, ":" )
    
    return( iif( inStr( aName, ":" ), mid( aName, separator + 1, len( aName ) - separator ), aName ) )
  end function
  
  /'
    Extracts the name of a URI resource from a tag. URI resources in XML have the form
    'url(#resourceName)', so this function returns 'resourceName', or a null string if
    the tag does not contain a '#' (which is used to separate the name from the rest of
    the tag).
  '/
  function getURLResourceName( byref anURL as const string_t ) as string_t
    dim as integer startPos = inStr( anURL, "#" )
    
    if( startPos > 0 ) then
      dim as integer endPos = inStr( startPos, anURL, ")" )
      
      return( mid( anURL, startPos + 1, endPos - startPos - 1 ) )
    end if
    
    return( "" )
  end function
  
  /'
    Gets an escaped XML char.
    
    getEscapedCharTag( "&amp;", 1 ) -> "&"
    getEscapedCharTag( "&lt;", 1 ) -> "<"
    getEscapedCharTag( "&gt;", 1 ) -> ">"
    getEscapedCharTag( "&apos;", 1 ) -> "'"
    getEscapedCharTag( "&quot;", 1 ) -> '"'
    
    The interest of escaping these chars is that three of them are used in their
    literal forms to delimit markup, so for them to appear in both attribute
    values and element contents, an escaping mechanism needs to be used.
  '/
  function getEscapedChar( _
      byref subject as const string_t, _
      position as uinteger, _
      byref tag as string_t ) _
    as uinteger
    
    dim as string_t literal = ""
    
    do while( _
      position < len( subject ) andAlso _
      cbool( char( subject, position ) <> ";" ) )
      
      literal += char( subject, position )
      
      position += 1
    loop
    
    /'
      TODO:
      
        - This could be factored out to a dictionary lookup for more
          efficiency and flexibility.
    '/
    select case( lcase( literal ) )
      case( "amp" )
        tag = "&"
      
      case( "lt" )
        tag = "<"
      
      case( "gt" )
        tag = ">"
      
      case( "apos" )
        tag = "'"
      
      case( "quot" )
        tag = """"
      
      case else
        tag = ""
    end select
    
    return( position )
  end function
  
  /'
    Returns the subject string with all the XML escaped chars within replaced with
    their literal equivalents. Note that the function assummes that the '&' char
    (which is used in XML to signal the start of an escaped char) ALWAYS appear in
    its escaped form.
    
    This function is usually used when retrieving the value for attributes, since
    they allow the value to contain, for example, double quotes and apostrophes
    (which are used in their literal form to delimit the attribute value).
  '/
  function replaceEscapedChars( _
      byref subject as const string_t, position as integer = 1 ) _
    as string_t
    
    dim as string_t _
      replaced = "", _
      escaped = ""
    
    do while( position <= len( subject ) )
      dim as boolean isLiteral = true
      
      '' If the char is the start of an escaped char, retrieve it and flag it
      '' as such.
      if( char( subject, position ) = "&" ) then
        position = getEscapedChar( subject, position + 1, escaped )
        
        isLiteral = false
      end if
      
      '' Then, if the char was a literal, collect it as it is. Otherwise, replace
      '' it with the appropriate escaped char.
      replaced += iif( isLiteral, char( subject, position ), escaped ) 
      
      position += 1
    loop
    
    return( replaced )
  end function
  
  '' Loads a file as a string.
  '' Not exactly rocket-science, but this is a handy function to have.
  function fromFile( byref aPath as const string_t ) as string_t
    dim as string_t content = ""
    
    if( fileExists( aPath ) ) then
      dim as long fileHandle = freeFile()
      
      open aPath for binary access read as fileHandle
      
      '' Resize string to fit content
      content = space( lof( fileHandle ) )
      
      '' And get it all at once
      get #fileHandle, , content
      
      close( fileHandle )
    end if
    
    return( content )
  end function
end namespace

#endif
