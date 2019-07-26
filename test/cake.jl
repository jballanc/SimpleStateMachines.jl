using Test
using SimpleStateMachines.Cake

@testset "Cake" begin
    @testset "Step individual transitions" begin
        state = NeedIngredients()
        step(state, Gather(eggs))
        @test state.gathered == Set([eggs])
        wrong_transition = Add(eggs)
        try
            step(state, wrong_transition)
        catch err
            @test err == InvalidState
        end

        ingredients = Set([eggs, flour, sugar, butter, baking_soda])
        state = NeedIngredients(ingredients)
        @test step(state, Gather(eggs)).gathered == ingredients
        @test step(state, Gather(water)) isa MixBatter

        state = MixBatter([butter])
        @test step(state, Add(water)) isa RuinedBatter
        @test step(state, Add(butter)) isa RawBatter

        @test step(RawBatter(), Bake(400)) isa BurntCake
        @test step(RawBatter(), Bake(325)) isa TastyCake
    end

    @testset "Reduce over a recipe" begin
        ruined_batter = [Gather(eggs)
                         Gather(flour)
                         Gather(sugar)
                         Gather(water)
                         Gather(butter)
                         Gather(baking_soda)
                         Add(water)
                         Add(flour)
                         Add(sugar)
                         Add(butter)
                         Add(baking_soda)
                         Add(eggs)
                         Bake(400)]
        burnt_cake = [Gather(eggs)
                      Gather(flour)
                      Gather(sugar)
                      Gather(water)
                      Gather(butter)
                      Gather(baking_soda)
                      Add(flour)
                      Add(sugar)
                      Add(baking_soda)
                      Add(water)
                      Add(eggs)
                      Add(butter)
                      Bake(400)]
        tasty_cake = [Gather(eggs)
                      Gather(flour)
                      Gather(sugar)
                      Gather(water)
                      Gather(butter)
                      Gather(baking_soda)
                      Add(flour)
                      Add(sugar)
                      Add(baking_soda)
                      Add(water)
                      Add(eggs)
                      Add(butter)
                      Bake(325)]
        @test reduce(step, ruined_batter, init=NeedIngredients()) isa RuinedBatter
        @test reduce(step, burnt_cake, init=NeedIngredients()) isa BurntCake
        @test reduce(step, tasty_cake, init=NeedIngredients()) isa TastyCake
    end
end
