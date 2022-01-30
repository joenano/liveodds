import strtabs
import strutils
import sugar
import xmltree

proc nodes(node: XmlNode, tag: string, recursive: bool): seq[XmlNode] =
  if recursive: node.findAll(tag)
  else: collect(for child in node: (if child.tag == tag: child))

proc nodeMatch(node: XmlNode, attribute, value: string): bool =
  if node.attrsLen > 0 and node.attrs.hasKey(attribute):
    result = value in node.attr(attribute).splitWhitespace()

proc elementsWithAttribue*(node: XmlNode, tag, attribute: string): seq[XmlNode] =
  for element in node.findAll(tag):
    if element.attrs.hasKey(attribute):
      result.add(element)

proc findElements*(node: XmlNode, tag, attribute, value: string, recursive: bool=true): seq[XmlNode] =
  for element in nodes(node, tag, recursive):
    if nodeMatch(element, attribute, value):
      result.add(element)

proc findElement*(node: XmlNode, tag, attribute, value: string, recursive: bool=true): XmlNode =
  for element in nodes(node, tag, recursive):
    if nodeMatch(element, attribute, value):
      result = element
      break
