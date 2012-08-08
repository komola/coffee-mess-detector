describe "Detector", ->
  describe "Class test", ->
    test "basic class scores", ->
      code = """
        class Test
          foo: -> ""
      """

      getScore(code).should.equal 5

    test "basic class with property", ->
      code = """
        class Test
          @foo: null
      """

      getScore(code).should.equal 7.5

    test "basic method with if condition", ->
      code = """
        class Test
          foo: ->
            true if true
      """

      getScore(code).should.equal 6.2

    test "basic method with complex condition", ->
      code = """
        class Test
          foo: ->
            true if true
      """

      getScore(code).should.equal 6.2