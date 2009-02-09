require 'win32_service_manager/core_ext/struct_to_hash'

class Win32ServiceManager

  VERSION = '0.1.3'
  def self.version; VERSION; end
  def self.load_dependencies; require 'win32/service'; end

  # Construct a new service manager, just sets up a name_key, which is used
  # as a leading string to the name of all services managed by the instance.
  # srv_any_path must be a full path to srvany.exe.
  def initialize(name_key = '')
    self.class.load_dependencies
    @name_key = name_key
  end

  # Create a new service. The service name will be appended to the name_key
  # and inserted into the registry using Win32::Service. The arguments are 
  # then adjusted with win32-registry.
  # One recommended pattern is to store persisence details about the service
  # as yaml in the optional description field.
  def create(name, command, args = '', description = nil, options = {})
    defaults = {
      :service_type       => Win32::Service::WIN32_OWN_PROCESS,
      :start_type         => Win32::Service::AUTO_START,
      :error_control      => Win32::Service::ERROR_NORMAL
    }
    defaults.merge!(options)
    name = n(name)
    options = defaults.merge(
      :display_name       => name,
      :description        => description || name,
      :binary_path_name   => command
    )
    Win32::Service.create(name, nil, options)
  end

  # Mark a service for deletion (note, does not terminate the service)
  def delete(name)
    Win32::Service.delete(n(name))
  end

  def start(name)
    Win32::Service.start(n(name))
  end

  def stop(name)
    Win32::Service.stop(n(name))
  end

  # Returns an array of tuples of name and description
  def status(name = nil)
    list = name ? services.select { |s| s.display_name == name } : services
    list.map { |svc_info| svc_info.to_hash }
  end
  alias_method :list, :status

  def services
    Win32::Service.services.select do |svc|
      # TODO in future, 1.8.7, can use start_with?
      svc.display_name[0,@name_key.size] == @name_key
    end
  end

  private
  def n(name)
    @name_key + name.to_s
  end

end