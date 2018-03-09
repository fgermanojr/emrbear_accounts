module RoleManager
  class RoleManager
    ROLE_MATRIX = {
      #      action               roles that can perform that action
      :establish_acct_context => ['visitor', 'user', 'member', 'owner'             ],
      :post_content           => [                   'member', 'owner'             ],
      :edit_public_content    => [                   'member', 'owner'             ],
      :edit_private_content   => [                                     'my_content'],
      :view_public_content    => ['visitor', 'user', 'member', 'owner'             ],
      :view_private_content   => [                   'member', 'owner'             ],
      :invite_to_account      => [                             'owner'             ],
      :create_account         => ['visitor', 'user', 'member', 'owner'             ],
      :create_user            => ['visitor', 'user', 'member', 'owner'             ],
      :view_accounts          => ['visitor', 'user', 'member', 'owner'             ]
      # Note 5 of above, are the same as all roles; could add an 'all' role above.
      # I could also add 'admin' at the end; 'all 'would be added in the beginning.
      # Or admin could be handled directly in the few places it might me needed.
      # Set up tests for the class.
    }.freeze

    # One could use [controller, action] to name action; but I prefer
    # the broader "business action" used here; using an action name not tied to
    # implementation makes sense; and, with a large number of similiar
    # controllers, the higher level of naming of a business action, will result
    # in many fewer actions needing to be defined.

    # Also, you want to protect new/create actions; block the form presentation
    # and the actual processing of the action.

    # Is the activity permitted in current context, attempting a controller action,
    #  the role set that person has in this context is defined by each of the
    #  is_<role> functions.
    #  is_visitor and is_user won't be both true, an observation
    #  is_owner_of_account.  for current_account context did the current user create it
    #  is_member_of_account. for current_account context is the current user a member of the account
    # IMPROVEMENT: put all is_'s in context array or hash, e.g.
    # make context, check reserved word, an instance of a class, role_manager_context < struct
    # it is the set of is_ keywords, yes?
    # context === {is_visitor: false, is_user: true is_member_of_acct: true, is_owner_of_acct: false}
    # so permitted?(activity, context)

    # So some actions are permitted? at the create of new/create controller-actions,
    # for example content post. user can't post if a visitor, so don't show new form.
    # For actions permitted to all, on could simple NOT put the permitted? before_action.
    # Put permitted? calls in before_action in controllers.

    def permitted?(activity, context)
      is_visitor, is_user, is_member_of_acct, is_owner_of_acct, is_owner_of_content = context
      return true if is_visitor          && permitted_roles_for_action(activity).include?('visitor')
      return true if is_user             && permitted_roles_for_action(activity).include?('user')
      return true if is_member_of_acct   && permitted_roles_for_action(activity).include?('member')
      return true if is_owner_of_acct    && permitted_roles_for_action(activity).include?('owner')
      return true if is_owner_of_content && permitted_roles_for_action(activity).include?('my_content')
    end

    def permitted_roles_for_action(activity)
      ROLE_MATRIX[activity]
    end

    def permitted_actions_for_roles(role) # test in console
      arry = []
      ROLE_MATRIX.each {|k, v| arry << k if v.include?(role)}.uniq
      # ROLE_MATRIX.each_with_object([]) do |action_role_k_v, permitted_actions|
      #   permitted_actions << action_role_k_v[0] if action_role_k_v[1].include?(role)
      # end.uniq
      # Is this clearer ? No
    end
  end

  class RoleManagerDbms # This is not complete; it is a future altrnate implementation
    def create_database_representation
      # the action, in the business_action sense, called operations table in the database
      # the action - role representation defined in the class RoleManager is used
      # to load a database instance once;
      # one could use a config/role_manager.yaml definition; loaded in config/role_manager.rb

      # create the roles of RM  RoleManager::ROLE_MATRIX

      # create the operations from business actions of RM

      # cycle the business actions of RM, for each  store operation with business_action <<after migration

    end

    def permitted?(activity, is_visitor, is_user, is_member_of_acct, is_owner_of_acct)
      # activity.roles
    end

    # This implementation uses the roles - permitteds - operation database tables
    # in the methods operations are called actions or activities

    # create_table "operations", force: :cascade do |t|
    #   t.string "business_action:  # Replaces controller, action below
    #   t.string "op_controller" # Keeping, drop later
    #   t.string "op_action" # Keeping, drop later
    #   t.datetime "created_at", null: false
    #   t.datetime "updated_at", null: false
    #   t.index ["op_controller", "op_action"], name: "index_operations_on_op_controller_and_op_action"
    # end

    # create_table "permitteds", id: false, force: :cascade do |t|
    #   t.integer "role_id"
    #   t.integer "operation_id"
    #   t.string "type"
    #   t.index ["operation_id"], name: "index_permitteds_on_operation_id"
    #   t.index ["role_id"], name: "index_permitteds_on_role_id"
    # end

    # create_table "roles", force: :cascade do |t|
    #   t.string "name"
    #   t.datetime "created_at", null: false
    #   t.datetime "updated_at", null: false
    #   t.index ["name"], name: "index_roles_on_name"
    # end

  end
end

# @role_manager = RoleManager.new
# In controller,
# if permitted?('create_user', is_visitor, is_user, is_member, is_owner)
#
# end
