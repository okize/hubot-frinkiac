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
  searchUrl = 'https://frinkiac.com/api/search'
  captionUrl = 'https://frinkiac.com/api/caption'
  url = if endpoint is 'search' then searchUrl else captionUrl
  return {
    method: 'get'
    url: url
    params: params
  }

encode = (str) ->
  encodeURIComponent(str).replace /[!'()*]/g, (c) ->
    '%' + c.charCodeAt(0).toString(16)

addLineBreaks = (str) ->
  newString = ''
  str.split(' ').forEach (word, i) ->
    i++
    delimiter = if i % 4 then ' ' else '\n'
    newString += word + delimiter
  newString

getImageUrl = (episode, timestamp, caption) ->
  encodedUrl = encode(addLineBreaks(caption))
  "https://frinkiac.com/meme/#{episode}/#{timestamp}.jpg?lines=#{encodedUrl}"

module.exports = (robot) ->
  robot.respond /(simpsons search|frinkiac) (.*)/i, (msg) ->
    query = msg.match[2]

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
