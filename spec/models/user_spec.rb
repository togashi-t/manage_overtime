require "rails_helper"

RSpec.describe User, type: :model do

  # バリデーション
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
