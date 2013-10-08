#!/usr/bin/env ruby
require 'daemon_spawn'
require 'json'
require 'net/http'
require 'pasori'

HOST = 'suicat.herokuapp.com'
PORT = 80
USER_ID = "<user_id>"
API_KEY = "<api_key>"
API_URL = "/api/users/#{USER_ID}/histories.json"

class SuicatDaemon < DaemonSpawn::Base
  def start(args)
    http = Net::HTTP.new(HOST, PORT)
    pasori = Pasori.open
    while true
      begin
        felica = pasori.felica_polling(Felica::POLLING_SUICA)
        idm = felica.idm.unpack("C*").map { |c| "%02x" % c }.join
        raw_data = ''
        felica.foreach(Felica::SERVICE_SUICA_HISTORY) { |l|
          raw_l = l.bytes.map { |c| "%02x" % c }.join
          raw_data += raw_l
        }
        params = { key: API_KEY, idm: idm, raw_data: raw_data }
        http.post(API_URL, JSON.dump(params), 'content-type' => 'application/json')
        sleep 1
      rescue PasoriError
      end
    end
  end

  def stop
  end
end

SuicatDaemon.spawn!(
  working_dir: File.dirname(__FILE__),
  pid_file: "/tmp/#{File.basename(__FILE__, '.rb')}.pid",
  log_file: "/tmp/#{File.basename(__FILE__, '.rb')}.log",
  sync_log: true,
  singleton: true,
)
