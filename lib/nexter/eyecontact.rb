module Nexter
  # ViewHelper/ViewBuilder for previous/next out of the van
  #
  # - nexter(@asset, @asset_search) do |asset|
  #   = link_to "previous", asset.path([:edit, :admin, asset.previous ])
  #   = link_to "next", asset.path([:edit, :admin, asset.next ])
  #
  module Eyecontact

    def nexter( model, search_form )
      yield Nexter::Retina.new(model, search_form, self)
      return false
    end

    ::ActionView::Base.send(:include, self) if defined?(Rails)
  end

  class Retina
    attr_reader :model, :search_form, :view

    attr_reader :relation, :params

    attr_reader :nexter

    delegate :previous, :next, :after, :before, :to => :nexter

    def initialize( model, search_form, view)
      @model = model
      @search_form = search_form
      @view = view

      set_relation
      set_params

      @nexter = Nexter.wrap( relation, model )
    end

    def path(args)
      @view.polymorphic_path(args, params)
    end


  private

    def set_relation
      @relation = @search_form.result
    end

    def set_params
      param_key = @search_form.class.model_name.param_key
      @params = view.params.select {|k, v| k == param_key}
    end
  end
end

