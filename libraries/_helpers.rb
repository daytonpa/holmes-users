#
# Cookbook:: holmes-users
# Library:: helpers
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# Validate SSH options
def y_or_n(option)
  case option
  when 'yes', 'no'
    true
  else
    false
  end
end

# Check if nil or an empty string
def empty(option)
  case option
  when '', nil
    true
  else
    false
  end
end
