class ApplicationController < ActionController::Base
  # Inertia gem auto-extends controllers; nothing to include here.

  inertia_share do
    {
      flash: {
        notice: flash[:notice],
        alert:  flash[:alert],
      }
    }
  end
end
