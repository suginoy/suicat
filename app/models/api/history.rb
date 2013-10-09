class Api::History
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  attr_accessor :user_id, :key, :idm, :raw_data

  validates :user_id, presence: true, numericality: { only_integer: true }
  validates :key, presence: true
  validates :idm, presence: true, format: { with: /\h/i }, length: { is: 16 }
  validates :raw_data, presence: true, format: { with: /\h/i }

  after_validation :set_user, :downcase_idm!, :downcase_raw_data!

  RAW_DATA_LINE_LENGTH = 32

  def split_by_length(str, length)
    str.unpack("a#{RAW_DATA_LINE_LENGTH}" * (str.length / RAW_DATA_LINE_LENGTH))
  end

  def save
    if valid? && valid_key? && valid_raw_data_length?
      current_history = ::History.where(idm: @idm).first

      histories = []
      split_by_length(@raw_data, RAW_DATA_LINE_LENGTH).each do |x|
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

  private
  def set_user
    @user = User.where(id: @user_id).first
  end

  def valid_key?
    @user.present? && @user.key == @key
  end

  def valid_raw_data_length?
    @raw_data.present? && @raw_data.length % RAW_DATA_LINE_LENGTH == 0
  end

  def downcase_idm!
    @idm.try(:downcase!)
  end

  def downcase_raw_data!
    @raw_data.try(:downcase!)
  end
end
