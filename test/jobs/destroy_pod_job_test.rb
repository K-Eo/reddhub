require "test_helper"

class DestroyPodJobTest < ActiveJob::TestCase
  test "removes pod" do
    pod = pods(:one)
    pod.update_attribute(:pending_delete, true)

    assert_difference "Pod.count", -1 do
      DestroyPodJob.perform_now(pod.id)
    end

    assert_raise ActiveRecord::RecordNotFound do
      pod.reload
    end
  end

  test "handling record not found" do
    pod = pods(:one)
    pod.destroy
    DestroyPodJob.perform_now(pod.id)
  end

  test "removes reactions" do
    pod = pods(:with_reactions)
    pod.update_attribute(:pending_delete, true)
    assert_difference "Reaction.count", -1 do
      DestroyPodJob.perform_now(pod.id)
    end
  end

  test "removes comments and reactions" do
    pod = pods(:pod_with_comments)
    pod.update_attribute(:pending_delete, true)
    assert_difference "Comment.count", -2 do
      DestroyPodJob.perform_now(pod.id)
    end
  end

  test "removes reactions related to comments" do
    pod = pods(:pod_with_comments)
    pod.update_attribute(:pending_delete, true)
    assert_difference "Reaction.count", -1 do
      DestroyPodJob.perform_now(pod.id)
    end
  end

  test "does not delete if pending delete is false" do
    pod = pods(:one)
    assert_no_difference "Pod.count" do
      DestroyPodJob.perform_now(pod.id)
    end
  end
end
