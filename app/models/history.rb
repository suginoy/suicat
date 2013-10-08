class History < ActiveRecord::Base
  belongs_to :user

  TERMINAL_TYPES = {
    0x03 => '精算機',
    0x05 => '車載端末',
    0x07 => '券売機',
    0x08 => '券売機',
    0x09 => '入金機',
    0x12 => '券売機',
    0x14 => '券売機等',
    0x15 => '券売機等',
    0x16 => '改札機',
    0x17 => '簡易改札機',
    0x18 => '窓口端末',
    0x19 => '窓口端末',
    0x1A => '改札端末',
    0x1B => '携帯電話',
    0x1C => '乗継精算機',
    0x1D => '連絡改札機',
    0x1F => '簡易入金機',
    0x23 => '新幹線改札機',
    0x46 => 'VIEW ALTTE',
    0x48 => 'VIEW ALTTE',
    0xC7 => '物販端末',
    0xC8 => '自販機',
  }

  PROCESS_TYPES = {
    0x01 => '改札出場',
    0x02 => 'チャージ',
    0x03 => '磁気券購入',
    0x04 => '精算',
    0x05 => '入場精算',
    0x06 => '改札窓口処理',
    0x07 => '新規発行',
    0x08 => '窓口控除',
    0x0d => 'バス',
    0x0f => 'バス',
    0x11 => '再発行処理',
    0x13 => '支払(新幹線利用)',
    0x14 => '入場時オートチャージ',
    0x15 => '出場時オートチャージ',
    0x1f => 'バスチャージ',
    0x23 => 'バス路面電車企画券購入',
    0x46 => '物販',
    0x48 => '特典チャージ',
    0x49 => 'レジ入金',
    0x4a => '物販取消',
    0x4b => '入場物販',
    0xc6 => '現金併用物販',
    0xcb => '入場現金併用物販',
    0x84 => '他社精算',
    0x85 => '他社入場精算',
  }

  def terminal_code
    raw_data[0, 2]
  end

  def terminal
    TERMINAL_TYPES[terminal_code.hex] || ''
  end

  def process_code
    raw_data[2, 2]
  end

  def process
    PROCESS_TYPES[process_code.hex] || ''
  end

  def date
    d = "%016b" % raw_data[8, 4].hex
    y = d[0, 7].to_i(2) + 2000
    m = d[7, 4].to_i(2)
    d = d[11, 5].to_i(2)
    Date.new(y, m, d)
  end

  def shop?
    terminal_code.in?(0xc7, 0xc8)
  end

  def station?
    !shop? && terminal_code != 0x05
  end

  def from_area_code
    if station?
      if from_line_code.to_i <= 0x7f
        return '0'
      elsif region == 0
        return '1'
      elsif region == 1
        return '2'
      end
    end
  end

  def from_line_code
    raw_data[12, 2]
  end

  def from_station_code
    raw_data[14, 2]
  end

  def from_station_name
    station = Station.where(area_code: from_area_code,
                            line_code: "%x" % from_line_code.hex,
                            station_code: "%x" % from_station_code.hex).first
    station.station_name if station
  end

  def to_area_code
    if station?
      if to_line_code.to_i <= 0x7f
        return '0'
      elsif region == 0
        return '1'
      elsif region == 1
        return '2'
      end
    end
  end

  def to_line_code
    raw_data[16, 2]
  end

  def to_station_code
    raw_data[18, 2]
  end

  def to_station_name
    station = Station.where(area_code: to_area_code,
                            line_code: "%x" % to_line_code.hex,
                            station_code: "%x" % to_station_code.hex).first
    station.station_name if station
  end

  def balance
    raw_data[20, 2].hex + (raw_data[22, 2].hex << 8)
  end

  def region
    raw_data[30, 2].hex
  end
end
