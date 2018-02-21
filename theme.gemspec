# coding: utf-8

Gem::Specification.new do |spec|
    spec.name          = "theme"
    spec.version       = "1.1"
    spec.authors       = ["Fábio Miranda"]
    spec.email         = ["fabiomirandadev@gmail.com"]

    spec.summary       = %q{Meu blog pessoal de desenvolvimento e muito mais.}
    spec.homepage      = "https://github.com/fabiomirandaa/fabiomirandaa.github.io"
    spec.license       = "MIT"

    spec.files         = `git ls-files -z`.split("\x0").select do |f|
        f.match(%r{^(assets|pages|_(includes|layouts|sass)/|(LICENSE|README|search.html)((\.(txt|md|markdown)|$)))}i)
    end

    spec.add_runtime_dependency "jekyll", "~> 3.4"
    spec.add_runtime_dependency "jekyll-paginate", "~> 1.1"

    spec.add_development_dependency "bundler"
    spec.add_development_dependency "rake", "~> 10.0"
end