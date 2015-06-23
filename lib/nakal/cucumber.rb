require_relative 'dsl'

World(Nakal::DSL)

Before do
  Nakal.diff_screens = []
end

After do
  if Nakal.diff_screens.size > 0
    raise "following screens do not match: \n #{Nakal.diff_screens}"
  end
end