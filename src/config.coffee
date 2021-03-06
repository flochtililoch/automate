module.exports =

  api:
    baseUrl:         'https://api.automatic.com/v1'

  auth:
    baseUrl:         'https://www.automatic.com/oauth'
    authorizeUrl:    '/authorize'
    accessTokenUrl:  '/access_token'
    method:          'token'
    responseType:    'code'
    scopesSeparator: ' '
    scopes: [
      'scope:location'
      'scope:vehicle'
      'scope:trip:summary'
      'scope:ignition:on'
      'scope:ignition:off'
      'scope:notification:speeding'
      'scope:notification:hard_brake'
      'scope:notification:hard_accel'
      'scope:region:changed'
      'scope:parking:changed'
      'scope:mil:on'
      'scope:mil:off'
    ]
