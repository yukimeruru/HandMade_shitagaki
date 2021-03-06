class ItemsController < ApplicationController


  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id
    if @item.save
      redirect_to items_path
    else
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to items_path(@item.id)
    else
      render :edit
    end
  end

  def index
    @items = Item.all
    @pages = Item.page(params[:page]).per(12)
    if params[:tag_name]
      @items = Item.tagged_with(params[:tag_name])
      @pages = @items.page(params[:page]).per(12)
    end
  end

  def show
    @item = Item.find(params[:id])
    impressionist(@item, nil, unique: [:session_hash.to_s])
  end

  def destroy
    Item.find_by(id: params[:id]).destroy
    redirect_to items_path(params[:item_id])
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :image, :item_status, :tag_list)
  end

end
