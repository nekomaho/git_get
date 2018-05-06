require 'pry'
require 'pr_get'
require 'optparse'

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
pr_git = PrGet.new user: input.user, repo: input.repo, oauth_token: ENV['GIT_HUB_AUTH_TOKEN']
item_results = pr_git.search(sha: input.sha)

if input.disp_all?
  item_results.each do |item_result|
    puts "#{item_result.url} : #{item_result.title}"
  end
else
  puts "#{item_results.first.url} : #{item_results.first.title}"
end
