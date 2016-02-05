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
#   hubot simpsons search <query> | <caption override> - displays a screenshot from the simpsons related to your search;
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

getImageUrl = (episode, timestamp, caption) ->
  "https://frinkiac.com/meme/#{episode}/#{timestamp}.jpg?lines=#{encode(caption)}"

addLineBreaks = (str) ->
  wordCount = 4
  newString = ''
  str.split(' ').forEach (word, i) ->
    i++
    delimiter = if i % wordCount then ' ' else '\n'
    newString += word + delimiter
  newString

trimWhitespace = (string) ->
  string.replace /^\s*|\s*$/g, ''

formatCaption = (caption) ->
  addLineBreaks(trimWhitespace(caption))

combineCaptions = (captions) ->
  if captions.length <= 4
    newCaption = ''
    captions.forEach (caption, i) ->
      newCaption += formatCaption(caption.Content)
      unless i == (captions.length - 1)
        newCaption += '\n'
    newCaption
  else
    captions[0].Content

module.exports = (robot) ->
  robot.respond /(simpsons search|frinkiac) (.*)/i, (msg) ->
    query = msg.match[2].split('|')
    customCaption = query[1]

    axios(getRequestConfig('search', {q: query[0]}))
      .then (response) ->
        if (response.data.length)
          episode = response.data[0].Episode
          timestamp = response.data[0].Timestamp

          if customCaption
            msg.send getImageUrl(episode, timestamp, formatCaption(customCaption))

          else
            axios(getRequestConfig('caption', {e: episode, t: timestamp}))
              .then (response) ->
                msg.send getImageUrl(episode, timestamp, combineCaptions(response.data.Subtitles))

        else
          console.log("D'oh! I couldn't find anything for `#{query[0]}`.");

      .catch (error) ->
        console.error(error);
