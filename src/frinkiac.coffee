# Description:
#   Hubot plugin for searching for Simpsons screencaps on Frinkiac
#
# Dependencies:
#   axios
#
# Configuration:
#   None
#
# Commands:
#   hubot simpsons search <query> - displays a screenshot from the simpsons related to your search
#
# Notes:
#   None
#
# Author:
#   None

axios = require('axios')

getRequestConfig = (endpoint, params) ->
  queryUrl = 'https://frinkiac.com/api/search'
  captionUrl = 'https://frinkiac.com/api/caption'
  switch endpoint
    when 'search'
      return {
        method: 'get'
        url: queryUrl
        params: params
      }
    when 'caption'
      return {
        method: 'get'
        url: captionUrl
        params: params
      }
    else
      throw new Error 'missing endpoint argument'

encode = (str) ->
  encodeURIComponent(str).replace /[!'()*]/g, (c) ->
    '%' + c.charCodeAt(0).toString(16)

getImageUrl = (episode, timestamp, caption) ->
  "https://frinkiac.com/meme/#{episode}/#{timestamp}.jpg?lines=#{encode(caption)}"

module.exports = (robot) ->
  robot.respond /(simpsons search|frinkiac) (.*)/i, (msg) ->
    query = msg.match[1]

    axios(getRequestConfig('search', {q: query}))
      .then (response) ->
        if (response.data.length)
          episode = response.data[0].Episode
          timestamp = response.data[0].Timestamp
          axios(getRequestConfig('caption', {e: episode, t: timestamp}))
            .then (response) ->
              caption = response.data.Subtitles[0].Content
              msg.send getImageUrl(episode, timestamp, caption)
        else
          console.log("D'oh! I couldn't find anything for `#{query}`.");
      .catch (error) ->
        console.error(error);
