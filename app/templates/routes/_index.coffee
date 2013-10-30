path = require('path')

MOBILE_USERAGENTS = [
  "2.0 MMP", "240x320", "400X240", "AvantGo", "BlackBerry", "Blazer",
  "Cellphone", "Danger", "DoCoMo", "Elaine/3.0", "EudoraWeb",
  "Googlebot-Mobile", "hiptop", "IEMobile", "KYOCERA/WX310K", "LG/U990",
  "MIDP-2.", "MMEF20", "MOT-V", "NetFront", "Newt", "Nintendo Wii", "Nitro",
  "Nokia", "Opera Mini", "Palm", "PlayStation Portable", "portalmmm",
  "Proxinet", "ProxiNet", "SHARP-TQ-GX10", "SHG-i900", "Small", "SonyEricsson",
  "Symbian OS", "SymbianOS", "TS21i-10", "UP.Browser", "UP.Link", "webOS",
  "Windows CE", "WinWAP", "YahooSeeker/M1A1-R2D2", "iPhone", "iPod", "Android",
  "BlackBerry9530", "LG-TU915 Obigo", "LGE VX", "webOS", "Nokia5800"
]

_isMobile = (userAgent) ->
  for keyword in MOBILE_USERAGENTS
    if userAgent.indexOf(keyword) isnt -1
      return true
  return false

exports.index = (req, res) ->
  isMobile = _isMobile(req.headers["user-agent"])
  appName = "#{if isMobile then 'mobile-' else ''}#{process.env.APP_NAME or 'web'}"
  env = process.env.NODE_ENV or 'development'

  console.log "a new visit to #{appName} in #{env} mode"

  return res.render("#{appName}/#{env}", {
    env: env
    appName: appName
    locale: req.locale
  })


