Fabricator(:store_permission, :class_name => StorePermission) do
  user_id sequence
  store_id sequence
  permission_level 1
end