require 'commit_status_checker'

class PushStatusChecker < CommitStatusChecker
  def initialize(push)
    @push = push
  end

  def check_and_update
    Rails.logger.info("PushStatusChecker#check_and_update for push #{@push.user_name}/#{@push.repo_name}:#{@push.commits.map(&:id).join(',')}")
    return unless repo_agreement

    @push.commits.each do |commit|
      check_commit(commit)
    end
  end
end
