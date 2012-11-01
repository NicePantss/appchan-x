###
Based on JSColor, JavaScript Color Picker

@license   GNU Lesser General Public License, http://www.gnu.org/copyleft/lesser.html
@author    Jan Odvarko, http://odvarko.cz
@link      http://JSColor.com
###

JSColor =
  bind: (el) ->
    if not el.color
      el.color = new JSColor.color(el)

  images:
    pad:        [ 181, 101 ]
    sld:        [ 16, 101 ]
    cross:      [ 15, 15 ]
    arrow:      [ 7, 11 ]

  imgRequire:   {}
  imgLoaded:    {}

  requireImage: (filename) ->
    JSColor.imgRequire[filename]        = true

  loadImage: (filename) ->
    unless JSColor.imgLoaded[filename]
      JSColor.imgLoaded[filename]       = new Image()
      JSColor.imgLoaded[filename].src   = JSColor.getDir() + filename

  fetchElement: (mixed) ->
    (if typeof mixed is "string" then document.getElementById(mixed) else mixed)

  fireEvent: (el, evnt) ->
    return unless el

    if document.createEvent
      ev = document.createEvent 'HTMLEvents'
      ev.initEvent evnt, true, true
      el.dispatchEvent ev
    else if document.createEventObject
      ev = document.createEventObject()
      el.fireEvent 'on' + evnt, ev
    else if el['on' + evnt] # alternatively use the traditional event model (IE5)
      el['on' + evnt]()

  getElementPos: (e) ->
    e1=e
    e2=e
    x=0
    y=0
    if e1.offsetParent
      while e1 = e1.offsetParent
        x += e1.offsetLeft
        y += e1.offsetTop
    while (e2 = e2.parentNode) and e2.nodeName.toLowerCase() isnt 'body'
      x -= e2.scrollLeft
      y -= e2.scrollTop
    [x, y]

  getElementSize: (e) ->
    [e.offsetWidth, e.offsetHeight]

  getRelMousePos: (e = window.event) ->
    x = 0
    y = 0
    if typeof e.offsetX is 'number'
      x = e.offsetX
      y = e.offsetY
    else if typeof e.layerX is 'number'
      x = e.layerX
      y = e.layerY
    x: x
    y: y

  getViewPos: ->
    if typeof window.pageYOffset is 'number'
      [window.pageXOffset, window.pageYOffset]
    else if document.body and (document.body.scrollLeft or document.body.scrollTop)
      [document.body.scrollLeft, document.body.scrollTop]
    else if document.documentElement and (document.documentElement.scrollLeft or document.documentElement.scrollTop)
      [document.documentElement.scrollLeft, document.documentElement.scrollTop]
    else
      [0, 0]


  getViewSize: ->
    if typeof window.innerWidth is 'number'
      [window.innerWidth, window.innerHeight]
    else if document.body and (document.body.clientWidth or document.body.clientHeight)
      [document.body.clientWidth, document.body.clientHeight]
    else if document.documentElement and (document.documentElement.clientWidth or document.documentElement.clientHeight)
      [document.documentElement.clientWidth, document.documentElement.clientHeight]
    else
      [0, 0]

  color: (target) ->
    @required                   = true           # refuse empty values?
    @adjust                     = true           # adjust value to uniform notation?
    @slider                     = true           # show the value/saturation slider?
    @valueElement               = target         # value holder
    @styleElement               = target         # where to reflect current color
    @onImmediateChange          = null           # onchange callback (can be either string or function)
    @hsv                        = [0, 0, 1]      # read-only  0-6, 0-1, 0-1
    @rgb                        = [1, 1, 1]      # read-only  0-1, 0-1, 0-1
    @minH                       = 0              # read-only  0-6
    @maxH                       = 6              # read-only  0-6
    @minS                       = 0              # read-only  0-1
    @maxS                       = 1              # read-only  0-1
    @minV                       = 0              # read-only  0-1
    @maxV                       = 1              # read-only  0-1
    @pickerOnfocus              = true           # display picker on focus?
    @pickerMode                 = 'HSV'          # HSV | HVS
    @pickerPosition             = 'bottom'       # left | right | top | bottom
    @pickerSmartPosition        = true           # automatically adjust picker position when necessary
    @pickerButtonHeight         = 20             # px
    @pickerClosable             = false
    @pickerCloseText            = 'Close'
    @pickerButtonColor          = 'ButtonText'   # px
    @pickerFace                 = 10             # px
    @pickerFaceColor            = 'ThreeDFace'   # CSS color
    @pickerBorder               = 1              # px
    @pickerBorderColor          = 'ThreeDHighlight ThreeDShadow ThreeDShadow ThreeDHighlight' # CSS color
    @pickerInset                = 1              # px
    @pickerInsetColor           = 'ThreeDShadow ThreeDHighlight ThreeDHighlight ThreeDShadow' # CSS color
    @pickerZIndex               = 10000

    @hidePicker = ->
      if isPickerOwner()
        removePicker()

    @showPicker = ->
      unless isPickerOwner()
        tp = JSColor.getElementPos target   # target position
        ts = JSColor.getElementSize target  # target size
        vp = JSColor.getViewPos()           # view pos
        vs = JSColor.getViewSize()          # view size
        ps = getPickerDims @                # picker size

        switch @pickerPosition.toLowerCase()
          when 'left'
            a=1
            b=0
            c=-1
          when 'right'
            a=1
            b=0
            c=1
          when 'top'
            a=0
            b=1
            c=-1
          else
            a=0
            b=1
            c=1
        l = (ts[b] + ps[b]) / 2

        # picker pos
        unless @pickerSmartPosition
          pp = [
            tp[a],
            tp[b] + ts[b] - l + l * c
          ]
        else
          pp = [

            (
              if -vp[a] + tp[a] + ps[a] > vs[a]
               if -vp[a] + tp[a] + ts[a] / 2 > vs[a] / 2 and tp[a] + ts[a] - ps[a] >= 0
                  tp[a] + ts[a] - ps[a]
                else
                  tp[a]
              else
                tp[a]
            )

            (
              if -vp[b] + tp[b] + ts[b] + ps[b] - l + l * c > vs[b]
                if -vp[b] + tp[b] + ts[b] / 2 > vs[b] / 2 and tp[b] + ts[b] - l - l * c >= 0
                  tp[b] + ts[b] - l - l * c
                else
                  tp[b] + ts[b] - l + l * c
              else
                if tp[b] + ts[b] - l + l * c >= 0
                  tp[b] + ts[b] - l + l * c
                else
                  tp[b] + ts[b] - l - l * c
            )
          ]
        drawPicker pp[a], pp[b]

    @importColor = ->
      unless valueElement
        @exportColor()
      else
        unless @adjust
          unless @fromString valueElement.value, leaveValue
            styleElement.style.backgroundImage = styleElement.jscStyle.backgroundImage
            styleElement.style.backgroundColor = styleElement.jscStyle.backgroundColor
            styleElement.style.color           = styleElement.jscStyle.color
            @exportColor leaveValue | leaveStyle

        else unless @required and /^\s*$/.test(valueElement.value)
          valueElement.value                   = ''
          styleElement.style.backgroundImage   = styleElement.jscStyle.backgroundImage
          styleElement.style.backgroundColor   = styleElement.jscStyle.backgroundColor
          styleElement.style.color             = styleElement.jscStyle.color
          @exportColor leaveValue | leaveStyle

        else @exportColor() unless @fromString valueElement.value

    @exportColor = (flags) ->
      if not (flags & leaveValue) and valueElement
        value = @toString()
        value = '#' + value
        valueElement.value = value

      if not (flags & leaveStyle) and styleElement
        styleElement.style.backgroundImage = "none"
        styleElement.style.backgroundColor = '#'+@toString()
        styleElement.style.color = if ((
          0.213 * @rgb[0] +
          0.715 * @rgb[1] +
          0.072 * @rgb[2]
        ) < 0.5) then '#FFF' else '#000'

      if not (flags & leavePad) and isPickerOwner()
        redrawPad()

      if not (flags & leaveSld) and isPickerOwner()
        redrawSld()

    @fromHSV = (h, s, v, flags) -> # null = don't change
      if h isnt null then h = Math.max(0.0, @minH, Math.min(6.0, @maxH, h))
      if s isnt null then s = Math.max(0.0, @minS, Math.min(1.0, @maxS, s))
      if v isnt null then v = Math.max(0.0, @minV, Math.min(1.0, @maxV, v))

      @rgb = HSV_RGB(
        if h is null then @hsv[0] else (@hsv[0] = h)
        if s is null then @hsv[1] else (@hsv[1] = s)
        if v is null then @hsv[2] else (@hsv[2] = v)
      )
      
      $.log @rgb

      @exportColor flags

    @fromRGB = (r, g, b, flags) -> # null = don't change
      if r isnt null then r = Math.max(0.0, Math.min(1.0, r))
      if g isnt null then g = Math.max(0.0, Math.min(1.0, g))
      if b isnt null then b = Math.max(0.0, Math.min(1.0, b))

      hsv = RGB_HSV(
        if r is null then @rgb[0] else r
        if g is null then @rgb[1] else g
        if b is null then @rgb[2] else b
      )

      if hsv[0] isnt null
        @hsv[0] = Math.max(0.0, @minH, Math.min(6.0, @maxH, hsv[0]))

      if hsv[2] isnt 0
        @hsv[1] = 
          if hsv[1] is null
            null
          else
            Math.max 0.0, @minS, Math.min 1.0, @maxS, hsv[1]

      @hsv[2] =
        if hsv[2] is null
          null
        else
          Math.max 0.0, @minV, Math.min 1.0, @maxV, hsv[2]

      # update RGB according to final HSV, as some values might be trimmed
      rgb = HSV_RGB(@hsv[0], @hsv[1], @hsv[2])
      @rgb[0] = rgb[0]
      @rgb[1] = rgb[1]
      @rgb[2] = rgb[2]

      @exportColor flags

    @fromString = (number, flags) ->
      m = number.match(/^\W*([0-9A-F]{3}([0-9A-F]{3})?)\W*$/i)
      unless m
        return false
        m = number.match /(rgba?)|(\d+(\.\d+)?%?)|(\.\d+)/i
        unless m
          return false
        else if m and m.length >= 3
          while i < 3
            value = m[++i]
            if value.contains '%'
              value = Math.round parseFloat(value) * 2.55
            else
              value = parseInt value, 10
            return false if value < 0 or value > 255
            m[i] = value
          
          @fromRGB(m[1], m[2], m[3], flags)
        else return false
      else
        if m[1].length is 6 # 6-char notation
          @fromRGB(
            parseInt(m[1].substr(0,2),16) / 255
            parseInt(m[1].substr(2,2),16) / 255
            parseInt(m[1].substr(4,2),16) / 255
            flags
          )
        else # 3-char notation
          @fromRGB(
            parseInt(m[1].charAt(0)+m[1].charAt(0),16) / 255
            parseInt(m[1].charAt(1)+m[1].charAt(1),16) / 255
            parseInt(m[1].charAt(2)+m[1].charAt(2),16) / 255
            flags
          )
        true

    @toString = ->
      (0x100 | Math.round(255 * @rgb[0])).toString(16).substr(1) +
      (0x100 | Math.round(255 * @rgb[1])).toString(16).substr(1) +
      (0x100 | Math.round(255 * @rgb[2])).toString(16).substr(1)

    RGB_HSV = (r, g, b) ->
      n = Math.min(Math.min(r,g),b)
      v = Math.max(Math.max(r,g),b)
      m = v - n

      return [ null, 0, v ] if m is 0

      h =
        if r is n
          3 + (b - g) / m
        else
          if g is n
            5 + (r - b) / m
          else
            1 + (g - r) / m
      [if h is 6
          0
        else
          h
        m / v
        v]

    HSV_RGB = (h, s, v) ->
      
      return [ v, v, v ] if h is null
      
      i = Math.floor(h)
      f = if i % 2 then h - i else 1 - (h - i)
      m = v * (1 - s)
      n = v * (1 - s * f)

      switch i
        when 6, 0 then return [v,n,m]
        when 1    then return [n,v,m]
        when 2    then return [m,v,n]
        when 3    then return [m,n,v]
        when 4    then return [n,m,v]
        when 5    then return [v,m,n]

    removePicker = () ->
      delete JSColor.picker.owner
      document.body.removeChild JSColor.picker.boxB

    drawPicker = (x, y) ->
      unless JSColor.picker
        JSColor.picker =
          box:  document.createElement('div')
          boxB: document.createElement('div')
          pad:  document.createElement('div')
          padB: document.createElement('div')
          padM: document.createElement('div')
          sld:  document.createElement('div')
          sldB: document.createElement('div')
          sldM: document.createElement('div')
          btn:  document.createElement('div')
          btnS: document.createElement('span')
          btnT: document.createTextNode(@pickerCloseText)

        for i in JSColor.images.sld[1] by (segSize = 4)
          seg = document.createElement('div')
          seg.style.height     = segSize + 'px'
          seg.style.fontSize   = '1px'
          seg.style.lineHeight = '0'
          JSColor.picker.sld.appendChild(seg)

        JSColor.picker.sldB.appendChild JSColor.picker.sld
        JSColor.picker.box.appendChild  JSColor.picker.sldB
        JSColor.picker.box.appendChild  JSColor.picker.sldM
        JSColor.picker.padB.appendChild JSColor.picker.pad
        JSColor.picker.box.appendChild  JSColor.picker.padB
        JSColor.picker.box.appendChild  JSColor.picker.padM
        JSColor.picker.btnS.appendChild JSColor.picker.btnT
        JSColor.picker.btn.appendChild  JSColor.picker.btnS
        JSColor.picker.box.appendChild  JSColor.picker.btn
        JSColor.picker.boxB.appendChild JSColor.picker.box

      p = JSColor.picker

      # controls interaction
      p.box.onmouseup =
      p.box.onmouseout = -> target.focus()
      p.box.onmousedown = -> abortBlur=true
      p.box.onmousemove = (e) ->
        if holdPad or holdSld
          holdPad and setPad e
          holdSld and setSld e
          if document.selection
            document.selection.empty()
          else if window.getSelection
            window.getSelection().removeAllRanges()

          dispatchImmediateChange()

      p.padM.onmouseup =
      p.padM.onmouseout = -> if holdPad
        holdPad = false
        JSColor.fireEvent valueElement, 'change'
      p.padM.onmousedown = (e) ->
        # if the slider is at the bottom, move it up
        switch modeID
          when 0
            if THIS.hsv[2] is 0
              THIS.fromHSV null, null, 1.0
          when 1
            if THIS.hsv[1] is 0
              THIS.fromHSV null, 1.0, null

        holdPad = true
        setPad e
        dispatchImmediateChange()

      p.sldM.onmouseup =
      p.sldM.onmouseout = -> if holdSld
        holdSld = false
        JSColor.fireEvent valueElement, 'change'
      p.sldM.onmousedown = (e) ->
        holdSld = true
        setSld e
        dispatchImmediateChange()

      # picker
      dims                      = getPickerDims THIS
      p.box.style.width         = dims[0] + 'px'
      p.box.style.height        = dims[1] + 'px'

      # picker border
      p.boxB.style.position     = 'absolute'
      p.boxB.style.clear        = 'both'
      p.boxB.style.left         = x + 'px'
      p.boxB.style.top          = y + 'px'
      p.boxB.style.zIndex       = THIS.pickerZIndex
      p.boxB.style.border       = THIS.pickerBorder + 'px solid'
      p.boxB.style.borderColor  = THIS.pickerBorderColor
      p.boxB.style.background   = THIS.pickerFaceColor

      # pad image
      p.pad.style.width         = JSColor.images.pad[0] + 'px'
      p.pad.style.height        = JSColor.images.pad[1] + 'px'

      # pad border
      p.padB.style.position     = 'absolute'
      p.padB.style.left         = THIS.pickerFace  + 'px'
      p.padB.style.top          = THIS.pickerFace  + 'px'
      p.padB.style.border       = THIS.pickerInset + 'px solid'
      p.padB.style.borderColor  = THIS.pickerInsetColor

      # pad mouse area
      p.padM.style.position     = 'absolute'
      p.padM.style.left         = '0'
      p.padM.style.top          = '0'
      p.padM.style.width        = THIS.pickerFace + 2 * THIS.pickerInset + JSColor.images.pad[0] + JSColor.images.arrow[0] + 'px'
      p.padM.style.height       = p.box.style.height
      p.padM.style.cursor       = 'crosshair'

      # slider image
      p.sld.style.overflow      = 'hidden'
      p.sld.style.width         = JSColor.images.sld[0] + 'px'
      p.sld.style.height        = JSColor.images.sld[1] + 'px'

      # slider border
      p.sldB.style.display      = if @slider then 'block' else 'none'
      p.sldB.style.position     = 'absolute'
      p.sldB.style.right        = THIS.pickerFace  + 'px'
      p.sldB.style.top          = THIS.pickerFace  + 'px'
      p.sldB.style.border       = THIS.pickerInset + 'px solid'
      p.sldB.style.borderColor  = THIS.pickerInsetColor

      # slider mouse area
      p.sldM.style.display      = if @slider then 'block' else 'none'
      p.sldM.style.position     = 'absolute'
      p.sldM.style.right        = '0'
      p.sldM.style.top          = '0'
      p.sldM.style.width        = JSColor.images.sld[0] + JSColor.images.arrow[0] + @pickerFace + 2 * THIS.pickerInset + 'px'
      p.sldM.style.height       = p.box.style.height

      try
        p.sldM.style.cursor     = 'pointer'
      catch eOldIE
        p.sldM.style.cursor     = 'hand'

      # "close" button
      setBtnBorder = ->
        insetColors = THIS.pickerInsetColor.split /\s+/
        pickerOutsetColor = if insetColors.length < 2
          insetColors[0]
        else
          insetColors[1] + ' ' + insetColors[0] + ' ' + insetColors[0] + ' ' + insetColors[1]
        p.btn.style.borderColor = pickerOutsetColor

      p.btn.style.display       = if THIS.pickerClosable then 'block' else 'none'
      p.btn.style.position      = 'absolute'
      p.btn.style.left          = THIS.pickerFace + 'px'
      p.btn.style.bottom        = THIS.pickerFace + 'px'
      p.btn.style.padding       = '0 15px'
      p.btn.style.height        = '18px'
      p.btn.style.border        = THIS.pickerInset + 'px solid'
      setBtnBorder()
      p.btn.style.color         = THIS.pickerButtonColor
      p.btn.style.font          = '12px sans-serif'
      p.btn.style.textAlign     = 'center'

      try
        p.btn.style.cursor = 'pointer'
      catch eOldIE
        p.btn.style.cursor = 'hand'

      p.btn.onmousedown = () ->
        @hidePicker()

      p.btnS.style.lineHeight   = p.btn.style.height

      # load images in optimal order
      switch modeID
        when 0
          padImg = "#{Style.agent()}linear-gradient(rgba(255,255,255,0), rgba(255,255,255,1)), #{Style.agent()}linear-gradient(left, #f00, #ff0, #0f0, #0ff, #00f, #f0f, #f00)"
        when 1
          padImg = "#{Style.agent()}linear-gradient(rgba(255,255,255,0), rgba(255,255,255,1)), #{Style.agent()}linear-gradient(left, #f00, #ff0, #0f0, #0ff, #00f, #f0f, #f00)"

      p.padM.style.backgroundImage   = "url('')"
      p.padM.style.backgroundRepeat  = "no-repeat"
      p.sldM.style.backgroundImage   = "url('')"
      p.sldM.style.backgroundRepeat  = "no-repeat"
      p.pad.style.backgroundImage    = padImg
      p.pad.style.backgroundRepeat   = "no-repeat"
      p.pad.style.backgroundPosition = "0 0"

      # place pointers
      redrawPad()
      redrawSld()

      JSColor.picker.owner = THIS
      document.body.appendChild p.boxB

    getPickerDims = (o) ->
      dims = [
        (
          2 * o.pickerInset               +
          2 * o.pickerFace                +
          JSColor.images.pad[0]           +
          (
            if o.slider
              2 * o.pickerInset           +
              2 * JSColor.images.arrow[0] +
              JSColor.images.sld[0]
            else
              0
          )
        )
        if o.pickerClosable
          (
            4 * o.pickerInset       +
            3*o.pickerFace          +
            JSColor.images.pad[1]   +
            o.pickerButtonHeight
          )
        else
          (
            2 * o.pickerInset       +
            2 * o.pickerFace        +
            JSColor.images.pad[1]
          )
      ]

    # redraw the pad pointer
    redrawPad = () ->

      switch modeID
        when 0
          yComponent = 1
        when 1
          yComponent = 2

      x = Math.round (THIS.hsv[0] / 6)          * (JSColor.images.pad[0] - 1)
      y = Math.round (1 - THIS.hsv[yComponent]) * (JSColor.images.pad[1] - 1)
      JSColor.picker.padM.style.backgroundPosition =
        "#{THIS.pickerFace+THIS.pickerInset+x - Math.floor(JSColor.images.cross[0] / 2)}px " +
        "#{THIS.pickerFace+THIS.pickerInset+y - Math.floor(JSColor.images.cross[1] / 2)}px"

      # redraw the slider image
      seg = JSColor.picker.sld.childNodes

      switch modeID
        when 0
          rgb = HSV_RGB(THIS.hsv[0], THIS.hsv[1], 1)
          for item in seg
            item.style.backgroundColor =
              "rgb(" +
              "#{rgb[0]*(1-i/seg.length)*100}%, " +
              "#{rgb[1]*(1-i/seg.length)*100}%, " +
              "#{rgb[2]*(1-i/seg.length)*100}%)"
        when 1
          c = [ THIS.hsv[2], 0, 0 ]
          i = Math.floor(THIS.hsv[0])
          f = if i % 2
            THIS.hsv[0] - i
          else
            1 - (THIS.hsv[0] - i)

          switch i
            when 6, 0
              rgb=[0,1,2]
            when 1
              rgb=[1,0,2]
            when 2
              rgb=[2,0,1]
            when 3
              rgb=[2,1,0]
            when 4
              rgb=[1,2,0]
            when 5
              rgb=[0,2,1]

          for item in seg
            s = 1 - 1 / (seg.length - 1) * i
            c[1] = c[0] * (1 - s*f)
            c[2] = c[0] * (1 - s)
            seg[i].style.backgroundColor =
              "rgb(" +
              "#{c[rgb[0]]*100}%, " +
              "#{c[rgb[1]]*100}%, " +
              "#{c[rgb[2]]*100}%)"

    redrawSld = ->
      # redraw the slider pointer
      switch modeID
        when 0
          yComponent = 2
        when 1
          yComponent = 1

      y = Math.round (1 - THIS.hsv[yComponent]) * (JSColor.images.sld[1] - 1)
      JSColor.picker.sldM.style.backgroundPosition =
        "0 #{THIS.pickerFace + THIS.pickerInset+y - Math.floor(JSColor.images.arrow[1] / 2)}px"


    isPickerOwner = ->
      JSColor.picker and JSColor.picker.owner is THIS

    blurTarget = ->
      if valueElement is target
        THIS.importColor()
      if THIS.pickerOnfocus
        THIS.hidePicker()

    blurValue = ->
      if valueElement isnt target
        THIS.importColor()

    setPad = (e) ->
      mpos = JSColor.getRelMousePos e
      x = mpos.x - @pickerFace - @pickerInset
      y = mpos.y - @pickerFace - @pickerInset
      switch modeID
        when 0
          THIS.fromHSV(
            x * (
              6 / (
                JSColor.images.pad[0] - 1
              )
            )
            1 - y / (
              JSColor.images.pad[1] - 1
            )
            null
            leaveSld
          )
        when 1
          THIS.fromHSV(
            x * (
              6 / (
                JSColor.images.pad[0] - 1
              )
            )
            null
            1 - y / (
              JSColor.images.pad[1] - 1
            )
            leaveSld
          )


    setSld = (e) ->
      mpos  = JSColor.getRelMousePos e
      y     = mpos.y - @pickerFace - @pickerInset
      switch modeID
        when 0
          @fromHSV(
            null
            null
            1 - y / (
              JSColor.images.sld[1] - 1
            )
            leavePad
          )
        when 1
          @fromHSV(
            null
            1 - y / (
              JSColor.images.sld[1] - 1
            )
            null
            leavePad
          )

    dispatchImmediateChange = ->
      if @onImmediateChange
        callback
        if typeof @onImmediateChange is 'string'
          callback = new Function (@onImmediateChange)
        else
          callback = @onImmediateChange
        callback.call(THIS)

    THIS         = @
    modeID       =
      if @pickerMode.toLowerCase() is 'hvs'
        1
      else
        0
    abortBlur    = false
    valueElement = JSColor.fetchElement @valueElement
    styleElement = JSColor.fetchElement @styleElement
    holdPad      = false
    holdSld      = false
    leaveValue   = 1 << 0
    leaveStyle   = 1 << 1
    leavePad     = 1 << 2
    leaveSld     = 1 << 3

    # target
    $.on target, 'focus', ->
      if THIS.pickerOnfocus
        THIS.showPicker()

    $.on target, 'blur', ->
      unless abortBlur
        window.setTimeout (->
            abortBlur or blurTarget()
            abortBlur = false
          )
          0
      else
        abortBlur = false

    # valueElement
    if valueElement
      updateField = ->
        THIS.fromString valueElement.value, leaveValue
        dispatchImmediateChange()

      $.on valueElement, 'keyup', updateField
      $.on valueElement, 'input', updateField
      $.on valueElement, 'blur',  blurValue
      valueElement.setAttribute 'autocomplete', 'off'

    # styleElement
    if styleElement
      styleElement.jscStyle =
        backgroundImage:    styleElement.style.backgroundImage
        backgroundColor:    styleElement.style.backgroundColor
        color:              styleElement.style.color

    JSColor.requireImage 'cross.gif'
    JSColor.requireImage 'arrow.gif'

    
    try
      @importColor()
    catch err
      $.log err
      $.log err.stack