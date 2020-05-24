class RequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    @request = current_user.requests.build(request_params)
    if @request.save
      flash[:notice] = "頼み事の登録が出来ました"
    else
      @request.errors.each do |name, msg|
        jp_name = I18n.t("activerecord.attributes.request")[name]
        flash[jp_name] = msg
      end
    end
    redirect_to user_path(current_user)
  end

  def edit
    @request = current_user.requests.find_by(id: params[:id])
  end

  def update
    @request = current_user.requests.find_by(id: params[:id])
    if @request.update(request_params)
      flash[:notice] = "頼み事の修正が出来ました"
    else
      @request.errors.each do |name, msg|
        jp_name = I18n.t("activerecord.attributes.request")[name]
        flash[jp_name] = msg
      end
    end
    redirect_to user_path(current_user)
  end

  def destroy
    @request = current_user.requests.find_by(id: params[:id])
    @request.destroy
    flash[:notice] = "頼み事の削除が出来ました"
    redirect_to user_path(current_user)
  end

  private

    def request_params
      params.require(:request).permit(:detail)
    end
end