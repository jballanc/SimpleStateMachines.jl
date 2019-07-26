module RegEx

import Base: step, match

abstract type Matcher end

struct MatchChar{Char} <: Matcher
    next::Matcher
end

struct Wildcard <: Matcher
    next::Matcher
end

struct Or <: Matcher
    left::Matcher
    right::Matcher
    next::Matcher
end

struct Matched <: Matcher end

step(state::MatchChar{C}, ::Val{T}) where {C, T} = nothing
step(state::MatchChar{C}, ::Val{C}) where {C} = state.next
step(state::Wildcard, ::Any) = state.next

function step(state::Or, char::Val{C}) where {C}
    if step(state.left, char) == Matched() ||
        step(state.right, char) == Matched()
        state.next
    else
        nothing
    end
end

step(state::Matched, ::Any) = state
step(::Nothing, ::Any) = nothing

function match(regex::Matcher, string::AbstractString)
    chars = map(Val, collect(string))
    reduce(step, chars, init=regex) == Matched()
end

export MatchChar, Wildcard, Or, Matched, step, match

end
