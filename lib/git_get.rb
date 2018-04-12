require 'pry'
require 'github_api'
require 'optparse'

class SearchItem
  attr_reader :search_result

  def initialize(github, query)
    @github = github
    @query = query
  end

  def exec
    @github.search.issues(@query).body.items.map do |item|
      ItemResult.new(item)
    end
  end
end

class ItemResult
  def initialize(item)
    @item = item
  end

  def number
    @item.number
  end

  def url
    @item.html_url
  end

  def title
    @item.title
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
item_results = SearchItem.new(git, input.sha).exec.sort_by { |item| item.number }

if input.disp_all?
  item_results.each do |item_result|
    puts "#{item_result.url} : #{item_result.title}"
  end
else
  puts "#{item_results.first.url} : #{item_results.first.title}"
end
