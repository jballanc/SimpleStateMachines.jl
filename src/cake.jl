module Cake

import Base.step

abstract type State end
abstract type Transition end

InvalidState = ArgumentError

@enum Ingredient eggs flour sugar water butter baking_soda

struct NeedIngredients <: State
    gathered::Set{Ingredient}
    NeedIngredients(ingredients) = new(ingredients)
    NeedIngredients() = new(Set())
end

struct Gather <: Transition
    ingredient::Ingredient
end

struct MixBatter <: State
    remaining::Array{Ingredient}
    MixBatter(remaining) = new(remaining)
    MixBatter() = new([flour, sugar, baking_soda, water, eggs, butter])
end

struct Add <: Transition
    ingredient::Ingredient
end

struct RuinedBatter <: State end
struct RawBatter <: State end

struct Bake <: Transition
    temp::UInt64
end

struct TastyCake <: State end
struct BurntCake <: State end

step(::State, ::Transition) = throw(InvalidState)
step(state::RuinedBatter, ::Transition) = state

function step(state::NeedIngredients, transition::Gather)
    push!(state.gathered, transition.ingredient)
    state.gathered != Set(instances(Ingredient)) ? state : MixBatter()
end

function step(state::MixBatter, transition::Add)
    if state.remaining[1] == transition.ingredient
        popfirst!(state.remaining)
        isempty(state.remaining) ? RawBatter() : state
    else
        RuinedBatter()
    end
end

step(::RawBatter, transition::Bake) = transition.temp > 350 ? BurntCake() : TastyCake()

export InvalidState, eggs, flour, sugar, water, butter, baking_soda,
    NeedIngredients, Gather, MixBatter, Add, RuinedBatter, RawBatter, Bake,
    TastyCake, BurntCake, step

end
