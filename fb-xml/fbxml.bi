#ifndef __FBXML__
#define __FBXML__

/'
  Xml framework.
  
  10/28/2019
    Initial version. Very basic functionality (just reading a Xml document).
'/
namespace Xml
  const XmlNull = 0
  
  enum XmlNodeType
    Attribute
    CDATA
    Comment
    Declaration
    Document
    DocumentRoot
    Element
    None
    ProcessingInstruction
  end enum
  
  '' Abstract the string type (to be able to add Unicode support later)
  type as string string_t
end namespace

'' Base parser and interface
#include once "fbxml/fbxml-node.bi"
#include once "fbxml/fbxml-node-list.bi"
#include once "fbxml/fbxml-attribute.bi"
#include once "fbxml/fbxml-attribute-collection.bi"
#include once "fbxml/fbxml-element.bi"
#include once "fbxml/fbxml-document-root.bi"
#include once "fbxml/fbxml-parse-utils.bi"
#include once "fbxml/fbxml-parse-context.bi"
#include once "fbxml/fbxml-parse-functions.bi"
#include once "fbxml/fbxml-document.bi"
#include once "fbxml/fbxml-helper.bi"

#endif
