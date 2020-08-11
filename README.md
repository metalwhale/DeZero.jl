# DeZero.jl
Implementation of [ゼロから作るDeep Learning ❸](https://www.oreilly.co.jp/books/9784873119069/) in Julia

## How to run
- Start the container:
```
host$ docker-compose up -d
```

- Get into the container then run examples:
```
host$ docker-compose exec dezero bash
container# julia
julia>
(@v1.4) pkg> activate .
(DeZero) pkg> test
```

- Clean up after finished:
```
julia> exit()
container# exit
host$ docker-compose down
```
