# Include hook code here
require File.join(File.dirname(__FILE__), 'app/helpers/dmt/dmt_helper.rb')
require File.join(File.dirname(__FILE__), 'app/helpers/dmt/dmt_icon_helper.rb')
require File.join(File.dirname(__FILE__), 'app/helpers/dmt/dmt_display_helper.rb')
require File.join(File.dirname(__FILE__), 'app/helpers/dmt/dmt_link_helper.rb')
require File.join(File.dirname(__FILE__), 'app/helpers/dmt/dmt_log_helper.rb')

ActionController::Base.send :include, Dmt::DmtHelper
ActionView::Base.send :include, Dmt::DmtIconHelper
ActionView::Base.send :include, Dmt::DmtDisplayHelper
ActionView::Base.send :include, Dmt::DmtLinkHelper
ActionView::Base.send :include, Dmt::DmtLogHelper
