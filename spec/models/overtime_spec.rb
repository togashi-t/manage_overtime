require "rails_helper"

RSpec.describe Overtime, type: :model do
  describe "validation" do
    context "date, work_start_time, work_end_timeが入力されている" do
      it "残業記録が作られる" do
        overtime = build(:overtime)
        expect(overtime).to be_valid
      end
    end

    context "同一ユーザーが既に記録がある日の記録を作成する" do
      let(:user) { create(:user) }
      it "エラーする" do
        overtime_a = create(:overtime, date: "2020-12-12", user: user)
        overtime_b = build(:overtime, date: "2020-12-12", user: user)
        overtime_b.valid?
        expect(overtime_b.errors.messages[:date]).to include "はすでに存在します"
      end
    end

    context "異なるユーザーが同じ日の記録を作成する" do
      let(:user_a) { create(:user) }
      let(:user_b) { create(:user) }
      it "残業記録が作られる" do
        overtime_a = create(:overtime, date: "2020-12-12", user: user_a)
        overtime_b = build(:overtime, date: "2020-12-12", user: user_b)
        expect(overtime_b).to be_valid
      end
    end

    context "dateが入力されていない" do
      it "エラーする" do
        overtime = build(:overtime, date: nil)
        overtime.valid?
        expect(overtime.errors.messages[:date]).to include "を入力してください"
      end
    end

    context "work_start_timeが入力されていない" do
      it "エラーする" do
        overtime = build(:overtime, work_start_time: nil)
        overtime.valid?
        expect(overtime.errors.messages[:work_start_time]).to include "を入力してください"
      end
    end

    context "work_end_timeが入力されていない" do
      it "エラーする" do
        overtime = build(:overtime, work_end_time: nil)
        overtime.valid?
        expect(overtime.errors.messages[:work_end_time]).to include "を入力してください"
      end
    end

    context "work_start_time > work_end_timeとしている" do
      it "エラーする" do
        overtime = build(:overtime, work_start_time: "23:00", work_end_time: "19:00")
        overtime.valid?
        expect(overtime.errors.messages[:work_start_time]).to include " > 終了時刻となっています。"
      end
    end
  end
end
