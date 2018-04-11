require 'pry'
require 'github_api'
require 'optparse'

class Search
  attr_reader :search_result

  def initialize(github, query)
    @search_results ||= github.search.issues query
  end

  def urls
    @search_results.body.items.map{ |result| result.html_url }
  end
end

class CommandLineOption
  def initialize
    params = {}

    OptionParser.new do |opt|
      opt.banner = 'Usage: git_get.rb [options] commit_sha'
      opt.version = '0.0.1'

      opt.on('-u USER', '--user') { |v| params[:user] = v }
      opt.on('-r REPO', '--repository') { |v| params[:repository] = v }
      opt.on('-a', '--all') { params[:all] = true }

      opt.parse!(ARGV)
    end
    @params = params
  end

  def user
    raise "must input -u USER" unless @params.has_key?(:user)
    @user ||= @params[:user]
  end

  def repo
    raise "must input -r REPO" unless @params.has_key?(:repository)
    @repo ||= @params[:repository]
  end

  def sha
    raise "must input commit sha" unless ARGV[0]
    @sha ||= ARGV[0]
  end

  def disp_all?
    @params.has_key?(:all)
  end
end

input = CommandLineOption.new

git = Github.new user: input.user, repo: input.repo, oauth_token: ENV['GIT_HUB_AUTH_TOKEN']
urls = Search.new(git, input.sha).urls

if input.disp_all?
  puts urls.sort.each {|result| '#{result}\n'}
else
  puts urls.sort.first
end
