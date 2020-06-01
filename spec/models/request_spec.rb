require "rails_helper"

RSpec.describe Request, type: :model do
  describe "validation" do
    context "detailが入力されている" do
      it "頼み事が作られる" do
        request = build(:request)
        expect(request).to be_valid
      end
    end

    context "detailが入力されていない" do
      it "エラーする" do
        request = build(:request, detail: nil)
        request.valid?
        expect(request.errors.messages[:detail]).to include "を入力してください"
      end
    end

    context "detailの文字数が255より大きい" do
      it "エラーする" do
        request = build(:request, detail: "a" * 256)
        request.valid?
        expect(request.errors.messages[:detail]).to include "は255文字以内で入力してください"
      end
    end
  end
end
