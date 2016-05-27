module Links
  class IndexPresenter
    def popular
      Link.where("clicks >= ?", 1).order(clicks: :desc)
    end

    def recent
      Link.order(created_at: :desc)
    end

    def top_users
      User.top_users
    end

    def user_links
      current_user.links.order(created_at: :desc) if logged_in?
    end
  end
end
