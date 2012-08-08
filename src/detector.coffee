coffee = require "coffee-script"

module.exports = class Detector
  score: 0
  multiplier: 1
  expressions: {}

  weights:
    # Class method
    classMethod: 5
    # This will be added in top of normal class method
    privateClassMethod: 2.5
    # if, while
    condition: 1.2
    operators:
      ">":     1.2
      "<":     1.2
      "==":    1.2
      "===":    1.2
      "!=":    1.2
      "!":     1.2


  constructor: (@expressions, @multiplier = 1) ->
    if typeof @expressions is "string"
      @expressions = @_parse @expressions

    @process()

  process: ->
    iterator = @expressions.expressions
    iterator ||= @expressions.properties

    for leaf in iterator
      @_callProcessors leaf

  # Process the body of an expression
  # This means we will dive one layer deeper
  process_body: (leaf) ->
    # TODO increase multiplier
    inner = new Detector leaf.body, @multiplier
    @_addToScore inner.score

  # Process the content of classes
  process_base: (leaf) ->
    if leaf.base.properties
      inner = new Detector leaf.base, @multiplier
      @_addToScore inner.score

  # Process the body of a class method
  process_value: (leaf) ->
    if leaf.value.body
      inner = new Detector leaf.value.body, @multiplier
      @_addToScore inner.score


  # Check if a class method is marked as a private class
  process_variable: (leaf) ->
    if leaf.variable.this
      @_addToScore @weights.privateClassMethod

  # Process a class method
  process_context: (leaf) ->
    if leaf.context is "object"
      @_addToScore @weights.classMethod

  # Process conditions that create a branch
  # This are:
  #
  # * if
  # * while
  process_condition: (leaf) ->
    @_addToScore @weights.condition

    # Condition has an operator
    if leaf.condition.operator
      usedOperator = leaf.condition.operator

      if @weights.operators[usedOperator]
        @_addToScore @weights.operators[usedOperator]

      else
        console.info "Did not find a weight for", usedOperator

  ## Private
  _parse: (code) ->
    coffee.nodes code

  _callProcessors: (leaf) ->
    for key, value of leaf
      @["process_#{key}"] leaf if @["process_#{key}"]

      # unless @["process_#{key}"]
      #   console.log "No processor found for #{key}"

  _addToScore: (score) ->
    @score += score * @multiplier
