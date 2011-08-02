# Be sure to restart your server when you modify this file.

# These settings change the behavior of Rails 2 apps and will be defaults
# for Rails 3. You can remove this initializer when Rails 3 is released.

if defined?(Footnotes)
  Footnotes::Filter.no_style = true 
  Footnotes::Filter.multiple_notes = true
  Footnotes::Filter.notes = [:session, :cookies, :params, :filters, :routes, :env, :queries, :log, :general, :current_user]
end

