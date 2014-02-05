#!/usr/bin/env ruby
require 'ffi'

module GeoIP
  extend FFI::Library
  ffi_lib 'GeoIP'

  # GEOIP_API GeoIP* GeoIP_open(const char * filename, int flags)
  attach_function :db_open, :GeoIP_open, [:string, :int], :pointer
  # GEOIP_API void GeoIP_delete(GeoIP* gi);
  attach_function :db_free, :GeoIP_delete, [:pointer], :void
  # GeoIPRecord * GeoIP_record_by_addr (GeoIP* gi, const char *addr);
  attach_function :record_by_addr, :GeoIP_record_by_addr, [:pointer, :string], :pointer
  # void GeoIPRecord_delete (GeoIPRecord *gir);
  attach_function :record_free, :GeoIPRecord_delete, [:pointer], :void

  UNKNOWN_ACCURACY_RADIUS = 0x3ff

  # typedef struct GeoIPRecordTag {
  class Record < FFI::Struct
    layout  :country_code,    :string,
            :country_code3,   :string,
            :country_name,    :string,
            :region,          :string,
            :city,            :string,
            :postal_code,     :string,
            :latitude,        :float,
            :longitude,       :float,
            :dma_code,        :int,
            :area_code,       :int,
            :charset,         :int,
            :continent_code,  :string,
            :country_conf,    :uchar,
            :region_conf,     :uchar,
            :city_conf,       :uchar,
            :postal_conf,     :uchar,
            :accuracy_radius, :int
    def to_hash
      h = Hash[ [ :country_code, :country_name, :region,
                  :city, :postal_code, :latitude, :longitude,
                  :continent_code, (acc=:accuracy_radius)
                ].map{|k| [k, self[k]] } ]
      h[acc] = -1 if h[acc] == UNKNOWN_ACCURACY_RADIUS
      h
    end
  end

  class City
    def initialize(database_filename, &block)
      @filename = database_filename
      (block.call(self); close) if block
    end
    def lookup(ip)
      @db ||= GeoIP.db_open(@filename, 0)
      raise "Failed opening #{@filename}" if @db.null?
      record = GeoIP.record_by_addr(@db, ip)
      return nil if record.null?
      result = GeoIP::Record.new(record).to_hash
      GeoIP.record_free(record)
      result
    end
    def close
      (GeoIP.db_free(@db); @db=nil) if @db; true
    end
  end
end

if __FILE__ == $0
  require 'pp'
  db = GeoIP::City.new('GeoLiteCity.dat')
  ARGV.each{|ip| pp db.lookup(ip) }
  db.close
end

__END__
if __FILE__ == $0
  p db = GeoIP::City.new('GeoLiteCity.dat')
  p db.lookup("24.24.24.24")
  p db.close # manual close
  
  GeoIP::City.new('GeoLiteCity.dat'){|db|
    p db.lookup("24.24.24.24")
  } # auto close
end
