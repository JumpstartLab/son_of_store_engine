class Store < ActiveRecord::Base
  STATUSES = %w{ approved pending declined disabled }

  attr_accessible :name, :slug, :description, :status

  validates :name, :presence => true,
                   :uniqueness => true
  validates :slug, :presence => true,
                   :uniqueness => true

  has_many :carts
  has_many :categories
  has_many :credit_cards
  has_many :orders, :extend => FindByStatusExtension
  has_many :products
  has_many :shipping_details
  # has_many :store_users
  # has_many :users, :through => :store_users

  has_many :roles
  has_many :users, :through => :roles

  STATUSES.each do |status|
    define_method(status+"!") do
      self.status = status
    end

    define_method(status+"?") do
      self.status == status
    end

    scope status.to_sym, where(:status => status)
  end

  def stockers
    Role.where(:store_id => self.id).select { |role| role.name == "store_stocker" }
  end

  def creator
    Role.where(:store_id => self.id).select { |role| role.name == "store_admin" }.first
  end

  def admins
    Role.where(:store_id => self.id).select { |role| role.name == "store_admin" }
  end

  def active_products
    products.where(:retired => false)
  end

  def retired_products
    products.where(:retired => true)
  end

  def update_status(params)
    if params[:status] == "approved"
      self.status = "approved"
    elsif params[:status] == "declined"
      self.status = "declined"
    elsif params[:status] == "disabled"
      self.status = "disabled"
    end
    self
  end

  def notify_store_admin_of_status
    # TODO: do we need to add email for created stores?
    if status == "approved"
      Resque.enqueue(Emailer, "store_approval_notification", id)
    elsif status == "declined"
      Resque.enqueue(Emailer, "store_declined_notification", id)
    end
  end

end
