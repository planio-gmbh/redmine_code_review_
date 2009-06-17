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

require_dependency 'changeset'

module CodeReviewChangesetPatch
  def self.included(base) # :nodoc:
    base.send(:include, ChangesetInstanceMethodsCodeReview)

    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development      
    end

  end
end

module ChangesetInstanceMethodsCodeReview
  def review_count
    return @review_count if @review_count
    @review_count = 0
    changes.each{|change|
      @review_count += change.review_count
    }
    return @review_count
  end

  def open_review_count
    return @open_review_count if @open_review_count
    @open_review_count = 0
    changes.each{|change|
      @open_review_count += change.open_review_count
    }
    return @open_review_count
  end

  def closed_review_count
    review_count - open_review_count
  end
end

Changeset.send(:include, CodeReviewChangesetPatch)
