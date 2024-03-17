#ifndef __FBXML_DOCUMENT__
#define __FBXML_DOCUMENT__

'' Represents a Xml document
namespace Xml
  type XmlDocument extends Object
    public:
      declare constructor()
      declare virtual destructor()
      
      declare property documentElement() as XmlElement ptr
      declare property hasChildNodes() as boolean
      declare property malformed() as boolean
      
      declare sub loadXml( byref as const string_t )
      
    protected:
      declare virtual sub onLoadXml( byref as const string_t )
      declare virtual sub onParse( _
        byref as XmlParseContext, as XmlDocumentRoot ptr )
      
    private:
      as string_t _name
      as XmlDocumentRoot ptr _root
      as XmlElement ptr _documentElement
      as boolean _malformed
  end type
  
  constructor XmlDocument() : end constructor
  
  destructor XmlDocument()
    if( _root <> XmlNull ) then
      delete( _root )
    end if
  end destructor
  
  property XmlDocument.documentElement() as XmlElement ptr
    return( _documentElement )
  end property
  
  property XmlDocument.hasChildNodes() as boolean
    return( _root->hasChildNodes )
  end property
  
  property XmlDocument.malformed() as boolean
    return( _malformed )
  end property
  
  sub XmlDocument.loadXml( byref aString as const string_t )
    onLoadXml( aString )
  end sub
  
  sub XmlDocument.onLoadXml( byref aString as const string_t )
    '' Wire up the standard parsing functions into the context
    dim as XmlParseFunction _
      parsingFunctions( ... ) = { _
        asXmlParsingFunction( parseInstruction ), _
        asXmlParsingFunction( parseCDATA ), _
        asXmlParsingFunction( parseComment ), _
        asXmlParsingFunction( parseDeclaration ), _
        asXmlParsingFunction( parseElement ) }
    
    var aContext = XmlParseContext( aString, parsingFunctions() )
    
    if( _root <> XmlNull ) then
      delete( _root )
    end if
    
    _root = new XmlDocumentRoot()
    
    onParse( aContext, _root )
    
    _malformed = aContext.isMalformed
  end sub
  
  sub XmlDocument.onParse( _
    byref aContext as XmlParseContext, _
    aRootNode as XmlDocumentRoot ptr )
    
    dim as uinteger result = parseTags( aContext, aRootNode )
    
    _documentElement = aRootNode->getDocumentElement()
  end sub
end namespace

#endif
