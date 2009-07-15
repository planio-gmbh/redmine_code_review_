# Code Review plugin for Redmine
# Copyright (C) 2009  Haruyuki Iida
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
require File.dirname(__FILE__) + '/../test_helper'

class CodeReviewTest < Test::Unit::TestCase
  fixtures :code_reviews, :projects, :users, :repositories, :changesets, :changes, :issues, :issue_statuses , :enumerations, :issue_categories, :trackers

  # Create new object.
  def test_create
    code_review = CodeReview.new
    code_review.issue = Issue.new
    assert !code_review.save
    code_review.project_id = 1
    code_review.issue.project_id = 1
    code_review.comment = "aaa"
    code_review.user_id = 1;
    code_review.change_id = 1;
    code_review.updated_by_id = 1;
    code_review.subject = "aaa"

    assert code_review.save
    
    code_review.destroy
  end

  def test_close
    code_review = newreview
    assert !code_review.is_closed?
    code_review.close
    assert code_review.is_closed?
  end

  def test_reopen
    code_review = newreview
    code_review.close
    assert code_review.is_closed?
    code_review.reopen
    assert !code_review.is_closed?
  end

  def test_committer
    code_review = CodeReview.find(1)
    assert_equal(3, code_review.committer.id)
  end

  def test_path
    code_review = CodeReview.find(1)
    assert_equal("/test/some/path/in/the/repo", code_review.path)
  end

  def test_revision
    code_review = CodeReview.find(1)
    assert_equal("1", code_review.revision)
  end

  def test_repository
    code_review = CodeReview.find(1)
    assert_equal(10, code_review.repository.id)
  end

  private
  def newreview
    code_review = CodeReview.new
    code_review.issue = Issue.new
    code_review.project_id = 1;
    code_review.comment = "aaa"
    code_review.user_id = 1;
    code_review.change_id = 1;
    code_review.updated_by_id = 1;
    return code_review
  end

  def test_is_closed?
    review = CodeReview.find(1)
    assert !review.is_closed?
    review = CodeReview.find(4)
    assert review.is_closed?
  end

  def test_subject
    review = CodeReview.find(1)
    assert_equal(review.subject, review.issue.subject)
    review.subject = "aaaa"
    assert_equal("aaaa", review.issue.subject)
  end
end
