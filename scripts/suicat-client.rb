require 'json'
require 'net/http'
require 'pasori'

host = 'localhost'
port = 3000
user_id = "<user_id>"
api_key = "<api_key>"
api_url = "/api/users/#{user_id}/histories.json"

http = Net::HTTP.new(host, port)

pasori = Pasori.open

while
  begin
    felica = pasori.felica_polling(Felica::POLLING_SUICA)
    idm = felica.idm.unpack("C*").map { |c| "%02x" % c }.join
    raw_data = ''
    felica.foreach(Felica::SERVICE_SUICA_HISTORY) { |l|
      raw_l = l.bytes.map { |c| "%02x" % c }.join
      raw_data += raw_l
    }
    params = { key: api_key, idm: idm, raw_data: raw_data }
    http.post(api_url, JSON.dump(params), 'content-type' => 'application/json')
    sleep 1
  rescue PasoriError
    p 'error'
  end
end
