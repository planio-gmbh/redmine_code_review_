# Code Review plugin for Redmine
# Copyright (C) 2010  Haruyuki Iida
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

class CodeReviewAssignment < ActiveRecord::Base
  belongs_to :issue
  belongs_to :change
  belongs_to :changeset
  belongs_to :attachment
  validates_presence_of :issue_id

  def is_closed?
    issue.closed?
  end

  def path
    file_path
  end

  def revision
    return rev if rev
    changeset.revision if changeset
  end

  def self.create_with_changeset(changeset)
    project = changeset.project
    setting = CodeReviewProjectSetting.find_or_create(project)
    auto_assign = setting.auto_assign_settings
    assignment = CodeReviewAssignment.new
    issue = Issue.new
    issue.subject = l(:code_review_requrest)
    issue.tracker_id = setting.assignment_tracker_id
    issue.project = project
    issue.author = User.find(auto_assign.author_id)
    issue.assigned_to_id = auto_assign.select_assign_to(project)
    issue.description = auto_assign.description

    issue.save!
      
    assignment.issue_id = issue.id
    assignment.changeset_id = changeset.id
    assignment.save!

  end

  
end
