/*
 *   GBS - Google Book Classes
 *
 *   Copyright 2008 by Godmar Back godmar@gmail.com 
 *
 *   License: This software is released under the LGPL license,
 *   See http://www.gnu.org/licenses/lgpl.txt
 *
 *   $Id: gbsclasses.js,v 1.3 2008/03/16 05:05:16 gback Exp gback $
 *
 *   Instructions:
 *   ------------
 *
 *  Add <script type="text/javascript" src="gbsclasses.js"></script>
 *  to your document.
 */

/*****************************************************************/
/*
 * Add an event handler, browser-compatible.
 * This code taken from http://www.dustindiaz.com/rock-solid-addevent/
 * See also http://www.quirksmode.org/js/events_compinfo.html
 *          http://novemberborn.net/javascript/event-cache
 */
function addEvent( obj, type, fn ) {
        if (obj.addEventListener) {
                obj.addEventListener( type, fn, false );
                EventCache.add(obj, type, fn);
        }
        else if (obj.attachEvent) {
                obj["e"+type+fn] = fn;
                obj[type+fn] = function() { obj["e"+type+fn]( window.event ); }
                obj.attachEvent( "on"+type, obj[type+fn] );
                EventCache.add(obj, type, fn);
        }
        else {
                obj["on"+type] = obj["e"+type+fn];
        }
}

/* unload all event handlers on page unload to avoid memory leaks */
var EventCache = function(){
        var listEvents = [];
        return {
                listEvents : listEvents,
                add : function(node, sEventName, fHandler){
                        listEvents.push(arguments);
                },
                flush : function(){
                        var i, item;
                        for(i = listEvents.length - 1; i >= 0; i = i - 1){
                                item = listEvents[i];
                                if(item[0].removeEventListener){
                                        item[0].removeEventListener(item[1], item[2], item[3]);
                                };
                                if(item[1].substring(0, 2) != "on"){
                                        item[1] = "on" + item[1];
                                };
                                if(item[0].detachEvent){
                                        item[0].detachEvent(item[1], item[2]);
                                };
                                item[0][item[1]] = null;
                        };
                }
        };
}();
addEvent(window,'unload',EventCache.flush);
// end of rock-solid addEvent

String.prototype.trim = function() { 
    return this.replace(/^\s+|\s+$/g, ''); 
};

// Begin GBS code
var gbsKey2Req;         // map gbsKey -> Array<Request>
function gbsProcessResults(bookInfo) {
    for (var i in bookInfo) {
        var result = bookInfo[i];
        req = gbsKey2Req[result.bib_key];
        for (var j = 0; j < req.length; j++) {
            req[j].onsuccess(result);
        }
        delete gbsKey2Req[result.bib_key];
    }
    for (var i in gbsKey2Req) {
        req = gbsKey2Req[i];
        for (var j = 0; j < req.length; j++) {
            req[j].onfailure();
        }
        delete gbsKey2Req[i];
    }
}

// process all spans in a document
function gbsProcessSpans(spanElems) {
    gbsKey2Req = new Object();
    while (spanElems.length > 0) {
        var spanElem = spanElems.pop();
        if (spanElem.expanded)
            continue;

        gbsProcessSpan(spanElem);
    }

    var bibkeys = new Array();
    for (var k in gbsKey2Req)
        bibkeys.push(k);
    bibkeys = bibkeys.join(",");
    var s = document.createElement("script");
    s.setAttribute("type", "text/javascript");
    s.setAttribute("src", "http://books.google.com/books?jscmd=viewapi&bibkeys=" + bibkeys + "&callback=gbsProcessResults");
    document.documentElement.firstChild.appendChild(s);
}

// process a single span
function gbsProcessSpan(spanElem) {
    var cName = spanElem.className;
    if (cName == null)
        return;

    var mReq = {
        span: spanElem, 
        removeTitle: function () {
            this.span.setAttribute('title', '');
        },
        success: new Array(),
        failure: new Array(),
        onsuccess: function (result) {
            for (var i = 0; i < this.success.length; i++)
                try {
                    this.success[i](this, result);
                } catch (er) { }
            this.removeTitle();
        },
        onfailure: function (status) {
            for (var i = 0; i < this.failure.length; i++)
                try {
                    this.failure[i](this, status);
                } catch (er) { }
            this.removeTitle();
        },
        /* get the search item that's sent to GBS
         * The search term may be in the title, or in the body.
         * It's in the body if the title contains a "*".
         * Example:  
         *           <span title="ISBN:0743226720"></span>
         *           <span title="*">ISBN:0743226720</span>
         */
        getSearchItem: function () {
            if (this.searchitem === undefined) {
                var req = this.span.getAttribute('title');
                if (req == "*") {
                    var text = this.span.innerText || this.span.textContent || "";
                    this.searchitem = text = text.trim();

                    // remove children and make sure <span> is visible
                    while (this.span.hasChildNodes())
                        this.span.removeChild(this.span.firstChild);
                    this.span.style.display = "inline";
                } else
                    this.searchitem = req.toLowerCase();
            }
            return this.searchitem;
        }
    };

    // wrap the span element in a link to bookinfo[bookInfoProp]
    function linkTo(mReq, bookInfoProp) {
        mReq.success.push(function (mReq, bookinfo) {
            if (bookinfo[bookInfoProp] === undefined)
                return;

            var p = mReq.span.parentNode;
            var s = mReq.span.nextSibling;
            p.removeChild(mReq.span);
            var a = document.createElement("a");
            a.setAttribute("href", bookinfo[bookInfoProp]);
            a.appendChild(mReq.span);
            p.insertBefore(a, s);
        });
    }

    /**
     * See: http://code.google.com/apis/books/getting-started.html
        bib_key
            The identifier used to query this book.
        info_url
            A URL to a page within Google Book Search with information on the book (the about this book page)
        preview_url
            A URL to the preview of the book - this lands the user on the cover of the book. 
            If there only Snippet View or Metadata View books available for a request, no preview url 
            will be returned.
        thumbnail_url
            A URL to a thumbnail of the cover of the book.
        preview
            Viewability state - either "noview", "partial", or "full"
     */
    function addHandler(gbsClass, mReq) {
        switch (gbsClass) {
        case "gbs-thumbnail":
            mReq.success.push(function (mReq, bookinfo) {
                if (bookinfo.thumbnail_url) {
                    var img = document.createElement("img");
                    img.setAttribute("src", bookinfo.thumbnail_url);
                    mReq.span.appendChild(img);
                }
            });
            break;

        case "gbs-link-to-preview":
            linkTo(mReq, 'preview_url');
            break;

        case "gbs-link-to-info":
            linkTo(mReq, 'info_url');
            break;

        case "gbs-link-to-thumbnail":
            linkTo(mReq, 'thumbnail_url');
            break;

        case "gbs-if-noview":
        case "gbs-if-partial-or-full":
        case "gbs-if-partial":
        case "gbs-if-full":
            mReq.gbsif = gbsClass.replace(/gbs-if-/, "");
            mReq.success.push(function (mReq, bookinfo) {
                if (mReq.gbsif == "partial-or-full") {
                    var keep = bookinfo.preview == "partial" || bookinfo.preview == "full";
                } else {
                    var keep = bookinfo.preview == mReq.gbsif;
                }
                if (!keep) {
                    mReq.span.parentNode.removeChild(mReq.span);
                }
            });
            break;

        case "gbs-remove-on-failure":
            mReq.failure.push(function (mReq, status) {
                mReq.span.parentNode.removeChild(mReq.span);
            });
            break;
        // XXX add more here

        default:
            return false;
        }
        return true;
    }

    var isGBS = false;
    var classEntries = cName.split(/\s+/);
    for (var i = 0; i < classEntries.length; i++) {
        if (addHandler(classEntries[i], mReq))
            isGBS = true;
    }

    if (!isGBS)
        return;

    var bibkey = mReq.getSearchItem();
    if (gbsKey2Req[bibkey] === undefined) {
        gbsKey2Req[bibkey] = [ mReq ];
    } else {
        gbsKey2Req[bibkey].push(mReq);
    }
    mReq.span.expanded = true;
}

function gbsLoaded() {
    var span = document.getElementsByTagName("span");
    var spanElems = new Array();
    for (var i = 0; i < span.length; i++) {
        spanElems[i] = span[span.length - 1 - i];
    }
    gbsProcessSpans(spanElems);
}

addEvent(window, "load", gbsLoaded);
