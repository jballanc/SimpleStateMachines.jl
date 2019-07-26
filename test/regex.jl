using Test
using SimpleStateMachines.RegEx

@testset "RegEx" begin
    @testset "Simple Character Matches" begin
        matcher = MatchChar{'a'}(Matched())
        @test step(matcher, Val('a')) isa Matched
        @test step(matcher, Val('b')) |> isnothing
    end

    @testset "Wildcard Matches" begin
        matcher = Wildcard(Matched())
        @test step(matcher, Val('a')) isa Matched
        @test step(matcher, Val('b')) isa Matched
    end

    @testset "Or Matches" begin
        matcher = Or(MatchChar{'a'}(Matched()),
                     MatchChar{'b'}(Matched()),
                     Matched())
        @test step(matcher, Val('a')) isa Matched
        @test step(matcher, Val('b')) isa Matched
    end

    @testset "Combined Matchers" begin
        # r"(j|J).lia"
        regex = Or(
            MatchChar{'j'}(Matched()),
            MatchChar{'J'}(Matched()),
            Wildcard(
                MatchChar{'l'}(
                    MatchChar{'i'}(
                        MatchChar{'a'}(
                            Matched())))))
        @test match(regex, "Julia")
        @test match(regex, "julia")
        @test match(regex, "Julia!")
        @test match(regex, "Scala") == false
    end
end
