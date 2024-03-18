#ifndef __FBXML_PARSE_CONTEXT__
#define __FBXML_PARSE_CONTEXT__

namespace Xml
  '' Forward declare the XmlParseContext type
  type as XmlParseContext __XmlParseContext
  
  /'
    Parsing functions prototype. They have to return the position at where
    they finished parsing, so the next parsing function can start immediately
    where the last one ended. This allows for 'chaining' of parsing functions,
    and to implement a very simple and generic parser (see the 'ParseTags()'
    function implementation for an example of such a parser).
  '/
  type as function( _
    byref as __XmlParseContext, _
    byval as XmlElement ptr, _
    byref as const string_t, _
    byref as const string_t, _
    as uinteger ) as uinteger _
  XmlParseFunction
  
  '' Just syntactic sugar/convenience for wiring up parsing functions
  #define asXmlParsingFunction( func ) cptr( XmlParseFunction, @func )
  
  /'
    Base class for Xml parsing contexts.
    
    It provides parsing functions with the subject string (which is the Xml
    text that is being parsed), the tags for the Xml markup (both start and
    end tags), and the parsing functions associated with them.
    
    These are exposed through properties to the client code, so you can very
    easily extend this class to custom-taylor the Xml parser (for example,
    to implement a validating Xml parser), or implement parsers for other
    Xml-based derived formats (such as SVG).
  '/
  type XmlParseContext extends Object
    public:
      declare constructor( byref as const string_t, parseFunctions() as XmlParseFunction )
      declare virtual destructor()
      
      declare property elementTag() as string_t ptr
      declare property closeTag() as string_t ptr
      declare property parseFunction() as XmlParseFunction ptr
      
      declare function getTagIndexAt( as uinteger ) as integer
      
      as string_t subject
      as uinteger _
        charPos = 1, _
        lineNumber = 1, _
        malformedCharPos, _
        malformedLineNumber
      as boolean isMalformed
      
    protected:
      declare constructor()
      
      as string_t _
        _elementTags( any ), _
        _closeTags( any )
      as XmlParseFunction _
        _parseFunctions( any )
  end type
  
  constructor XmlParseContext() : end constructor
  
  constructor XmlParseContext( byref aSubject as const string_t, parseFunctions() as XmlParseFunction )
    '' Wire up the parsing functions provided from the client code
    redim _parseFunctions( 0 to ubound( parseFunctions ) )
    
    for i as integer = 0 to ubound( parseFunctions )
      _parseFunctions( i ) = parseFunctions( i )
    next
    
    subject = aSubject
    
    /'
      Note that, due to how the index into these arrays are determined,
      the order of the tags does matter (otherwise, the 'getTagIndexAt()'
      will disambiguate them in the wrong order, giving wrong results;
      see the implementation of the aforementioned method to see how this
      works).
      
      Generally speaking, to correctly disambiguate between tags, simply
      put the longest tags before the shortest ones. For example, to
      disambiguate the Xml Comments tag ('<!--') from the Processing
      Instruction tag ('<!'), put the comments tag first on the array.
      That way, comments get tested first and, if they're not matched,
      matching continues to the next tag (that will indeed match if it
      is a Processing Instruction).
      
      This little quirk allows for a very simple and efficient matching
      mechanism for the tags.
      
      The order for the tags below corresponds to:
      
      Xml declaration            <?        ?>
      Xml CDATA block            <![CDATA[ ]]>
      Xml comment                <!--      -->
      Xml processing instruction <!        >
      Xml element                <         >
    '/
    redim _elementTags( 0 to 4 )
    
    _elementTags( 0 ) = "<?"
    _elementTags( 1 ) = "<![CDATA["
    _elementTags( 2 ) = "<!--"
    _elementTags( 3 ) = "<!"
    _elementTags( 4 ) = "<"
    
    redim _closeTags( 0 to 4 )
    
    _closeTags( 0 ) = "?>"
    _closeTags( 1 ) = "]]>"
    _closeTags( 2 ) = "-->"
    _closeTags( 3 ) = ">"
    _closeTags( 4 ) = ">"
  end constructor
  
  destructor XmlParseContext() : end destructor
  
  property XmlParseContext.elementTag() as string_t ptr
    return( @_elementTags( 0 ) )
  end property
  
  property XmlParseContext.closeTag() as string_t ptr
    return( @_closeTags( 0 ) )
  end property
  
  property XmlParseContext.parseFunction() as XmlParseFunction ptr
    return( @_parseFunctions( 0 ) )
  end property
  
  function XmlParseContext.getTagIndexAt( position as uinteger ) as integer
    dim as integer result = -1
    
    for i as integer = 0 to ubound( _elementTags )
      if( match( subject, _elementTags( i ), position ) ) then
        result = i
        exit for
      end if
    next
    
    return( result )
  end function
end namespace

#endif
