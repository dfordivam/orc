# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  # navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items. Defaults to 'selected'
  # navigation.selected_class = 'your_selected_class'
  navigation.selected_class = 'active'

  # Item keys are normally added to list items as id.
  # This setting turns that off
  # navigation.autogenerate_item_ids = false

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # Define the primary navigation
  navigation.items do |primary|
    primary.dom_class = "navigation"
    # Add an item to the primary navigation. The following params apply:
    # key - a symbol which uniquely defines your navigation item in the scope of the primary_navigation
    # name - will be displayed in the rendered navigation. This can also be a call to your I18n-framework.
    # url - the address that the generated item links to. You can also use url_helpers (named routes, restful routes helper, url_for etc.)
    # options - can be used to specify attributes that will be included in the rendered navigation item (e.g. id, class etc.)
    if @controller.controller_name == "visitors" && @controller.action_name == "new"
      primary.item :registration, 'Registration', new_visitor_path, :highlights_on => /\/visitors/
      primary.item :visitors, 'Visitors', visitors_path
    else
      primary.item :registration, 'Registration', new_visitor_path
      primary.item :visitors, 'Visitors', visitors_path, :highlights_on => /\/visitors/
    end
#    primary.item :visitors, 'Visitors', visitors_path, :highlights_on => /\/visitors/
    primary.item :buildings, 'Buildings', buildings_path, :highlights_on => /\/buildings/ if can? :update, @user
    primary.item :events, 'Events', events_path, :highlights_on => /\/events/ if can? :update, @user
    primary.item :checkins, 'Checkins', checkins_path, :highlights_on => /\/checkins/
    if current_user.username  == SUPERADMIN
      primary.item :users, 'Users', users_path, :highlights_on => /\/users/
    else
      primary.item :edit_profile, 'Edit profile', edit_user_path(current_user), :highlights_on => /\/users/
    end
    if current_user.role.rolename == ADMIN
      primary.item :utilities, 'Utilities', utilities_path, :highlights_on => /\/utilities/
    end
#    primary.item :feeds, 'Feeds', feeds_path, :highlights_on => /\/feeds/
#    primary.item :carousels, 'Carousels', carousels_path, :highlights_on => /\/(carousels|carousel_configs)/
#    primary.item :blocks, 'Blocks', blocks_path, :highlights_on => /\/blocks/
#    primary.item :pages, 'Pages', pages_path, :highlights_on => /\/pages/
#    primary.item :pages, 'Articles', articles_path, :highlights_on => /\/articles/
#    primary.item :pages, 'Menus', menus_path, :highlights_on => /\/menus/
#    primary.item :users, 'Users', users_path, :highlights_on => /\/users/

    # # Add an item which has a sub navigation (same params, but with block)
    # primary.item :key_2, 'name', url, options do |sub_nav|
    #   # Add an item to the sub navigation (same params again)
    #   sub_nav.item :key_2_1, 'name', url, options
    # end

    # You can also specify a condition-proc that needs to be fullfilled to display an item.
    # Conditions are part of the options. They are evaluated in the context of the views,
    # thus you can use all the methods and vars you have available in the views.
    # primary.item :key_3, 'Admin', url, :class => 'special', :if => Proc.new { current_user.admin? }
    # primary.item :key_4, 'Account', url, :unless => Proc.new { logged_in? }

    # you can also specify a css id or class to attach to this particular level
    # works for all levels of the menu
    # primary.dom_id = 'menu-id'
    # primary.dom_class = 'menu-class'

    # You can turn off auto highlighting for a specific level
    # primary.auto_highlight = false

  end

end