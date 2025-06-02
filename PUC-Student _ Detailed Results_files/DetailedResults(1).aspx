//START AjaxControlToolkit.Common.Common.js
Type.registerNamespace('AjaxControlToolkit');AjaxControlToolkit.BoxSide = function() {
}
AjaxControlToolkit.BoxSide.prototype = {
Top : 0,
Right : 1,
Bottom : 2,
Left : 3
}
AjaxControlToolkit.BoxSide.registerEnum("AjaxControlToolkit.BoxSide", false);AjaxControlToolkit._CommonToolkitScripts = function() {
}
AjaxControlToolkit._CommonToolkitScripts.prototype = {
_borderStyleNames : ["borderTopStyle","borderRightStyle","borderBottomStyle","borderLeftStyle"],
_borderWidthNames : ["borderTopWidth", "borderRightWidth", "borderBottomWidth", "borderLeftWidth"],
_paddingWidthNames : ["paddingTop", "paddingRight", "paddingBottom", "paddingLeft"],
_marginWidthNames : ["marginTop", "marginRight", "marginBottom", "marginLeft"],
getCurrentStyle : function(element, attribute, defaultValue) {
var currentValue = null;if (element) {
if (element.currentStyle) {
currentValue = element.currentStyle[attribute];} else if (document.defaultView && document.defaultView.getComputedStyle) {
var style = document.defaultView.getComputedStyle(element, null);if (style) {
currentValue = style[attribute];}
}
if (!currentValue && element.style.getPropertyValue) {
currentValue = element.style.getPropertyValue(attribute);}
else if (!currentValue && element.style.getAttribute) {
currentValue = element.style.getAttribute(attribute);} 
}
if ((!currentValue || currentValue == "" || typeof(currentValue) === 'undefined')) {
if (typeof(defaultValue) != 'undefined') {
currentValue = defaultValue;}
else {
currentValue = null;}
} 
return currentValue;},
getInheritedBackgroundColor : function(element) {
if (!element) return '#FFFFFF';var background = this.getCurrentStyle(element, 'backgroundColor');try {
while (!background || background == '' || background == 'transparent' || background == 'rgba(0, 0, 0, 0)') {
element = element.parentNode;if (!element) {
background = '#FFFFFF';} else {
background = this.getCurrentStyle(element, 'backgroundColor');}
}
} catch(ex) {
background = '#FFFFFF';}
return background;},
getLocation : function(element) {
if (element === document.documentElement) {
return new Sys.UI.Point(0,0);}
if (Sys.Browser.agent == Sys.Browser.InternetExplorer && Sys.Browser.version < 7) {
if (element.window === element || element.nodeType === 9 || !element.getClientRects || !element.getBoundingClientRect) return new Sys.UI.Point(0,0);var screenRects = element.getClientRects();if (!screenRects || !screenRects.length) {
return new Sys.UI.Point(0,0);}
var first = screenRects[0];var dLeft = 0;var dTop = 0;var inFrame = false;try {
inFrame = element.ownerDocument.parentWindow.frameElement;} catch(ex) {
inFrame = true;}
if (inFrame) {
var clientRect = element.getBoundingClientRect();if (!clientRect) {
return new Sys.UI.Point(0,0);}
var minLeft = first.left;var minTop = first.top;for (var i = 1;i < screenRects.length;i++) {
var r = screenRects[i];if (r.left < minLeft) {
minLeft = r.left;}
if (r.top < minTop) {
minTop = r.top;}
}
dLeft = minLeft - clientRect.left;dTop = minTop - clientRect.top;}
var ownerDocument = element.document.documentElement;return new Sys.UI.Point(first.left - 2 - dLeft + ownerDocument.scrollLeft, first.top - 2 - dTop + ownerDocument.scrollTop);}
return Sys.UI.DomElement.getLocation(element);},
setLocation : function(element, point) {
Sys.UI.DomElement.setLocation(element, point.x, point.y);},
getContentSize : function(element) {
if (!element) {
throw Error.argumentNull('element');}
var size = this.getSize(element);var borderBox = this.getBorderBox(element);var paddingBox = this.getPaddingBox(element);return {
width : size.width - borderBox.horizontal - paddingBox.horizontal,
height : size.height - borderBox.vertical - paddingBox.vertical
}
},
getSize : function(element) {
if (!element) {
throw Error.argumentNull('element');}
return {
width: element.offsetWidth,
height: element.offsetHeight
};},
setContentSize : function(element, size) {
if (!element) {
throw Error.argumentNull('element');}
if (!size) {
throw Error.argumentNull('size');}
if(this.getCurrentStyle(element, 'MozBoxSizing') == 'border-box' || this.getCurrentStyle(element, 'BoxSizing') == 'border-box') {
var borderBox = this.getBorderBox(element);var paddingBox = this.getPaddingBox(element);size = {
width: size.width + borderBox.horizontal + paddingBox.horizontal,
height: size.height + borderBox.vertical + paddingBox.vertical
};}
element.style.width = size.width.toString() + 'px';element.style.height = size.height.toString() + 'px';},
setSize : function(element, size) {
if (!element) {
throw Error.argumentNull('element');}
if (!size) {
throw Error.argumentNull('size');}
var borderBox = this.getBorderBox(element);var paddingBox = this.getPaddingBox(element);var contentSize = {
width: size.width - borderBox.horizontal - paddingBox.horizontal,
height: size.height - borderBox.vertical - paddingBox.vertical
};this.setContentSize(element, contentSize);},
getBounds : function(element) {
var offset = $common.getLocation(element);return new Sys.UI.Bounds(offset.x, offset.y, element.offsetWidth || 0, element.offsetHeight || 0);}, 
setBounds : function(element, bounds) {
if (!element) {
throw Error.argumentNull('element');}
if (!bounds) {
throw Error.argumentNull('bounds');}
this.setSize(element, bounds);$common.setLocation(element, bounds);},
getClientBounds : function() {
var clientWidth;var clientHeight;switch(Sys.Browser.agent) {
case Sys.Browser.InternetExplorer:
clientWidth = document.documentElement.clientWidth;clientHeight = document.documentElement.clientHeight;break;case Sys.Browser.Safari:
clientWidth = window.innerWidth;clientHeight = window.innerHeight;break;case Sys.Browser.Opera:
clientWidth = Math.min(window.innerWidth, document.body.clientWidth);clientHeight = Math.min(window.innerHeight, document.body.clientHeight);break;default: 
clientWidth = Math.min(window.innerWidth, document.documentElement.clientWidth);clientHeight = Math.min(window.innerHeight, document.documentElement.clientHeight);break;}
return new Sys.UI.Bounds(0, 0, clientWidth, clientHeight);},
getMarginBox : function(element) {
if (!element) {
throw Error.argumentNull('element');}
var box = {
top: this.getMargin(element, AjaxControlToolkit.BoxSide.Top),
right: this.getMargin(element, AjaxControlToolkit.BoxSide.Right),
bottom: this.getMargin(element, AjaxControlToolkit.BoxSide.Bottom),
left: this.getMargin(element, AjaxControlToolkit.BoxSide.Left)
};box.horizontal = box.left + box.right;box.vertical = box.top + box.bottom;return box;},
getBorderBox : function(element) {
if (!element) {
throw Error.argumentNull('element');}
var box = {
top: this.getBorderWidth(element, AjaxControlToolkit.BoxSide.Top),
right: this.getBorderWidth(element, AjaxControlToolkit.BoxSide.Right),
bottom: this.getBorderWidth(element, AjaxControlToolkit.BoxSide.Bottom),
left: this.getBorderWidth(element, AjaxControlToolkit.BoxSide.Left)
};box.horizontal = box.left + box.right;box.vertical = box.top + box.bottom;return box;},
getPaddingBox : function(element) {
if (!element) {
throw Error.argumentNull('element');}
var box = {
top: this.getPadding(element, AjaxControlToolkit.BoxSide.Top),
right: this.getPadding(element, AjaxControlToolkit.BoxSide.Right),
bottom: this.getPadding(element, AjaxControlToolkit.BoxSide.Bottom),
left: this.getPadding(element, AjaxControlToolkit.BoxSide.Left)
};box.horizontal = box.left + box.right;box.vertical = box.top + box.bottom;return box;},
isBorderVisible : function(element, boxSide) {
if (!element) {
throw Error.argumentNull('element');}
if(boxSide < AjaxControlToolkit.BoxSide.Top || boxSide > AjaxControlToolkit.BoxSide.Left) {
throw Error.argumentOutOfRange(String.format(Sys.Res.enumInvalidValue, boxSide, 'AjaxControlToolkit.BoxSide'));}
var styleName = this._borderStyleNames[boxSide];var styleValue = this.getCurrentStyle(element, styleName);return styleValue != "none";},
getMargin : function(element, boxSide) {
if (!element) {
throw Error.argumentNull('element');}
if(boxSide < AjaxControlToolkit.BoxSide.Top || boxSide > AjaxControlToolkit.BoxSide.Left) {
throw Error.argumentOutOfRange(String.format(Sys.Res.enumInvalidValue, boxSide, 'AjaxControlToolkit.BoxSide'));}
var styleName = this._marginWidthNames[boxSide];var styleValue = this.getCurrentStyle(element, styleName);try { return this.parsePadding(styleValue);} catch(ex) { return 0;}
},
getBorderWidth : function(element, boxSide) {
if (!element) {
throw Error.argumentNull('element');}
if(boxSide < AjaxControlToolkit.BoxSide.Top || boxSide > AjaxControlToolkit.BoxSide.Left) {
throw Error.argumentOutOfRange(String.format(Sys.Res.enumInvalidValue, boxSide, 'AjaxControlToolkit.BoxSide'));}
if(!this.isBorderVisible(element, boxSide)) {
return 0;} 
var styleName = this._borderWidthNames[boxSide];var styleValue = this.getCurrentStyle(element, styleName);return this.parseBorderWidth(styleValue);},
getPadding : function(element, boxSide) {
if (!element) {
throw Error.argumentNull('element');}
if(boxSide < AjaxControlToolkit.BoxSide.Top || boxSide > AjaxControlToolkit.BoxSide.Left) {
throw Error.argumentOutOfRange(String.format(Sys.Res.enumInvalidValue, boxSide, 'AjaxControlToolkit.BoxSide'));}
var styleName = this._paddingWidthNames[boxSide];var styleValue = this.getCurrentStyle(element, styleName);return this.parsePadding(styleValue);},
parseBorderWidth : function(borderWidth) {
if (!this._borderThicknesses) {
var borderThicknesses = { };var div0 = document.createElement('div');div0.style.visibility = 'hidden';div0.style.position = 'absolute';div0.style.fontSize = '1px';document.body.appendChild(div0)
var div1 = document.createElement('div');div1.style.height = '0px';div1.style.overflow = 'hidden';div0.appendChild(div1);var base = div0.offsetHeight;div1.style.borderTop = 'solid black';div1.style.borderTopWidth = 'thin';borderThicknesses['thin'] = div0.offsetHeight - base;div1.style.borderTopWidth = 'medium';borderThicknesses['medium'] = div0.offsetHeight - base;div1.style.borderTopWidth = 'thick';borderThicknesses['thick'] = div0.offsetHeight - base;div0.removeChild(div1);document.body.removeChild(div0);this._borderThicknesses = borderThicknesses;}
if (borderWidth) {
switch(borderWidth) {
case 'thin':
case 'medium':
case 'thick':
return this._borderThicknesses[borderWidth];case 'inherit':
return 0;}
var unit = this.parseUnit(borderWidth);Sys.Debug.assert(unit.type == 'px', String.format(AjaxControlToolkit.Resources.Common_InvalidBorderWidthUnit, unit.type));return unit.size;}
return 0;},
parsePadding : function(padding) {
if(padding) {
if(padding == 'inherit') {
return 0;}
var unit = this.parseUnit(padding);Sys.Debug.assert(unit.type == 'px', String.format(AjaxControlToolkit.Resources.Common_InvalidPaddingUnit, unit.type));return unit.size;}
return 0;},
parseUnit : function(value) {
if (!value) {
throw Error.argumentNull('value');}
value = value.trim().toLowerCase();var l = value.length;var s = -1;for(var i = 0;i < l;i++) {
var ch = value.substr(i, 1);if((ch < '0' || ch > '9') && ch != '-' && ch != '.' && ch != ',') {
break;}
s = i;}
if(s == -1) {
throw Error.create(AjaxControlToolkit.Resources.Common_UnitHasNoDigits);}
var type;var size;if(s < (l - 1)) {
type = value.substring(s + 1).trim();} else {
type = 'px';}
size = parseFloat(value.substr(0, s + 1));if(type == 'px') {
size = Math.floor(size);}
return { 
size: size,
type: type
};},
getElementOpacity : function(element) {
if (!element) {
throw Error.argumentNull('element');}
var hasOpacity = false;var opacity;if (element.filters) {
var filters = element.filters;if (filters.length !== 0) {
var alphaFilter = filters['DXImageTransform.Microsoft.Alpha'];if (alphaFilter) {
opacity = alphaFilter.opacity / 100.0;hasOpacity = true;}
}
}
else {
opacity = this.getCurrentStyle(element, 'opacity', 1);hasOpacity = true;}
if (hasOpacity === false) {
return 1.0;}
return parseFloat(opacity);},
setElementOpacity : function(element, value) {
if (!element) {
throw Error.argumentNull('element');}
if (element.filters) {
var filters = element.filters;var createFilter = true;if (filters.length !== 0) {
var alphaFilter = filters['DXImageTransform.Microsoft.Alpha'];if (alphaFilter) {
createFilter = false;alphaFilter.opacity = value * 100;}
}
if (createFilter) {
element.style.filter = 'progid:DXImageTransform.Microsoft.Alpha(opacity=' + (value * 100) + ')';}
}
else {
element.style.opacity = value;}
},
getVisible : function(element) {
return (element &&
("none" != $common.getCurrentStyle(element, "display")) &&
("hidden" != $common.getCurrentStyle(element, "visibility")));},
setVisible : function(element, value) {
if (element && value != $common.getVisible(element)) {
if (value) {
if (element.style.removeAttribute) {
element.style.removeAttribute("display");} else {
element.style.removeProperty("display");}
} else {
element.style.display = 'none';}
element.style.visibility = value ? 'visible' : 'hidden';}
},
resolveFunction : function(value) {
if (value) {
if (value instanceof Function) {
return value;} else if (String.isInstanceOfType(value) && value.length > 0) {
var func;if ((func = window[value]) instanceof Function) {
return func;} else if ((func = eval(value)) instanceof Function) {
return func;}
}
}
return null;},
addCssClasses : function(element, classNames) {
for(var i = 0;i < classNames.length;i++) {
Sys.UI.DomElement.addCssClass(element, classNames[i]);}
},
removeCssClasses : function(element, classNames) {
for(var i = 0;i < classNames.length;i++) {
Sys.UI.DomElement.removeCssClass(element, classNames[i]);}
},
setStyle : function(element, style) {
$common.applyProperties(element.style, style);},
removeHandlers : function(element, events) {
for (var name in events) {
$removeHandler(element, name, events[name]);}
},
overlaps : function(r1, r2) {
return r1.x < (r2.x + r2.width)
&& r2.x < (r1.x + r1.width)
&& r1.y < (r2.y + r2.height)
&& r2.y < (r1.y + r1.height);},
containsPoint : function(rect, x, y) {
return x >= rect.x && x < (rect.x + rect.width) && y >= rect.y && y < (rect.y + rect.height);},
isKeyDigit : function(keyCode) { 
return (0x30 <= keyCode && keyCode <= 0x39);},
isKeyNavigation : function(keyCode) { 
return (Sys.UI.Key.left <= keyCode && keyCode <= Sys.UI.Key.down);},
padLeft : function(text, size, ch, truncate) { 
return $common._pad(text, size || 2, ch || ' ', 'l', truncate || false);},
padRight : function(text, size, ch, truncate) { 
return $common._pad(text, size || 2, ch || ' ', 'r', truncate || false);},
_pad : function(text, size, ch, side, truncate) {
text = text.toString();var length = text.length;var builder = new Sys.StringBuilder();if (side == 'r') {
builder.append(text);} 
while (length < size) {
builder.append(ch);length++;}
if (side == 'l') {
builder.append(text);}
var result = builder.toString();if (truncate && result.length > size) {
if (side == 'l') {
result = result.substr(result.length - size, size);} else {
result = result.substr(0, size);}
}
return result;},
__DOMEvents : {
focusin : { eventGroup : "UIEvents", init : function(e, p) { e.initUIEvent("focusin", true, false, window, 1);} },
focusout : { eventGroup : "UIEvents", init : function(e, p) { e.initUIEvent("focusout", true, false, window, 1);} },
activate : { eventGroup : "UIEvents", init : function(e, p) { e.initUIEvent("activate", true, true, window, 1);} },
focus : { eventGroup : "UIEvents", init : function(e, p) { e.initUIEvent("focus", false, false, window, 1);} },
blur : { eventGroup : "UIEvents", init : function(e, p) { e.initUIEvent("blur", false, false, window, 1);} },
click : { eventGroup : "MouseEvents", init : function(e, p) { e.initMouseEvent("click", true, true, window, 1, p.screenX || 0, p.screenY || 0, p.clientX || 0, p.clientY || 0, p.ctrlKey || false, p.altKey || false, p.shiftKey || false, p.metaKey || false, p.button || 0, p.relatedTarget || null);} },
dblclick : { eventGroup : "MouseEvents", init : function(e, p) { e.initMouseEvent("click", true, true, window, 2, p.screenX || 0, p.screenY || 0, p.clientX || 0, p.clientY || 0, p.ctrlKey || false, p.altKey || false, p.shiftKey || false, p.metaKey || false, p.button || 0, p.relatedTarget || null);} },
mousedown : { eventGroup : "MouseEvents", init : function(e, p) { e.initMouseEvent("mousedown", true, true, window, 1, p.screenX || 0, p.screenY || 0, p.clientX || 0, p.clientY || 0, p.ctrlKey || false, p.altKey || false, p.shiftKey || false, p.metaKey || false, p.button || 0, p.relatedTarget || null);} },
mouseup : { eventGroup : "MouseEvents", init : function(e, p) { e.initMouseEvent("mouseup", true, true, window, 1, p.screenX || 0, p.screenY || 0, p.clientX || 0, p.clientY || 0, p.ctrlKey || false, p.altKey || false, p.shiftKey || false, p.metaKey || false, p.button || 0, p.relatedTarget || null);} },
mouseover : { eventGroup : "MouseEvents", init : function(e, p) { e.initMouseEvent("mouseover", true, true, window, 1, p.screenX || 0, p.screenY || 0, p.clientX || 0, p.clientY || 0, p.ctrlKey || false, p.altKey || false, p.shiftKey || false, p.metaKey || false, p.button || 0, p.relatedTarget || null);} },
mousemove : { eventGroup : "MouseEvents", init : function(e, p) { e.initMouseEvent("mousemove", true, true, window, 1, p.screenX || 0, p.screenY || 0, p.clientX || 0, p.clientY || 0, p.ctrlKey || false, p.altKey || false, p.shiftKey || false, p.metaKey || false, p.button || 0, p.relatedTarget || null);} },
mouseout : { eventGroup : "MouseEvents", init : function(e, p) { e.initMouseEvent("mousemove", true, true, window, 1, p.screenX || 0, p.screenY || 0, p.clientX || 0, p.clientY || 0, p.ctrlKey || false, p.altKey || false, p.shiftKey || false, p.metaKey || false, p.button || 0, p.relatedTarget || null);} },
load : { eventGroup : "HTMLEvents", init : function(e, p) { e.initEvent("load", false, false);} },
unload : { eventGroup : "HTMLEvents", init : function(e, p) { e.initEvent("unload", false, false);} },
select : { eventGroup : "HTMLEvents", init : function(e, p) { e.initEvent("select", true, false);} },
change : { eventGroup : "HTMLEvents", init : function(e, p) { e.initEvent("change", true, false);} },
submit : { eventGroup : "HTMLEvents", init : function(e, p) { e.initEvent("submit", true, true);} },
reset : { eventGroup : "HTMLEvents", init : function(e, p) { e.initEvent("reset", true, false);} },
resize : { eventGroup : "HTMLEvents", init : function(e, p) { e.initEvent("resize", true, false);} },
scroll : { eventGroup : "HTMLEvents", init : function(e, p) { e.initEvent("scroll", true, false);} }
},
tryFireRawEvent : function(element, rawEvent) {
try {
if (element.fireEvent) {
element.fireEvent("on" + rawEvent.type, rawEvent);return true;} else if (element.dispatchEvent) {
element.dispatchEvent(rawEvent);return true;}
} catch (e) {
}
return false;}, 
tryFireEvent : function(element, eventName, properties) {
try {
if (document.createEventObject) {
var e = document.createEventObject();$common.applyProperties(e, properties || {});element.fireEvent("on" + eventName, e);return true;} else if (document.createEvent) {
var def = $common.__DOMEvents[eventName];if (def) {
var e = document.createEvent(def.eventGroup);def.init(e, properties || {});element.dispatchEvent(e);return true;}
}
} catch (e) {
}
return false;},
wrapElement : function(innerElement, newOuterElement, newInnerParentElement) {
var parent = innerElement.parentNode;parent.replaceChild(newOuterElement, innerElement);(newInnerParentElement || newOuterElement).appendChild(innerElement);},
unwrapElement : function(innerElement, oldOuterElement) {
var parent = oldOuterElement.parentNode;if (parent != null) {
$common.removeElement(innerElement);parent.replaceChild(innerElement, oldOuterElement);}
},
removeElement : function(element) {
var parent = element.parentNode;if (parent != null) {
parent.removeChild(element);}
},
applyProperties : function(target, properties) {
for (var p in properties) {
var pv = properties[p];if (pv != null && Object.getType(pv)===Object) {
var tv = target[p];$common.applyProperties(tv, pv);} else {
target[p] = pv;}
}
},
createElementFromTemplate : function(template, appendToParent, nameTable) {
if (typeof(template.nameTable)!='undefined') {
var newNameTable = template.nameTable;if (String.isInstanceOfType(newNameTable)) {
newNameTable = nameTable[newNameTable];}
if (newNameTable != null) {
nameTable = newNameTable;}
}
var elementName = null;if (typeof(template.name)!=='undefined') {
elementName = template.name;}
var elt = document.createElement(template.nodeName);if (typeof(template.name)!=='undefined' && nameTable) {
nameTable[template.name] = elt;}
if (typeof(template.parent)!=='undefined' && appendToParent == null) {
var newParent = template.parent;if (String.isInstanceOfType(newParent)) {
newParent = nameTable[newParent];}
if (newParent != null) {
appendToParent = newParent;}
}
if (typeof(template.properties)!=='undefined' && template.properties != null) {
$common.applyProperties(elt, template.properties);}
if (typeof(template.cssClasses)!=='undefined' && template.cssClasses != null) {
$common.addCssClasses(elt, template.cssClasses);}
if (typeof(template.events)!=='undefined' && template.events != null) {
$addHandlers(elt, template.events);}
if (typeof(template.visible)!=='undefined' && template.visible != null) {
this.setVisible(elt, template.visible);}
if (appendToParent) {
appendToParent.appendChild(elt);}
if (typeof(template.opacity)!=='undefined' && template.opacity != null) {
$common.setElementOpacity(elt, template.opacity);}
if (typeof(template.children)!=='undefined' && template.children != null) {
for (var i = 0;i < template.children.length;i++) {
var subtemplate = template.children[i];$common.createElementFromTemplate(subtemplate, elt, nameTable);}
}
var contentPresenter = elt;if (typeof(template.contentPresenter)!=='undefined' && template.contentPresenter != null) {
contentPresenter = nameTable[contentPresenter];}
if (typeof(template.content)!=='undefined' && template.content != null) {
var content = template.content;if (String.isInstanceOfType(content)) {
content = nameTable[content];}
if (content.parentNode) {
$common.wrapElement(content, elt, contentPresenter);} else {
contentPresenter.appendChild(content);}
}
return elt;},
prepareHiddenElementForATDeviceUpdate : function () {
var objHidden = document.getElementById('hiddenInputToUpdateATBuffer_CommonToolkitScripts');if (!objHidden) {
var objHidden = document.createElement('input');objHidden.setAttribute('type', 'hidden');objHidden.setAttribute('value', '1');objHidden.setAttribute('id', 'hiddenInputToUpdateATBuffer_CommonToolkitScripts');objHidden.setAttribute('name', 'hiddenInputToUpdateATBuffer_CommonToolkitScripts');if ( document.forms[0] ) {
document.forms[0].appendChild(objHidden);}
}
},
updateFormToRefreshATDeviceBuffer : function () {
var objHidden = document.getElementById('hiddenInputToUpdateATBuffer_CommonToolkitScripts');if (objHidden) {
if (objHidden.getAttribute('value') == '1') {
objHidden.setAttribute('value', '0');} else {
objHidden.setAttribute('value', '1');}
}
}
}
var CommonToolkitScripts = AjaxControlToolkit.CommonToolkitScripts = new AjaxControlToolkit._CommonToolkitScripts();var $common = CommonToolkitScripts;Sys.UI.DomElement.getVisible = $common.getVisible;Sys.UI.DomElement.setVisible = $common.setVisible;Sys.UI.Control.overlaps = $common.overlaps;AjaxControlToolkit._DomUtility = function() {
}
AjaxControlToolkit._DomUtility.prototype = {
isDescendant : function(ancestor, descendant) {
for (var n = descendant.parentNode;n != null;n = n.parentNode) {
if (n == ancestor) return true;}
return false;},
isDescendantOrSelf : function(ancestor, descendant) {
if (ancestor === descendant) 
return true;return AjaxControlToolkit.DomUtility.isDescendant(ancestor, descendant);},
isAncestor : function(descendant, ancestor) {
return AjaxControlToolkit.DomUtility.isDescendant(ancestor, descendant);},
isAncestorOrSelf : function(descendant, ancestor) {
if (descendant === ancestor)
return true;return AjaxControlToolkit.DomUtility.isDescendant(ancestor, descendant);},
isSibling : function(self, sibling) {
var parent = self.parentNode;for (var i = 0;i < parent.childNodes.length;i++) {
if (parent.childNodes[i] == sibling) return true;}
return false;}
}
AjaxControlToolkit._DomUtility.registerClass("AjaxControlToolkit._DomUtility");AjaxControlToolkit.DomUtility = new AjaxControlToolkit._DomUtility();AjaxControlToolkit.TextBoxWrapper = function(element) {
AjaxControlToolkit.TextBoxWrapper.initializeBase(this, [element]);this._current = element.value;this._watermark = null;this._isWatermarked = false;}
AjaxControlToolkit.TextBoxWrapper.prototype = {
dispose : function() {
this.get_element().AjaxControlToolkitTextBoxWrapper = null;AjaxControlToolkit.TextBoxWrapper.callBaseMethod(this, 'dispose');},
get_Current : function() {
this._current = this.get_element().value;return this._current;},
set_Current : function(value) {
this._current = value;this._updateElement();},
get_Value : function() {
if (this.get_IsWatermarked()) {
return "";} else {
return this.get_Current();}
},
set_Value : function(text) {
this.set_Current(text);if (!text || (0 == text.length)) {
if (null != this._watermark) {
this.set_IsWatermarked(true);}
} else {
this.set_IsWatermarked(false);}
},
get_Watermark : function() {
return this._watermark;},
set_Watermark : function(value) {
this._watermark = value;this._updateElement();},
get_IsWatermarked : function() {
return this._isWatermarked;},
set_IsWatermarked : function(isWatermarked) {
if (this._isWatermarked != isWatermarked) {
this._isWatermarked = isWatermarked;this._updateElement();this._raiseWatermarkChanged();}
},
_updateElement : function() {
var element = this.get_element();if (this._isWatermarked) {
if (element.value != this._watermark) {
element.value = this._watermark;}
} else {
if (element.value != this._current) {
element.value = this._current;}
}
},
add_WatermarkChanged : function(handler) {
this.get_events().addHandler("WatermarkChanged", handler);},
remove_WatermarkChanged : function(handler) {
this.get_events().removeHandler("WatermarkChanged", handler);},
_raiseWatermarkChanged : function() {
var onWatermarkChangedHandler = this.get_events().getHandler("WatermarkChanged");if (onWatermarkChangedHandler) {
onWatermarkChangedHandler(this, Sys.EventArgs.Empty);}
}
}
AjaxControlToolkit.TextBoxWrapper.get_Wrapper = function(element) {
if (null == element.AjaxControlToolkitTextBoxWrapper) {
element.AjaxControlToolkitTextBoxWrapper = new AjaxControlToolkit.TextBoxWrapper(element);}
return element.AjaxControlToolkitTextBoxWrapper;}
AjaxControlToolkit.TextBoxWrapper.registerClass('AjaxControlToolkit.TextBoxWrapper', Sys.UI.Behavior);AjaxControlToolkit.TextBoxWrapper.validatorGetValue = function(id) {
var control = $get(id);if (control && control.AjaxControlToolkitTextBoxWrapper) {
return control.AjaxControlToolkitTextBoxWrapper.get_Value();}
return AjaxControlToolkit.TextBoxWrapper._originalValidatorGetValue(id);}
if (typeof(ValidatorGetValue) == 'function') {
AjaxControlToolkit.TextBoxWrapper._originalValidatorGetValue = ValidatorGetValue;ValidatorGetValue = AjaxControlToolkit.TextBoxWrapper.validatorGetValue;}
if (Sys.CultureInfo.prototype._getAbbrMonthIndex) {
try {
Sys.CultureInfo.prototype._getAbbrMonthIndex('');} catch(ex) {
Sys.CultureInfo.prototype._getAbbrMonthIndex = function(value) {
if (!this._upperAbbrMonths) {
this._upperAbbrMonths = this._toUpperArray(this.dateTimeFormat.AbbreviatedMonthNames);}
return Array.indexOf(this._upperAbbrMonths, this._toUpper(value));}
Sys.CultureInfo.CurrentCulture._getAbbrMonthIndex = Sys.CultureInfo.prototype._getAbbrMonthIndex;Sys.CultureInfo.InvariantCulture._getAbbrMonthIndex = Sys.CultureInfo.prototype._getAbbrMonthIndex;}
}

//END AjaxControlToolkit.Common.Common.js
//START AjaxControlToolkit.ExtenderBase.BaseScripts.js
Type.registerNamespace('AjaxControlToolkit');AjaxControlToolkit.BehaviorBase = function(element) {
AjaxControlToolkit.BehaviorBase.initializeBase(this,[element]);this._clientStateFieldID = null;this._pageRequestManager = null;this._partialUpdateBeginRequestHandler = null;this._partialUpdateEndRequestHandler = null;}
AjaxControlToolkit.BehaviorBase.prototype = {
initialize : function() {
AjaxControlToolkit.BehaviorBase.callBaseMethod(this, 'initialize');},
dispose : function() {
AjaxControlToolkit.BehaviorBase.callBaseMethod(this, 'dispose');if (this._pageRequestManager) {
if (this._partialUpdateBeginRequestHandler) {
this._pageRequestManager.remove_beginRequest(this._partialUpdateBeginRequestHandler);this._partialUpdateBeginRequestHandler = null;}
if (this._partialUpdateEndRequestHandler) {
this._pageRequestManager.remove_endRequest(this._partialUpdateEndRequestHandler);this._partialUpdateEndRequestHandler = null;}
this._pageRequestManager = null;}
},
get_ClientStateFieldID : function() {
return this._clientStateFieldID;},
set_ClientStateFieldID : function(value) {
if (this._clientStateFieldID != value) {
this._clientStateFieldID = value;this.raisePropertyChanged('ClientStateFieldID');}
},
get_ClientState : function() {
if (this._clientStateFieldID) {
var input = document.getElementById(this._clientStateFieldID);if (input) {
return input.value;}
}
return null;},
set_ClientState : function(value) {
if (this._clientStateFieldID) {
var input = document.getElementById(this._clientStateFieldID);if (input) {
input.value = value;}
}
},
registerPartialUpdateEvents : function() {
if (Sys && Sys.WebForms && Sys.WebForms.PageRequestManager){
this._pageRequestManager = Sys.WebForms.PageRequestManager.getInstance();if (this._pageRequestManager) {
this._partialUpdateBeginRequestHandler = Function.createDelegate(this, this._partialUpdateBeginRequest);this._pageRequestManager.add_beginRequest(this._partialUpdateBeginRequestHandler);this._partialUpdateEndRequestHandler = Function.createDelegate(this, this._partialUpdateEndRequest);this._pageRequestManager.add_endRequest(this._partialUpdateEndRequestHandler);}
}
},
_partialUpdateBeginRequest : function(sender, beginRequestEventArgs) {
},
_partialUpdateEndRequest : function(sender, endRequestEventArgs) {
}
}
AjaxControlToolkit.BehaviorBase.registerClass('AjaxControlToolkit.BehaviorBase', Sys.UI.Behavior);AjaxControlToolkit.DynamicPopulateBehaviorBase = function(element) {
AjaxControlToolkit.DynamicPopulateBehaviorBase.initializeBase(this, [element]);this._DynamicControlID = null;this._DynamicContextKey = null;this._DynamicServicePath = null;this._DynamicServiceMethod = null;this._cacheDynamicResults = false;this._dynamicPopulateBehavior = null;this._populatingHandler = null;this._populatedHandler = null;}
AjaxControlToolkit.DynamicPopulateBehaviorBase.prototype = {
initialize : function() {
AjaxControlToolkit.DynamicPopulateBehaviorBase.callBaseMethod(this, 'initialize');this._populatingHandler = Function.createDelegate(this, this._onPopulating);this._populatedHandler = Function.createDelegate(this, this._onPopulated);},
dispose : function() {
if (this._populatedHandler) {
if (this._dynamicPopulateBehavior) {
this._dynamicPopulateBehavior.remove_populated(this._populatedHandler);}
this._populatedHandler = null;}
if (this._populatingHandler) {
if (this._dynamicPopulateBehavior) {
this._dynamicPopulateBehavior.remove_populating(this._populatingHandler);}
this._populatingHandler = null;}
if (this._dynamicPopulateBehavior) {
this._dynamicPopulateBehavior.dispose();this._dynamicPopulateBehavior = null;}
AjaxControlToolkit.DynamicPopulateBehaviorBase.callBaseMethod(this, 'dispose');},
populate : function(contextKeyOverride) {
if (this._dynamicPopulateBehavior && (this._dynamicPopulateBehavior.get_element() != $get(this._DynamicControlID))) {
this._dynamicPopulateBehavior.dispose();this._dynamicPopulateBehavior = null;}
if (!this._dynamicPopulateBehavior && this._DynamicControlID && this._DynamicServiceMethod) {
this._dynamicPopulateBehavior = $create(AjaxControlToolkit.DynamicPopulateBehavior,
{
"id" : this.get_id() + "_DynamicPopulateBehavior",
"ContextKey" : this._DynamicContextKey,
"ServicePath" : this._DynamicServicePath,
"ServiceMethod" : this._DynamicServiceMethod,
"cacheDynamicResults" : this._cacheDynamicResults
}, null, null, $get(this._DynamicControlID));this._dynamicPopulateBehavior.add_populating(this._populatingHandler);this._dynamicPopulateBehavior.add_populated(this._populatedHandler);}
if (this._dynamicPopulateBehavior) {
this._dynamicPopulateBehavior.populate(contextKeyOverride ? contextKeyOverride : this._DynamicContextKey);}
},
_onPopulating : function(sender, eventArgs) {
this.raisePopulating(eventArgs);},
_onPopulated : function(sender, eventArgs) {
this.raisePopulated(eventArgs);},
get_dynamicControlID : function() {
return this._DynamicControlID;},
get_DynamicControlID : this.get_dynamicControlID,
set_dynamicControlID : function(value) {
if (this._DynamicControlID != value) {
this._DynamicControlID = value;this.raisePropertyChanged('dynamicControlID');this.raisePropertyChanged('DynamicControlID');}
},
set_DynamicControlID : this.set_dynamicControlID,
get_dynamicContextKey : function() {
return this._DynamicContextKey;},
get_DynamicContextKey : this.get_dynamicContextKey,
set_dynamicContextKey : function(value) {
if (this._DynamicContextKey != value) {
this._DynamicContextKey = value;this.raisePropertyChanged('dynamicContextKey');this.raisePropertyChanged('DynamicContextKey');}
},
set_DynamicContextKey : this.set_dynamicContextKey,
get_dynamicServicePath : function() {
return this._DynamicServicePath;},
get_DynamicServicePath : this.get_dynamicServicePath,
set_dynamicServicePath : function(value) {
if (this._DynamicServicePath != value) {
this._DynamicServicePath = value;this.raisePropertyChanged('dynamicServicePath');this.raisePropertyChanged('DynamicServicePath');}
},
set_DynamicServicePath : this.set_dynamicServicePath,
get_dynamicServiceMethod : function() {
return this._DynamicServiceMethod;},
get_DynamicServiceMethod : this.get_dynamicServiceMethod,
set_dynamicServiceMethod : function(value) {
if (this._DynamicServiceMethod != value) {
this._DynamicServiceMethod = value;this.raisePropertyChanged('dynamicServiceMethod');this.raisePropertyChanged('DynamicServiceMethod');}
},
set_DynamicServiceMethod : this.set_dynamicServiceMethod,
get_cacheDynamicResults : function() {
return this._cacheDynamicResults;},
set_cacheDynamicResults : function(value) {
if (this._cacheDynamicResults != value) {
this._cacheDynamicResults = value;this.raisePropertyChanged('cacheDynamicResults');}
},
add_populated : function(handler) {
this.get_events().addHandler("populated", handler);},
remove_populated : function(handler) {
this.get_events().removeHandler("populated", handler);},
raisePopulated : function(arg) {
var handler = this.get_events().getHandler("populated");if (handler) handler(this, arg);},
add_populating : function(handler) {
this.get_events().addHandler('populating', handler);},
remove_populating : function(handler) {
this.get_events().removeHandler('populating', handler);},
raisePopulating : function(eventArgs) {
var handler = this.get_events().getHandler('populating');if (handler) {
handler(this, eventArgs);}
}
}
AjaxControlToolkit.DynamicPopulateBehaviorBase.registerClass('AjaxControlToolkit.DynamicPopulateBehaviorBase', AjaxControlToolkit.BehaviorBase);AjaxControlToolkit.ControlBase = function(element) {
AjaxControlToolkit.ControlBase.initializeBase(this, [element]);this._clientStateField = null;this._callbackTarget = null;this._onsubmit$delegate = Function.createDelegate(this, this._onsubmit);this._oncomplete$delegate = Function.createDelegate(this, this._oncomplete);this._onerror$delegate = Function.createDelegate(this, this._onerror);}
AjaxControlToolkit.ControlBase.prototype = {
initialize : function() {
AjaxControlToolkit.ControlBase.callBaseMethod(this, "initialize");if (this._clientStateField) {
this.loadClientState(this._clientStateField.value);}
if (typeof(Sys.WebForms)!=="undefined" && typeof(Sys.WebForms.PageRequestManager)!=="undefined") {
Array.add(Sys.WebForms.PageRequestManager.getInstance()._onSubmitStatements, this._onsubmit$delegate);} else {
$addHandler(document.forms[0], "submit", this._onsubmit$delegate);}
},
dispose : function() {
if (typeof(Sys.WebForms)!=="undefined" && typeof(Sys.WebForms.PageRequestManager)!=="undefined") {
Array.remove(Sys.WebForms.PageRequestManager.getInstance()._onSubmitStatements, this._onsubmit$delegate);} else {
$removeHandler(document.forms[0], "submit", this._onsubmit$delegate);}
AjaxControlToolkit.ControlBase.callBaseMethod(this, "dispose");},
findElement : function(id) {
return $get(this.get_id() + '_' + id.split(':').join('_'));},
get_clientStateField : function() {
return this._clientStateField;},
set_clientStateField : function(value) {
if (this.get_isInitialized()) throw Error.invalidOperation(AjaxControlToolkit.Resources.ExtenderBase_CannotSetClientStateField);if (this._clientStateField != value) {
this._clientStateField = value;this.raisePropertyChanged('clientStateField');}
},
loadClientState : function(value) {
},
saveClientState : function() {
return null;},
_invoke : function(name, args, cb) {
if (!this._callbackTarget) {
throw Error.invalidOperation(AjaxControlToolkit.Resources.ExtenderBase_ControlNotRegisteredForCallbacks);}
if (typeof(WebForm_DoCallback)==="undefined") {
throw Error.invalidOperation(AjaxControlToolkit.Resources.ExtenderBase_PageNotRegisteredForCallbacks);}
var ar = [];for (var i = 0;i < args.length;i++) 
ar[i] = args[i];var clientState = this.saveClientState();if (clientState != null && !String.isInstanceOfType(clientState)) {
throw Error.invalidOperation(AjaxControlToolkit.Resources.ExtenderBase_InvalidClientStateType);}
var payload = Sys.Serialization.JavaScriptSerializer.serialize({name:name,args:ar,state:this.saveClientState()});WebForm_DoCallback(this._callbackTarget, payload, this._oncomplete$delegate, cb, this._onerror$delegate, true);},
_oncomplete : function(result, context) {
result = Sys.Serialization.JavaScriptSerializer.deserialize(result);if (result.error) {
throw Error.create(result.error);}
this.loadClientState(result.state);context(result.result);},
_onerror : function(message, context) {
throw Error.create(message);},
_onsubmit : function() {
if (this._clientStateField) {
this._clientStateField.value = this.saveClientState();}
return true;} 
}
AjaxControlToolkit.ControlBase.registerClass("AjaxControlToolkit.ControlBase", Sys.UI.Control);
AjaxControlToolkit.Resources={
"PasswordStrength_InvalidWeightingRatios":"Strength Weighting ratios must have 4 elements","Animation_ChildrenNotAllowed":"AjaxControlToolkit.Animation.createAnimation cannot add child animations to type \"{0}\" that does not derive from AjaxControlToolkit.Animation.ParentAnimation","PasswordStrength_RemainingSymbols":"{0} symbol characters","ExtenderBase_CannotSetClientStateField":"clientStateField can only be set before initialization","RTE_PreviewHTML":"Preview HTML","RTE_JustifyCenter":"Justify Center","PasswordStrength_RemainingUpperCase":"{0} more upper case characters","Animation_TargetNotFound":"AjaxControlToolkit.Animation.Animation.set_animationTarget requires the ID of a Sys.UI.DomElement or Sys.UI.Control.  No element or control could be found corresponding to \"{0}\"","RTE_FontColor":"Font Color","RTE_LabelColor":"Label Color","Common_InvalidBorderWidthUnit":"A unit type of \"{0}\"\u0027 is invalid for parseBorderWidth","RTE_Heading":"Heading","Tabs_PropertySetBeforeInitialization":"{0} cannot be changed before initialization","RTE_OrderedList":"Ordered List","ReorderList_DropWatcherBehavior_NoChild":"Could not find child of list with id \"{0}\"","CascadingDropDown_MethodTimeout":"[Method timeout]","RTE_Columns":"Columns","RTE_InsertImage":"Insert Image","RTE_InsertTable":"Insert Table","RTE_Values":"Values","RTE_OK":"OK","ExtenderBase_PageNotRegisteredForCallbacks":"This Page has not been registered for callbacks","Animation_NoDynamicPropertyFound":"AjaxControlToolkit.Animation.createAnimation found no property corresponding to \"{0}\" or \"{1}\"","Animation_InvalidBaseType":"AjaxControlToolkit.Animation.registerAnimation can only register types that inherit from AjaxControlToolkit.Animation.Animation","RTE_UnorderedList":"Unordered List","ResizableControlBehavior_InvalidHandler":"{0} handler not a function, function name, or function text","Animation_InvalidColor":"Color must be a 7-character hex representation (e.g. #246ACF), not \"{0}\"","RTE_CellColor":"Cell Color","PasswordStrength_RemainingMixedCase":"Mixed case characters","RTE_Italic":"Italic","CascadingDropDown_NoParentElement":"Failed to find parent element \"{0}\"","ValidatorCallout_DefaultErrorMessage":"This control is invalid","RTE_Indent":"Indent","ReorderList_DropWatcherBehavior_CallbackError":"Reorder failed, see details below.\\r\\n\\r\\n{0}","PopupControl_NoDefaultProperty":"No default property supported for control \"{0}\" of type \"{1}\"","RTE_Normal":"Normal","PopupExtender_NoParentElement":"Couldn\u0027t find parent element \"{0}\"","RTE_ViewValues":"View Values","RTE_Legend":"Legend","RTE_Labels":"Labels","RTE_CellSpacing":"Cell Spacing","PasswordStrength_RemainingNumbers":"{0} more numbers","RTE_Border":"Border","RTE_Create":"Create","RTE_BackgroundColor":"Background Color","RTE_Cancel":"Cancel","RTE_JustifyFull":"Justify Full","RTE_JustifyLeft":"Justify Left","RTE_Cut":"Cut","ResizableControlBehavior_CannotChangeProperty":"Changes to {0} not supported","RTE_ViewSource":"View Source","Common_InvalidPaddingUnit":"A unit type of \"{0}\" is invalid for parsePadding","RTE_Paste":"Paste","ExtenderBase_ControlNotRegisteredForCallbacks":"This Control has not been registered for callbacks","Calendar_Today":"Today: {0}","Common_DateTime_InvalidFormat":"Invalid format","ListSearch_DefaultPrompt":"Type to search","CollapsiblePanel_NoControlID":"Failed to find element \"{0}\"","RTE_ViewEditor":"View Editor","RTE_BarColor":"Bar Color","PasswordStrength_DefaultStrengthDescriptions":"NonExistent;Very Weak;Weak;Poor;Almost OK;Barely Acceptable;Average;Good;Strong;Excellent;Unbreakable!","RTE_Inserttexthere":"Insert text here","Animation_UknownAnimationName":"AjaxControlToolkit.Animation.createAnimation could not find an Animation corresponding to the name \"{0}\"","ExtenderBase_InvalidClientStateType":"saveClientState must return a value of type String","Rating_CallbackError":"An unhandled exception has occurred:\\r\\n{0}","Tabs_OwnerExpected":"owner must be set before initialize","DynamicPopulate_WebServiceTimeout":"Web service call timed out","PasswordStrength_RemainingLowerCase":"{0} more lower case characters","Animation_MissingAnimationName":"AjaxControlToolkit.Animation.createAnimation requires an object with an AnimationName property","RTE_JustifyRight":"Justify Right","Tabs_ActiveTabArgumentOutOfRange":"Argument is not a member of the tabs collection","RTE_CellPadding":"Cell Padding","RTE_ClearFormatting":"Clear Formatting","AlwaysVisible_ElementRequired":"AjaxControlToolkit.AlwaysVisibleControlBehavior must have an element","Slider_NoSizeProvided":"Please set valid values for the height and width attributes in the slider\u0027s CSS classes","DynamicPopulate_WebServiceError":"Web Service call failed: {0}","PasswordStrength_StrengthPrompt":"Strength: ","PasswordStrength_RemainingCharacters":"{0} more characters","PasswordStrength_Satisfied":"Nothing more required","RTE_Hyperlink":"Hyperlink","Animation_NoPropertyFound":"AjaxControlToolkit.Animation.createAnimation found no property corresponding to \"{0}\"","PasswordStrength_InvalidStrengthDescriptionStyles":"Text Strength description style classes must match the number of text descriptions.","PasswordStrength_GetHelpRequirements":"Get help on password requirements","PasswordStrength_InvalidStrengthDescriptions":"Invalid number of text strength descriptions specified","RTE_Underline":"Underline","Tabs_PropertySetAfterInitialization":"{0} cannot be changed after initialization","RTE_Rows":"Rows","RTE_Redo":"Redo","RTE_Size":"Size","RTE_Undo":"Undo","RTE_Bold":"Bold","RTE_Copy":"Copy","RTE_Font":"Font","CascadingDropDown_MethodError":"[Method error {0}]","RTE_BorderColor":"Border Color","RTE_Paragraph":"Paragraph","RTE_InsertHorizontalRule":"Insert Horizontal Rule","Common_UnitHasNoDigits":"No digits","RTE_Outdent":"Outdent","Common_DateTime_InvalidTimeSpan":"\"{0}\" is not a valid TimeSpan format","Animation_CannotNestSequence":"AjaxControlToolkit.Animation.SequenceAnimation cannot be nested inside AjaxControlToolkit.Animation.ParallelAnimation","Shared_BrowserSecurityPreventsPaste":"Your browser security settings don\u0027t permit the automatic execution of paste operations. Please use the keyboard shortcut Ctrl+V instead."};
//END AjaxControlToolkit.ExtenderBase.BaseScripts.js
//START AjaxControlToolkit.Tabs.Tabs.js
Type.registerNamespace("AjaxControlToolkit");AjaxControlToolkit.ScrollBars = function() { }
AjaxControlToolkit.ScrollBars.prototype = {
None : 0x00,
Horizontal : 0x01,
Vertical : 0x02,
Both : 0x03,
Auto : 0x04
}
AjaxControlToolkit.ScrollBars.registerEnum("AjaxControlToolkit.ScrollBars", true);AjaxControlToolkit.TabContainer = function(element) {
AjaxControlToolkit.TabContainer.initializeBase(this, [element]);this._cachedActiveTabIndex = -1;this._activeTabIndex = -1;this._scrollBars = AjaxControlToolkit.ScrollBars.None;this._tabs = null;this._header = null;this._body = null;this._loaded = false;this._autoPostBackId = null;this._app_onload$delegate = Function.createDelegate(this, this._app_onload);}
AjaxControlToolkit.TabContainer.prototype = {
add_activeTabChanged : function(handler) {
this.get_events().addHandler("activeTabChanged", handler);},
remove_activeTabChanged : function(handler) {
this.get_events().removeHandler("activeTabChanged", handler);},
raiseActiveTabChanged : function() {
var eh = this.get_events().getHandler("activeTabChanged");if (eh) {
eh(this, Sys.EventArgs.Empty);}
if (this._autoPostBackId) {
__doPostBack(this._autoPostBackId, "activeTabChanged:" + this.get_activeTabIndex());}
},
get_activeTabIndex : function() { 
if (this._cachedActiveTabIndex > -1) {
return this._cachedActiveTabIndex;}
return this._activeTabIndex;},
set_activeTabIndex : function(value) {
if (!this.get_isInitialized()) {
this._cachedActiveTabIndex = value;} else {
if (value < -1 || value >= this.get_tabs().length) {
throw Error.argumentOutOfRange("value");}
if (this._activeTabIndex != -1) {
this.get_tabs()[this._activeTabIndex]._set_active(false);}
this._activeTabIndex = value;if (this._activeTabIndex != -1) {
this.get_tabs()[this._activeTabIndex]._set_active(true);}
if (this._loaded) {
this.raiseActiveTabChanged();}
this.raisePropertyChanged("activeTabIndex");}
},
get_tabs : function() { 
if (this._tabs == null) {
this._tabs = [];}
return this._tabs;},
get_activeTab : function() {
if (this._activeTabIndex > -1) {
return this.get_tabs()[this._activeTabIndex];}
return null;},
set_activeTab : function(value) {
var i = Array.indexOf(this.get_tabs(), value);if (i == -1) {
throw Error.argument("value", AjaxControlToolkit.Resources.Tabs_ActiveTabArgumentOutOfRange);}
this.set_activeTabIndex(i);},
get_autoPostBackId : function() {
return this._autoPostBackId;},
set_autoPostBackId : function(value) {
this._autoPostBackId = value;}, 
get_scrollBars : function() { 
return this._scrollBars;},
set_scrollBars : function(value) { 
if (this._scrollBars != value) {
this._scrollBars = value;this._invalidate();this.raisePropertyChanged("scrollBars");}
},
initialize : function() {
AjaxControlToolkit.TabContainer.callBaseMethod(this, "initialize");var elt = this.get_element();var header = this._header = $get(this.get_id() + "_header");var body = this._body = $get(this.get_id() + "_body");$common.addCssClasses(elt, [
"ajax__tab_container",
"ajax__tab_default"
]);Sys.UI.DomElement.addCssClass(header, "ajax__tab_header");Sys.UI.DomElement.addCssClass(body, "ajax__tab_body");this._invalidate();Sys.Application.add_load(this._app_onload$delegate);},
dispose : function() {
Sys.Application.remove_load(this._app_onload$delegate);AjaxControlToolkit.TabContainer.callBaseMethod(this, "dispose");},
getFirstTab : function(includeDisabled) {
var tabs = this.get_tabs();for(var i = 0;i < tabs.length;i++) {
if (includeDisabled || tabs[i].get_enabled()) {
return tabs[i];}
}
return null;},
getLastTab : function(includeDisabled) {
var tabs = this.get_tabs();for(var i = tabs.length -1;i >= 0;i--) {
if (includeDisabled || tabs[i].get_enabled()) {
return tabs[i];}
}
return null;},
getNextTab : function(includeDisabled) {
var tabs = this.get_tabs();var active = this.get_activeTabIndex();for (var i = 1;i < tabs.length;i++) {
var tabIndex = (active + i) % tabs.length;var tab = tabs[tabIndex];if (includeDisabled || tab.get_enabled()) 
return tab;}
return null;},
getPreviousTab : function(includeDisabled) {
var tabs = this.get_tabs();var active = this.get_activeTabIndex();for (var i = 1;i < tabs.length;i++) {
var tabIndex = (tabs.length + (active - i)) % tabs.length;var tab = tabs[tabIndex];if (includeDisabled || tab.get_enabled()) 
return tab;}
return null;},
getNearestTab : function() {
var prev = this.getPreviousTab(false);var next = this.getNextTab(false);if (prev && prev.get_tabIndex() < this._activeTabIndex) {
return prev;} else if(next && next.get_tabIndex() > this._activeTabIndex) {
return next;}
return null;},
saveClientState : function() {
var tabs = this.get_tabs();var tabState = [];for(var i = 0;i < tabs.length;i++) {
Array.add(tabState, tabs[i].get_enabled());} 
var state = {
ActiveTabIndex:this._activeTabIndex,
TabState:tabState
};return Sys.Serialization.JavaScriptSerializer.serialize(state);},
_invalidate : function() {
if (this.get_isInitialized()) {
$common.removeCssClasses(this._body, [
"ajax__scroll_horiz",
"ajax__scroll_vert",
"ajax__scroll_both",
"ajax__scroll_auto"
]);switch (this._scrollBars) {
case AjaxControlToolkit.ScrollBars.Horizontal: 
Sys.UI.DomElement.addCssClass(this._body, "ajax__scroll_horiz");break;case AjaxControlToolkit.ScrollBars.Vertical: 
Sys.UI.DomElement.addCssClass(this._body, "ajax__scroll_vert");break;case AjaxControlToolkit.ScrollBars.Both: 
Sys.UI.DomElement.addCssClass(this._body, "ajax__scroll_both");break;case AjaxControlToolkit.ScrollBars.Auto: 
Sys.UI.DomElement.addCssClass(this._body, "ajax__scroll_auto");break;}
}
},
_app_onload : function(sender, e) {
if (this._cachedActiveTabIndex != -1) {
this.set_activeTabIndex(this._cachedActiveTabIndex);this._cachedActiveTabIndex = -1;} 
this._loaded = true;}
}
AjaxControlToolkit.TabContainer.registerClass("AjaxControlToolkit.TabContainer", AjaxControlToolkit.ControlBase);AjaxControlToolkit.TabPanel = function(element) {
AjaxControlToolkit.TabPanel.initializeBase(this, [element]);this._active = false;this._tab = null;this._headerOuter = null;this._headerInner = null;this._header = null;this._owner = null;this._enabled = true;this._tabIndex = -1;this._dynamicContextKey = null;this._dynamicServicePath = null;this._dynamicServiceMethod = null;this._dynamicPopulateBehavior = null;this._scrollBars = AjaxControlToolkit.ScrollBars.None;this._header_onclick$delegate = Function.createDelegate(this, this._header_onclick);this._header_onmouseover$delegate = Function.createDelegate(this, this._header_onmouseover);this._header_onmouseout$delegate = Function.createDelegate(this, this._header_onmouseout);this._header_onmousedown$delegate = Function.createDelegate(this, this._header_onmousedown);this._dynamicPopulate_onpopulated$delegate = Function.createDelegate(this, this._dynamicPopulate_onpopulated);this._oncancel$delegate = Function.createDelegate(this, this._oncancel);}
AjaxControlToolkit.TabPanel.prototype = {
add_click : function(handler) {
this.get_events().addHandler("click", handler);},
remove_click : function(handler) {
this.get_events().removeHandler("click", handler);},
raiseClick : function() {
var eh = this.get_events().getHandler("click");if (eh) {
eh(this, Sys.EventArgs.Empty);}
},
add_populating : function(handler) {
this.get_events().addHandler("populating", handler);},
remove_populating : function(handler) {
this.get_events().removeHandler("populating", handler);},
raisePopulating : function() {
var eh = this.get_events().getHandler("populating");if (eh) {
eh(this, Sys.EventArgs.Empty);}
},
add_populated : function(handler) {
this.get_events().addHandler("populated", handler);},
remove_populated : function(handler) {
this.get_events().removeHandler("populated", handler);},
raisePopulated : function() {
var eh = this.get_events().getHandler("populated");if (eh) {
eh(this, Sys.EventArgs.Empty);}
},
get_headerText : function() { 
if (this.get_isInitialized()) {
return this._header.innerHTML;}
return "";},
set_headerText : function(value) { 
if (!this.get_isInitialized()) {
throw Error.invalidOperation(String.format(AjaxControlToolkit.Resources.Tabs_PropertySetBeforeInitialization, 'headerText'));}
if (this._headerText != value) {
this._headerTab.innerHTML = value;this.raisePropertyChanged("headerText");}
},
get_headerTab : function() {
return this._header;},
set_headerTab : function(value) {
if (this._header != value) {
if (this.get_isInitialized()) {
throw Error.invalidOperation(String.format(AjaxControlToolkit.Resources.Tabs_PropertySetAfterInitialization, 'headerTab'));}
this._header = value;this.raisePropertyChanged("value");}
},
get_enabled : function() {
return this._enabled;},
set_enabled : function(value) {
if (value != this._enabled) {
this._enabled = value;if (this.get_isInitialized()) {
if (!this._enabled) {
this._hide();} else {
this._show();}
}
this.raisePropertyChanged("enabled");}
},
get_owner : function() {
return this._owner;},
set_owner : function(value) {
if (this._owner != value) {
if (this.get_isInitialized()) {
throw Error.invalidOperation(String.format(AjaxControlToolkit.Resources.Tabs_PropertySetAfterInitialization, 'owner'));}
this._owner = value;this.raisePropertyChanged("owner");}
},
get_scrollBars : function() {
return this._scrollBars;},
set_scrollBars : function(value) {
if (this._scrollBars != value) {
this._scrollBars = value;this.raisePropertyChanged("scrollBars");}
},
get_tabIndex : function() {
return this._tabIndex;},
get_dynamicContextKey : function() {
return this._dynamicContextKey;},
set_dynamicContextKey : function(value) {
if (this._dynamicContextKey != value) {
this._dynamicContextKey = value;this.raisePropertyChanged('dynamicContextKey');}
},
get_dynamicServicePath : function() {
return this._dynamicServicePath;},
set_dynamicServicePath : function(value) {
if (this._dynamicServicePath != value) {
this._dynamicServicePath = value;this.raisePropertyChanged('dynamicServicePath');}
},
get_dynamicServiceMethod : function() {
return this._dynamicServiceMethod;},
set_dynamicServiceMethod : function(value) {
if (this._dynamicServiceMethod != value) {
this._dynamicServiceMethod = value;this.raisePropertyChanged('dynamicServiceMethod');}
},
_get_active : function() { 
return this._active;},
_set_active : function(value) { 
this._active = value;if (value) 
this._activate();else 
this._deactivate();},
initialize : function() {
AjaxControlToolkit.TabPanel.callBaseMethod(this, "initialize");var owner = this.get_owner();if (!owner) {
throw Error.invalidOperation(AjaxControlToolkit.Resources.Tabs_OwnerExpected);}
this._tabIndex = owner.get_tabs().length;Array.add(owner.get_tabs(), this);this._headerOuterWrapper = document.createElement('span');this._headerInnerWrapper = document.createElement('span');this._tab = document.createElement('span');this._tab.id = this.get_id() + "_tab";this._header.parentNode.replaceChild(this._tab, this._header);this._tab.appendChild(this._headerOuterWrapper);this._headerOuterWrapper.appendChild(this._headerInnerWrapper);this._headerInnerWrapper.appendChild(this._header);$addHandlers(this._header, {
click:this._header_onclick$delegate,
mouseover:this._header_onmouseover$delegate,
mouseout:this._header_onmouseout$delegate,
mousedown:this._header_onmousedown$delegate,
dragstart:this._oncancel$delegate,
selectstart:this._oncancel$delegate,
select:this._oncancel$delegate
});Sys.UI.DomElement.addCssClass(this._headerOuterWrapper, "ajax__tab_outer");Sys.UI.DomElement.addCssClass(this._headerInnerWrapper, "ajax__tab_inner");Sys.UI.DomElement.addCssClass(this._header, "ajax__tab_tab");Sys.UI.DomElement.addCssClass(this.get_element(), "ajax__tab_panel");if (!this._enabled) {
this._hide();}
},
dispose : function() { 
if (this._dynamicPopulateBehavior) {
this._dynamicPopulateBehavior.dispose();this._dynamicPopulateBehavior = null;}
$common.removeHandlers(this._header, {
click:this._header_onclick$delegate,
mouseover:this._header_onmouseover$delegate,
mouseout:this._header_onmouseout$delegate,
mousedown:this._header_onmousedown$delegate,
dragstart:this._oncancel$delegate,
selectstart:this._oncancel$delegate,
select:this._oncancel$delegate
});AjaxControlToolkit.TabPanel.callBaseMethod(this, "dispose");},
populate : function(contextKeyOverride) {
if (this._dynamicPopulateBehavior && (this._dynamicPopulateBehavior.get_element() != this.get_element())) {
this._dynamicPopulateBehavior.dispose();this._dynamicPopulateBehavior = null;}
if (!this._dynamicPopulateBehavior && this._dynamicServiceMethod) {
this._dynamicPopulateBehavior = $create(AjaxControlToolkit.DynamicPopulateBehavior,{"ContextKey":this._dynamicContextKey,"ServicePath":this._dynamicServicePath,"ServiceMethod":this._dynamicServiceMethod}, {"populated":this._dynamicPopulate_onpopulated$delegate}, null, this.get_element());}
if(this._dynamicPopulateBehavior) {
this.raisePopulating();this._dynamicPopulateBehavior.populate(contextKeyOverride ? contextKeyOverride : this._dynamicContextKey);}
},
_activate : function() {
var elt = this.get_element();$common.setVisible(elt, true);Sys.UI.DomElement.addCssClass(this._tab, "ajax__tab_active");this.populate();this._show();this._owner.get_element().style.visibility = 'visible';},
_deactivate : function() {
var elt = this.get_element();$common.setVisible(elt, false);Sys.UI.DomElement.removeCssClass(this._tab, "ajax__tab_active");},
_show : function() {
this._tab.style.display = '';},
_hide : function() {
this._tab.style.display = 'none';if (this._get_active()) {
var next = this._owner.getNearestTab(false);if (!!next) {
this._owner.set_activeTab(next);}
}
this._deactivate();},
_header_onclick : function(e) {
this.raiseClick();this.get_owner().set_activeTab(this);},
_header_onmouseover : function(e) {
Sys.UI.DomElement.addCssClass(this._tab, "ajax__tab_hover");},
_header_onmouseout : function(e) {
Sys.UI.DomElement.removeCssClass(this._tab, "ajax__tab_hover");},
_header_onmousedown : function(e) {
e.preventDefault();},
_oncancel : function(e) {
e.stopPropagation();e.preventDefault();},
_dynamicPopulate_onpopulated : function(sender, e) {
this.raisePopulated();}
}
AjaxControlToolkit.TabPanel.registerClass("AjaxControlToolkit.TabPanel", Sys.UI.Control);
//END AjaxControlToolkit.Tabs.Tabs.js
//START AjaxControlToolkit.DynamicPopulate.DynamicPopulateBehavior.js
Type.registerNamespace('AjaxControlToolkit');AjaxControlToolkit.DynamicPopulateBehavior = function(element) {
AjaxControlToolkit.DynamicPopulateBehavior.initializeBase(this, [element]);this._servicePath = null;this._serviceMethod = null;this._contextKey = null;this._cacheDynamicResults = false;this._populateTriggerID = null;this._setUpdatingCssClass = null;this._clearDuringUpdate = true;this._customScript = null;this._clickHandler = null;this._callID = 0;this._currentCallID = -1;this._populated = false;}
AjaxControlToolkit.DynamicPopulateBehavior.prototype = {
initialize : function() {
AjaxControlToolkit.DynamicPopulateBehavior.callBaseMethod(this, 'initialize');$common.prepareHiddenElementForATDeviceUpdate();if (this._populateTriggerID) {
var populateTrigger = $get(this._populateTriggerID);if (populateTrigger) {
this._clickHandler = Function.createDelegate(this, this._onPopulateTriggerClick);$addHandler(populateTrigger, "click", this._clickHandler);}
}
},
dispose : function() {
if (this._populateTriggerID && this._clickHandler) {
var populateTrigger = $get(this._populateTriggerID);if (populateTrigger) {
$removeHandler(populateTrigger, "click", this._clickHandler);}
this._populateTriggerID = null;this._clickHandler = null;}
AjaxControlToolkit.DynamicPopulateBehavior.callBaseMethod(this, 'dispose');},
populate : function(contextKey) {
if (this._populated && this._cacheDynamicResults) {
return;}
if (this._currentCallID == -1) {
var eventArgs = new Sys.CancelEventArgs();this.raisePopulating(eventArgs);if (eventArgs.get_cancel()) {
return;}
this._setUpdating(true);}
if (this._customScript) {
var scriptResult = eval(this._customScript);this._setTargetHtml(scriptResult);this._setUpdating(false);} else {
this._currentCallID = ++this._callID;if (this._servicePath && this._serviceMethod) {
Sys.Net.WebServiceProxy.invoke(this._servicePath, this._serviceMethod, false,
{ contextKey:(contextKey ? contextKey : this._contextKey) },
Function.createDelegate(this, this._onMethodComplete), Function.createDelegate(this, this._onMethodError),
this._currentCallID);$common.updateFormToRefreshATDeviceBuffer();}
}
},
_onMethodComplete : function (result, userContext, methodName) {
if (userContext != this._currentCallID) return;this._setTargetHtml(result);this._setUpdating(false);},
_onMethodError : function(webServiceError, userContext, methodName) {
if (userContext != this._currentCallID) return;if (webServiceError.get_timedOut()) {
this._setTargetHtml(AjaxControlToolkit.Resources.DynamicPopulate_WebServiceTimeout);} else {
this._setTargetHtml(String.format(AjaxControlToolkit.Resources.DynamicPopulate_WebServiceError, webServiceError.get_statusCode()));}
this._setUpdating(false);},
_onPopulateTriggerClick : function() {
this.populate(this._contextKey);},
_setUpdating : function(updating) {
this.setStyle(updating);if (!updating) {
this._currentCallID = -1;this._populated = true;this.raisePopulated(this, Sys.EventArgs.Empty);}
},
_setTargetHtml : function(value) {
var e = this.get_element()
if (e) {
if (e.tagName == "INPUT") {
e.value = value;} else {
e.innerHTML = value;}
}
},
setStyle : function(updating) {
var e = this.get_element();if (this._setUpdatingCssClass) {
if (!updating) {
e.className = this._oldCss;this._oldCss = null;} else {
this._oldCss = e.className;e.className = this._setUpdatingCssClass;}
}
if (updating && this._clearDuringUpdate) {
this._setTargetHtml("");}
},
get_ClearContentsDuringUpdate : function() {
return this._clearDuringUpdate;},
set_ClearContentsDuringUpdate : function(value) {
if (this._clearDuringUpdate != value) {
this._clearDuringUpdate = value;this.raisePropertyChanged('ClearContentsDuringUpdate');}
},
get_ContextKey : function() {
return this._contextKey;},
set_ContextKey : function(value) {
if (this._contextKey != value) {
this._contextKey = value;this.raisePropertyChanged('ContextKey');}
},
get_PopulateTriggerID : function() {
return this._populateTriggerID;},
set_PopulateTriggerID : function(value) {
if (this._populateTriggerID != value) {
this._populateTriggerID = value;this.raisePropertyChanged('PopulateTriggerID');}
},
get_ServicePath : function() {
return this._servicePath;},
set_ServicePath : function(value) {
if (this._servicePath != value) {
this._servicePath = value;this.raisePropertyChanged('ServicePath');}
},
get_ServiceMethod : function() {
return this._serviceMethod;},
set_ServiceMethod : function(value) {
if (this._serviceMethod != value) {
this._serviceMethod = value;this.raisePropertyChanged('ServiceMethod');}
},
get_cacheDynamicResults : function() {
return this._cacheDynamicResults;},
set_cacheDynamicResults : function(value) {
if (this._cacheDynamicResults != value) {
this._cacheDynamicResults = value;this.raisePropertyChanged('cacheDynamicResults');}
},
get_UpdatingCssClass : function() {
return this._setUpdatingCssClass;},
set_UpdatingCssClass : function(value) {
if (this._setUpdatingCssClass != value) {
this._setUpdatingCssClass = value;this.raisePropertyChanged('UpdatingCssClass');}
},
get_CustomScript : function() {
return this._customScript;}, 
set_CustomScript : function(value) {
if (this._customScript != value) {
this._customScript = value;this.raisePropertyChanged('CustomScript');}
},
add_populating : function(handler) {
this.get_events().addHandler('populating', handler);},
remove_populating : function(handler) {
this.get_events().removeHandler('populating', handler);},
raisePopulating : function(eventArgs) {
var handler = this.get_events().getHandler('populating');if (handler) {
handler(this, eventArgs);}
},
add_populated : function(handler) {
this.get_events().addHandler('populated', handler);},
remove_populated : function(handler) {
this.get_events().removeHandler('populated', handler);},
raisePopulated : function(eventArgs) {
var handler = this.get_events().getHandler('populated');if (handler) {
handler(this, eventArgs);}
}
}
AjaxControlToolkit.DynamicPopulateBehavior.registerClass('AjaxControlToolkit.DynamicPopulateBehavior', AjaxControlToolkit.BehaviorBase);
//END AjaxControlToolkit.DynamicPopulate.DynamicPopulateBehavior.js
if(typeof(Sys)!=='undefined')Sys.Application.notifyScriptLoaded();
(function() {var fn = function() {$get('ctl00_ScriptManager1_HiddenField').value += ';;AjaxControlToolkit, Version=1.0.20229.20821, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e:en-US:c5c982cc-4942-4683-9b48-c2c58277700f:e2e86ef9:1df13a87:ee0a475d:c4c00916';Sys.Application.remove_load(fn);};Sys.Application.add_load(fn);})();
