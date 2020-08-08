struct Exp end
(::Exp)(input::Variable)::Variable = _function(x -> exp.(x), input)
