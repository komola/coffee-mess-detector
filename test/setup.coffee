global.Detector = require "../index"
{inspect} = require "util"

# Import chai should support
should = require("chai").should()

global.test = it

global.getScore = (code, debug = false) ->
  detective = new Detector code
  if debug
    console.log "\n------------------------"
    console.log code
    console.log inspect detective.expressions, false, null
  detective.score

