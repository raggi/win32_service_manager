require File.dirname(__FILE__) + '/helper'

# Because sometimes, I just wanna spec on another platform...
module Win32
  module Registry
    HKEY_LOCAL_MACHINE = self
    KEY_WRITE = self
    KEY_READ = self
    def self.method_missing(name, *args)
      self
    end
  end

  module Service
    WIN32_OWN_PROCESS, DEMAND_START, ERROR_NORMAL, AUTO_START = nil
    class <<self
      attr_accessor :services, :started, :stopped
    end
    
    SvcInfo = Struct.new(:name, :host, :options)
    class SvcInfo
      def display_name
        options[:display_name]
      end
    end

    def self.create(name, host, options)
      @services << SvcInfo.new(name, host, options)
    end

    def self.delete(name)
      @services.delete_if { |svc| svc.name == name }
    end

    def self.start(name)
      @started << name
    end

    def self.stop(name)
      @stopped << name
    end

    def self.services
      @services
    end

    def self.list
      @services
    end

    def self.clear!
      @services, @started, @stopped = [], [], []
    end
  end
end


describe 'Win32ServiceManager' do
  before do
    @prefix = 'SM_TEST_'
    @sm = Win32ServiceManager.new(@prefix)
    # N.B. this is a mock, setup in helper
    Win32::Service.clear!
  end

  should 'create services with name prefixes' do
    @sm.create('bar', 'false.exe')
    service_names = Win32::Service.list.select { |obj| obj.display_name }
    service_names.find { |s| s.name == @prefix + 'bar'}
    service_names.size.should.eql(1)
  end

  should 'delete services' do
    @sm.create('bar', 'false.exe')
    service_names = Win32::Service.list.select { |obj| obj.display_name }
    service_names.find{ |s| s.display_name == @prefix + 'bar' }.should.not.be.nil
    service_names.size.should.eql(1)
    @sm.delete('bar')
    service_names = Win32::Service.list.select { |obj| obj.display_name }
    service_names.should.not.include?(@prefix + 'bar')
    service_names.size.should.eql(0)
  end

  should 'list services' do
    @sm.create('bar', 'false.exe', 'args', 'descrip')
    @sm.list.find { |s| s[:name] == 'SM_TEST_bar' }.should.not.be.nil
    @sm.list.size.should.eql(Win32::Service.list.size)
  end
end

describe 'ServiceManager service control' do
  before do
    @prefix = 'SM_TEST_'
    @sm = Win32ServiceManager.new(@prefix)
    Win32::Service.clear!
    @name = 'test_service'
    @command = 'foo.exe'
    @sm.create(@name, @command)
  end

  should 'stop services' do
    @sm.stop(@name)
    Win32::Service.stopped.should.include?(@prefix + @name)
  end

  should 'start services' do
    @sm.start(@name)
    Win32::Service.started.should.include?(@prefix + @name)
  end
end
