describe "Detector", ->
  describe "Conditions", ->
    test "if conditions score once", ->
      code = """
        true if true """

      getScore(code).should.equal 1.2

    test "nested if conditions score twice", ->
      code = """
        if true
          true if true """

      getScore(code).should.equal 1.2 * 2

    test "if conditions with operator increases score", ->
      code = """
        true if a < 1"""

      getScore(code).should.equal 1.2 + 1.2

    test "while loop scores once", ->
      code = """
      "" while true """

      getScore(code).should.equal 1.2

    test "while loop with operator increases score", ->
      code = """
      "" while a < 1 """

      getScore(code).should.equal 2.4

