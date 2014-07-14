# Automatic API Wrapper

See [Automatic API](https://www.automatic.com/developer/) for more details.

## Installation

```bash
npm install automate --save
```

## Usage

```coffescript
express = require 'express'
cookieParser = require 'cookie-parser'
{AutomaticAPIClient} = require 'automate'

automaticAccessToken = 'automaticAccessToken'
api = new AutomaticAPIClient
  appId: '1234567890'     # replace with your app id
  appSecret: '1234567890' # replace with your app secred

app = express()

app.use cookieParser()

app.get '/', (req, res) ->
  accessToken = req.cookies[automaticAccessToken]
  res.redirect api.getAuthorizeUrl() unless accessToken

  # optionally define request parameters
  qs =
    page: req.query.page or 1
    max_per_page: 100

  api.setAccessToken accessToken
  api.getTrips {qs}, (err, response) ->
    res.end response.body

app.get '/redirect', (req, res) ->
  {state, code} = req.query
  api.accessGranted {state, code}, (err, token) ->
    return err if err?
    res.cookie automaticAccessToken, JSON.stringify(token), maxAge: new Date(token.expiresAt) - new Date()
    res.redirect '/'

app.listen 3070
```
