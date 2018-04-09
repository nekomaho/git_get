require 'pry'
require 'github_api'

class Search
  attr_reader :search_result

  def initialize(github, query)
    @search_results ||= github.search.issues query
  end

  def urls
    @search_results.body.items.map{ |result| result.html_url }
  end
end

# TODO: use OptionParser
user = ARGV[0]
repo = ARGV[1]
commit_sha = ARGV[2]
display_option = ARGV[3] || nil

git = Github.new user: user, repo: repo, oauth_token: ENV['GIT_HUB_AUTH_TOKEN']
urls = Search.new(git, commit_sha).urls
if display_option
  puts urls.sort.each {|result| '#{result}\n'}
else
  puts urls.sort.first
end
