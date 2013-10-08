class Api::History
  include ActiveModel::Model
  attr_accessor :user_id, :key, :idm, :raw_data

  # TODO: 数字, ユーザの存在
  validates :user_id, presence: true, numericality: { only_integer: true }
  # TODO: keyの一致
  validates :key, presence: true
  # TODO: idmのチェック
  validates :idm, presence: true
  # TODO: 16進数の文字, 文字列の長さ
  validates :raw_data, presence: true

  def save
    if valid?
      @user = User.where(id: @user_id).first
      return false if @user.key != @key
      current_history = ::History.where(idm: @idm).first

      histories = []
      @raw_data.unpack('a32' * (@raw_data.length / 32)).each do |x|
        break if x[2, 2] == '07' || x == current_history.try(:raw_data)
        history = @user.histories.new(idm: @idm, raw_data: x)
        history.from = history.from_station_name # TODO: sqlの発行回数を減らす
        history.to = history.to_station_name # TODO: sqlの発行回数を減らす
        histories << history
      end
      History.import(histories) if histories.present?
      true
    else
      false
    end
  end
end
