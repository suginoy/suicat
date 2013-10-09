require 'spec_helper'

describe Api::History do
  it { should validate_presence_of(:user_id) }
  it { should validate_numericality_of(:user_id) }
  it { should validate_presence_of(:key) }
  it { should validate_presence_of(:idm) }
  it { should validate_presence_of(:raw_data) }
end
