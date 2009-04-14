# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include TwitterClient
  
  before_filter :login_from_cookie

  helper :all # include all helpers, all the time
  layout 'global'
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '99bea78841abc35124a6ba4c7db841cc'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  protected
    
    def get_account
      @account = current_user.accounts.find_by_id(params[:account_id])
    end
end
