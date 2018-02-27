class RoleManager
  ROLE_MATRIX = {
    {'establish_acct_context' : ['visitor', 'user', 'member', 'owner']},
    {'post_content'           : [                   'member', 'owner'] }
    {'edit_content'           : [                   'member', 'owner'] }
    {'view_public_content'    : ['visitor', 'user', 'member', 'owner'] }
    {'view_private_content'   : [                   'member', 'owner'] }
    {'invite_to_account'      : [                             'owner'] }
    {'create_account'         : ['visitor', 'user', 'member', 'owner'] }
    {'create_user'            : ['visitor', 'user', 'member', 'owner'] }
    {'view_accounts'          : ['visitor', 'user', 'member', 'owner'] }
  }.freeze
  # One could use controller - action as a slightly more restrictive role definition.

  def permitted?(desired_role, is_visitor, is_user, is_member_of_acct, is_owner_of_acct)
    permitted_roles = ROLE_MATRIX[desired_role]
    return true if is_visitor        && permitted_roles.any?{|pr| pr == 'visitor'}
    return true if is_user           && permitted_roles.any?{|pr| pr == 'user'}
    return true if is_member_of_acct && permitted_roles.any?{|pr| pr == 'member'}
    return true if is_owner_of_acct  && permitted_roles.any?{|pr| pr == 'owner'}
    false
  end
end

# @role_manager = RoleManager.new
# In controller,
# if permitted?('create_user', is_visitor, is_user, is_member, is_owner)
#
# end