Fabricator(:store_admin_permission, class_name: StorePermission) do
  user_id   { Fabricate(:user) }
  store_id  { Fabricate(:store) }
  permission_level  1
end

Fabricator(:store_stocker_permission, class_name: StorePermission) do
  user_id   { Fabricate(:user) }
  store_id  { Fabricate(:store) }
  permission_level  2
end

Fabricator(:store_permission, :class_name => StorePermission) do
  user_id sequence
  store_id sequence
  permission_level 1
end