module AccountsHelper
  def display_account(account, image = false)
    if image
      image_tag(account.profile_image_url, {:height => 48, :width => 48, :class => 'photo fn', :alt => account.login}) + account.login
    else
      return account.login
    end
  end
  
  def link_account(account, image = false)
    return link_to(display_account(account, image), "http://twitter.com/#{account.login}", {:class => 'person url'})
  end
end
