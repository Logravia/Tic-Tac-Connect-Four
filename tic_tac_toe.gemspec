# frozen_string_literal: true

require_relative 'lib/tic_tac_toe/version'

Gem::Specification.new do |spec|
  spec.name          = 'tic_tac_toe'
  spec.version       = TicTacToe::VERSION
  spec.authors       = ['Logravia']
  spec.email         = ['j.alunans@gmail.com']

  spec.summary       = 'Game of tic tac toe run through a console'
  spec.description   = 'I am gonna do it that later'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
