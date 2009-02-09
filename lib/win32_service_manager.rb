require 'win32_service_manager/core_ext/struct_to_hash'

class Win32ServiceManager

  VERSION = '0.1.3'
  def self.version; VERSION; end
  def self.load_dependencies; require 'win32/service'; end

  # Construct a new service manager, just sets up a name_key, which is used
  # as a leading string to the name of all services managed by the instance.
  def initialize(name_key = '')
    self.class.load_dependencies
    @name_key = name_key
  end

  # Create a new service. The service name will be appended to the name_key
  # and inserted into the registry using Win32::Service.
  # One recommended pattern is to store persisence details about the service
  # as yaml in the optional description field.
  def create(name, command, description = nil, options = {})
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

  # Schedule the service for start
  def start(name)
    Win32::Service.start(n(name))
  end

  # Schedule the service for stop
  def stop(name)
    Win32::Service.stop(n(name))
  end

  # Returns an array of hashes derived from the Win32::Service::SvcInfo struct
  # The optional argument will cut the array down to a single element for a 
  # service with the given name.
  def status(name = nil)
    list = name ? services.select { |s| s.display_name == name } : services
    list.map { |svc_info| svc_info.to_hash }
  end
  alias_method :list, :status

  # List all services that have names which start with the name_key.
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