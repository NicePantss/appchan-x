Favicon =
  init: ->
    $.ready ->
      Favicon.el      = $ 'link[rel="shortcut icon"]', d.head
      Favicon.el.type = 'image/x-icon'
      {href}          = Favicon.el
      Favicon.SFW     = /ws\.ico$/.test href
      Favicon.default = href
      Favicon.switch()

  switch: ->
    unreadDead  = Favicon.unreadDeadY = Favicon.unreadSFW   = Favicon.unreadSFWY  = Favicon.unreadNSFW  = Favicon.unreadNSFWY = 'data:image/png;base64,'
    switch Conf['favicon']
      when 'ferongr'
        Favicon.unreadDead  += '<%= grunt.file.read("src/General/img/favicons/ferongr/unreadDead.png",   {encoding: "base64"}) %>'
        Favicon.unreadDeadY += '<%= grunt.file.read("src/General/img/favicons/ferongr/unreadDeadY.png",  {encoding: "base64"}) %>'
        Favicon.unreadSFW   += '<%= grunt.file.read("src/General/img/favicons/ferongr/unreadSFW.png",    {encoding: "base64"}) %>'
        Favicon.unreadSFWY  += '<%= grunt.file.read("src/General/img/favicons/ferongr/unreadSFWY.png",   {encoding: "base64"}) %>'
        Favicon.unreadNSFW  += '<%= grunt.file.read("src/General/img/favicons/ferongr/unreadNSFW.png",   {encoding: "base64"}) %>'
        Favicon.unreadNSFWY += '<%= grunt.file.read("src/General/img/favicons/ferongr/unreadNSFWY.png",  {encoding: "base64"}) %>'
      when 'xat-'
        Favicon.unreadDead  += '<%= grunt.file.read("src/General/img/favicons/xat-/unreadDead.png",      {encoding: "base64"}) %>'
        Favicon.unreadDeadY += '<%= grunt.file.read("src/General/img/favicons/xat-/unreadDeadY.png",     {encoding: "base64"}) %>'
        Favicon.unreadSFW   += '<%= grunt.file.read("src/General/img/favicons/xat-/unreadSFW.png",       {encoding: "base64"}) %>'
        Favicon.unreadSFWY  += '<%= grunt.file.read("src/General/img/favicons/xat-/unreadSFWY.png",      {encoding: "base64"}) %>'
        Favicon.unreadNSFW  += '<%= grunt.file.read("src/General/img/favicons/xat-/unreadNSFW.png",      {encoding: "base64"}) %>'
        Favicon.unreadNSFWY += '<%= grunt.file.read("src/General/img/favicons/xat-/unreadNSFWY.png",     {encoding: "base64"}) %>'
      when 'Mayhem'
        Favicon.unreadDead  += '<%= grunt.file.read("src/General/img/favicons/Mayhem/unreadDead.png",    {encoding: "base64"}) %>'
        Favicon.unreadDeadY += '<%= grunt.file.read("src/General/img/favicons/Mayhem/unreadDeadY.png",   {encoding: "base64"}) %>'
        Favicon.unreadSFW   += '<%= grunt.file.read("src/General/img/favicons/Mayhem/unreadSFW.png",     {encoding: "base64"}) %>'
        Favicon.unreadSFWY  += '<%= grunt.file.read("src/General/img/favicons/Mayhem/unreadSFWY.png",    {encoding: "base64"}) %>'
        Favicon.unreadNSFW  += '<%= grunt.file.read("src/General/img/favicons/Mayhem/unreadNSFW.png",    {encoding: "base64"}) %>'
        Favicon.unreadNSFWY += '<%= grunt.file.read("src/General/img/favicons/Mayhem/unreadNSFWY.png",   {encoding: "base64"}) %>'
      when '4chanJS'
        Favicon.unreadDead  += '<%= grunt.file.read("src/General/img/favicons/4chanJS/unreadDead.png",   {encoding: "base64"}) %>'
        Favicon.unreadDeadY += '<%= grunt.file.read("src/General/img/favicons/4chanJS/unreadDeadY.png",  {encoding: "base64"}) %>'
        Favicon.unreadSFW   += '<%= grunt.file.read("src/General/img/favicons/4chanJS/unreadSFW.png",    {encoding: "base64"}) %>'
        Favicon.unreadSFWY  += '<%= grunt.file.read("src/General/img/favicons/4chanJS/unreadSFWY.png",   {encoding: "base64"}) %>'
        Favicon.unreadNSFW  += '<%= grunt.file.read("src/General/img/favicons/4chanJS/unreadNSFW.png",   {encoding: "base64"}) %>'
        Favicon.unreadNSFWY += '<%= grunt.file.read("src/General/img/favicons/4chanJS/unreadNSFWY.png",  {encoding: "base64"}) %>'
      when 'Original'
        Favicon.unreadDead  += '<%= grunt.file.read("src/General/img/favicons/Original/unreadDead.png",  {encoding: "base64"}) %>'
        Favicon.unreadDeadY += '<%= grunt.file.read("src/General/img/favicons/Original/unreadDeadY.png", {encoding: "base64"}) %>'
        Favicon.unreadSFW   += '<%= grunt.file.read("src/General/img/favicons/Original/unreadSFW.png",   {encoding: "base64"}) %>'
        Favicon.unreadSFWY  += '<%= grunt.file.read("src/General/img/favicons/Original/unreadSFWY.png",  {encoding: "base64"}) %>'
        Favicon.unreadNSFW  += '<%= grunt.file.read("src/General/img/favicons/Original/unreadNSFW.png",  {encoding: "base64"}) %>'
        Favicon.unreadNSFWY += '<%= grunt.file.read("src/General/img/favicons/Original/unreadNSFWY.png", {encoding: "base64"}) %>'
    if Favicon.SFW
      Favicon.unread  = Favicon.unreadSFW
      Favicon.unreadY = Favicon.unreadSFWY
    else
      Favicon.unread  = Favicon.unreadNSFW
      Favicon.unreadY = Favicon.unreadNSFWY

  dead:  'data:image/png;base64,<%= grunt.file.read("src/General/img/favicons/dead.png",  {encoding: "base64"}) %>'
