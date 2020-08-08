struct Exp <: _Function end
(::Exp)(input::Variable)::Variable = _function(x -> exp.(x), input)
