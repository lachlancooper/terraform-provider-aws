set :base_url, "https://www.terraform.io/"

activate :hashicorp do |h|
  h.name             = "terraform"
  h.releases_enabled = false
  h.github_slug      = "hashicorp/terraform"
end

require "/terraform-website/middleman_helpers"
helpers Helpers

# Provider-specific settings
config[:source] = "docs"
require 'rack/rewrite'
use Rack::Rewrite do
  rewrite %r{^\/docs/providers/[^\/]+/(.*)}, '/$1'
end
