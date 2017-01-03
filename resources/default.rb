actions :create
default_action :create

attribute :username, kind_of: String, name_attribute: true
attribute :password, kind_of: String, required: true

attribute :sensitive, kind_of: [TrueClass, FalseClass] # , default: true - see initialize below

# Chef will override sensitive back to its global value, so set default to true in init
def initialize(*args)
  super
  @sensitive = true
end
