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
#   hubot simpsons me <query> | <caption override> - displays a screenshot from The Simpsons related to your search
#   hubot futurama me <query> | <caption override> - displays a screenshot from Futurama related to your search
#
# Notes:
#   None
#
# Author:
#   None

require('es6-promise').polyfill()
axios = require('axios')

franchiseServices = {
  "simpsons": "frinkiac.com",
  "futurama": "morbotron.com",
}

getRequestConfig = (franchise, endpoint, params) ->
  apiBaseUrl = getFranchiseServiceUrl(franchise)
  searchUrl = "#{apiBaseUrl}/api/search"
  captionUrl = "#{apiBaseUrl}/api/caption"
  url = if endpoint is 'search' then searchUrl else captionUrl
  return {
    method: 'get'
    url: url
    params: params
  }

encode = (str) ->
  encodeURIComponent(str).replace /[!'()*]/g, (c) ->
    '%' + c.charCodeAt(0).toString(16)

# we append '#.jpg' to url string because some chat clients (eg. hip chat)
# will not exapand images if they don't end in an image extension
getImageUrl = (franchise, episode, timestamp, caption) ->
  apiBaseUrl = getFranchiseServiceUrl(franchise)
  "#{apiBaseUrl}/meme/#{episode}/#{timestamp}.jpg?lines=#{encode(caption)}#.jpg"

getFranchiseServiceUrl = (franchise) ->
  if !franchise of franchiseServices then franchise = "simpsons"
  return "https://#{franchiseServices[franchise]}"

getLongestWordLength = (words) ->
  longestWordLength = 0
  words.forEach (word) ->
    longestWordLength = word.length if word.length > longestWordLength
  longestWordLength

getNumberOfWordsBeforeBreaking = (words) ->
  longestWordLength = getLongestWordLength(words)
  if longestWordLength <= 5
    wordsBeforeBreaking = 5
  else if 5 < longestWordLength <= 8
    wordsBeforeBreaking = 4
  else
    wordsBeforeBreaking = 3
  wordsBeforeBreaking

addLineBreaks = (str) ->
  newString = ''
  words = str.split(' ')
  wordsBeforeBreaking = getNumberOfWordsBeforeBreaking(words)
  words.forEach (word, i) ->
    i++
    delimiter = if i % wordsBeforeBreaking then ' ' else '\n'
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
  robot.respond /((simpsons|futurama) (search|me)|frinkiac) (.*)/i, (msg) ->
    franchise = msg.match[2] || "simpsons"
    query = msg.match[4].split('|')
    customCaption = query[1]

    axios(getRequestConfig(franchise, 'search', {q: query[0]}))
      .then (response) ->
        if (response.data.length)
          frame = Math.floor(Math.random() * response.data.length)
          episode = response.data[frame].Episode
          timestamp = response.data[frame].Timestamp

          if customCaption
            msg.send getImageUrl(franchise, episode, timestamp, formatCaption(customCaption))

          else
            axios(getRequestConfig(franchise, 'caption', {e: episode, t: timestamp}))
              .then (response) ->
                msg.send getImageUrl(franchise, episode, timestamp, combineCaptions(response.data.Subtitles))

        else
          console.log("D'oh! I couldn't find anything for `#{query[0]}`.");

      .catch (error) ->
        console.error(error);
