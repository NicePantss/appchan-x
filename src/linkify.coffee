﻿###
Based on the Linkify scripts located at:
http://downloads.mozdev.org/greasemonkey/linkify.user.js
https://github.com/MayhemYDG/LinkifyPlusFork

Originally written by Anthony Lieuallen of http://arantius.com/
Licensed for unlimited modification and redistribution as long as
this notice is kept intact.

If possible, please contact me regarding new features, bugfixes
or changes that I could integrate into the existing code instead of
creating a different script. Thank you.
###

Linkify =
  init: ->
    Main.callbacks.push @node
  node: (post) ->
    # Built based on:
    # - http://en.wikipedia.org/wiki/URI_scheme
    # - http://www.regular-expressions.info/regexbuddy/email.html

    blockquote = $ 'blockquote', post.el
    for child in blockquote.childNodes
      if child.nodeType == Node.TEXT_NODE
        Linkify.text child

  text: (child) ->
    txt = child.textContent
    span = null
    p = 0
    urlRE = new RegExp '(' + '\\b([a-z][-a-z0-9+.]+://|www\\.)' + '[^\\s\'"<>()]+' + '|' + '\\b[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}\\b' + ')',  'gi'
    while m = urlRE.exec txt
      if null == span
        span = $.el 'span'
          className: 'linkifyplus'

      # Get the link without trailing dots
      l = m[0].replace /\.*$/, ''
      lLen = l.length
      # Put in text up to the link
      span.appendChild d.createTextNode txt.substring p, m.index
      # Create a link and put it in the span
      a = $.el 'a'
        textContent: l
        className: 'linkifyplus'
        rel:       'nofollow noreferrer _new'
        href:      if l.indexOf(":/") < 0 then (if l.indexOf("@") > 0 then "mailto:" + l else "http://" + l) else l

      $.add span, a
      # Track insertion point
      p = m.index+lLen

    if span
      # Take the text after the last link
      span.appendChild d.createTextNode txt.substring p, txt.length
      # Replace the original text with the new span
      try
        child.parentNode.replaceChild(span, child)
      catch e
        $.log e
        $.log child.tagName + "could not be appended..."