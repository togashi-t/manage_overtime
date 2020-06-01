require "rails_helper"

RSpec.describe User, type: :model do
  describe "validation" do
    context "name, group, email, passwordが入力されている" do
      it "ユーザーが作られる" do
        user = build(:user)
        expect(user).to be_valid
      end
    end

    context "nameが入力されていない" do
      it "エラーする" do
        user = build(:user, name: nil)
        user.valid?
        expect(user.errors.messages[:name]).to include "を入力してください"
      end
    end

    context "groupが入力されていない" do
      it "エラーする" do
        user = build(:user, group: nil)
        user.valid?
        expect(user.errors.messages[:group]).to include "を入力してください"
      end
    end

    context "emailが入力されていない" do
      it "エラーする" do
        user = build(:user, email: nil)
        user.valid?
        expect(user.errors.messages[:email]).to include "を入力してください"
      end
    end

    context "同一のemailが存在する" do
      it "エラーする" do
        create(:user, email: "tsuruoka@example.com")
        user = build(:user, email: "tsuruoka@example.com")
        user.valid?
        expect(user.errors.messages[:email]).to include "はすでに存在します"
      end
    end

    context "passwordが入力されていない" do
      it "エラーする" do
        user = build(:user, password: nil)
        user.valid?
        expect(user.errors.messages[:password]).to include "を入力してください"
      end
    end
  end

  describe "instance method" do
    let!(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:overtime_a) { create(:overtime, date: Date.today.beginning_of_month, user: user) }
    let!(:overtime_b) { create(:overtime, date: Date.today.beginning_of_month.next_day(1), user: user) }

    it "ユーザーの今月の合計残業時間（単位：分）を返す" do
      expect(user.this_month_minute).to eq (overtime_a.work_time_minute + overtime_b.work_time_minute)
    end

    it "ユーザーの全ての残業記録を「時」「分」に分けたハッシュを返す" do
      expect(user.overtimes_devided_into_hour_and_minute.length).to eq 2
      hash = Hash.new {|h, k| h[k] = {} }
      hash[overtime_b.date][:start_hour] = overtime_b.work_start_time.hour
      hash[overtime_b.date][:start_minute] = overtime_b.work_start_time.min
      hash[overtime_b.date][:end_hour] = overtime_b.work_end_time.hour
      hash[overtime_b.date][:end_minute] = overtime_b.work_end_time.min
      hash[overtime_b.date][:work_minute] = overtime_b.work_time_minute
      expect(user.overtimes_devided_into_hour_and_minute).to include hash
    end

    it "月毎の合計残業時間（単位：時間）のハッシュを返す" do
      hash = {}
      key = overtime_a.date.strftime('%Y年%-m月')
      value_m = overtime_a.work_time_minute + overtime_b.work_time_minute
      value_h = (value_m.to_f / 60).floor(1)
      hash[key] = value_h
      expect(user.monthly_chart_data).to eq hash
    end

    it "頼み事がある場合trueを返す" do
      create(:request, user: user)
      expect(user.request?).to eq true
    end

    it "頼み事がない場合falseを返す" do
      expect(other_user.request?).to eq false
    end
  end

end
