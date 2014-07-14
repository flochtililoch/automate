{randomBytes} = require 'crypto'
request       = require 'request'
url           = require 'url'
qs            = require 'qs'
config        = require './config'
{extend}      = require 'underscore'

class AutomaticAPIClient

  auth: config.auth
  api:  config.api

  constructor: ({@appId, @appSecret, @accessToken}) ->
    @state = randomBytes(48).toString('hex')

    @getAccessToken = (done) ->
      now = (new Date).getTime()

      if @accessToken
        {expiresAt, refreshToken, scope} = @accessToken

        return done noErr, @accessToken unless expiresAt < now

        params =
          refresh_token: refreshToken
          scope:         scope
          grant_type:    'refresh_token'

      else
        params =
          client_id:     @appId
          client_secret: @appSecret
          code:          @code
          grant_type:    'authorization_code'

      {baseUrl, accessTokenUrl} = @auth

      options =
        method: 'POST'
        url: "#{baseUrl}#{accessTokenUrl}"
        form: params

      request options, (error, data, response) =>
        return done error if error?

        {access_token, refresh_token, expires_in, scope, user, token_type} = JSON.parse response

        @accessToken =
          accessToken:  access_token
          refreshToken: refresh_token
          expiresAt:    now + expires_in
          scope:        scope
          user:         user
          type:         token_type

        done noErr, @accessToken

    @fetch = (options, done) ->
      options = extend {}, options
      return done new Error('uri is required') unless options.uri?

      @getAccessToken (err, {accessToken}) =>
        return done err if err?

        options.uri = "#{@api.baseUrl}#{options.uri}"
        options.headers ?= {}
        options.headers['Authorization'] = "#{@auth.method} #{accessToken}"

        request options, done

  getAuthorizeUrl: ->
    {baseUrl, authorizeUrl, scopes, scopesSeparator, responseType} = @auth

    query = qs.stringify
      client_id:     @appId
      scope:         scopes.join scopesSeparator
      response_type: responseType
      state:         @state

    "#{baseUrl}#{authorizeUrl}?#{query}"

  setAccessToken: (token) ->
    @accessToken = JSON.parse token

  accessGranted: ({state, code}, done) ->
    return done new Error('Invalid state') unless state is @state

    @code = code
    @getAccessToken done

  getTrips: (options = {}, done) ->
    options.uri = '/trips'
    @fetch options, done

  getTrip: (options = {}, done) ->
    return done new Error('id is required') unless options.id?
    options.uri = "/trips/#{options.id}"
    delete options.id
    @fetch options, done


module.exports.AutomaticAPIClient = AutomaticAPIClient


noErr = null
