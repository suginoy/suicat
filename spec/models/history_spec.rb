# -*- coding: utf-8 -*-
require 'spec_helper'

describe History do
  context "test_history" do
    subject { History.new(raw_data: '160100021b3dc405c436740400000300') }
    its(:terminal) { should eq '改札機' }
    its(:process) { should eq '改札出場' }
    its(:date) { should eq '2013/09/29'.to_date }
    its(:from_area_code) { should eq '0' }
    its(:from_line_code) { should eq 'c4' }
    its(:from_station_code) { should eq '05' }
    its(:to_line_code) { should eq 'c4' }
    its(:to_station_code) { should eq '36' }
    its(:balance) { should eq 1140 }
    its(:region) { should eq 0 }
  end
end
