require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
 
module RailsAdminActivateOrder
end
 
module RailsAdmin
  module Config
    module Actions
      class ActivateOrder < RailsAdmin::Config::Actions::Base


        # There are several options that you can set here.
        # Check https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/actions/base.rb for more info.
 
        # Model scoped actions only. You will need to handle params[:bulk_ids] in controller
        register_instance_option :bulkable? do
          true
        end
        
        # Is the action acting on the root level (Example: /admin/contact)
        register_instance_option :root? do
          false
        end
        
        # Is the action on an object scope (Example: /admin/team/1/edit)
        register_instance_option :member? do
          true
        end

        # http://twitter.github.com/bootstrap/base-css.html#icons
        register_instance_option :link_icon do
          'icon-ok-sign'
        end

        # List of methods allowed. Note that you are responsible for correctly handling them in :controller block
        register_instance_option :http_methods do
          [:get]
        end

        # Controller action name
        register_instance_option :action_name do
          custom_key.to_sym
        end
 
        # This block is evaluated in the context of the controller when action is called
        # You can access:
        # - @objects if you're on a model scope
        # - @abstract_model & @model_config if you're on a model or object scope
        # - @object if you're on an object scope
        register_instance_option :controller do
          Proc.new do
            @objects = Array.new
            unless @model_config.nil?
              # Get all selected rows
              @objects = list_entries(@model_config, :destroy)
            else
              @objects.push(@object)
            end

            @objects.each do |order|
              if order.payment_status == 1
                next
              end
              courses = order.courses.split(',')
              user_id = order.user_id
              Course.find(courses).each do |course|
                study = Study.new
                study.course_id = course.id
                study.status = 0
                study.user_id = user_id
                study.save
              end
              order.update_attribute(:payment_status, 1)
            end
            flash[:success] = "#{@model_config.label} paid."
            redirect_to back_or_index
          end
        end

        
      end
    end
  end
end