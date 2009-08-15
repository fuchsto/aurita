
require('aurita/model')
Aurita::Main.import_model :user_group

module Aurita
module Main

  class User_Action < Aurita::Model

    table :user_action, :public
    primary_key :user_action_id, :user_action_id_seq

    has_a User_Group, :user_group_id

    def self.before_create(args)
      args[:params] = args[:params].to_s.gsub("'",'&apos;')
      args[:excep_trace] = args[:excep_trace].to_s.gsub("'",'&apos;')
      args
    end

    # For statistics based on records of User_Online. 
    # Returns amount of active users in timespan
    def self.num_users(time_from, time_to)
      time_from = time_from.strftime("%Y-%m-%d %H%M%S")
      time_to   = time_to.strftime("%Y-%m-%d %H%M%S")
      select_value('count(distinct user_group_id)') { |ua|
        ua.where((ua.time >= time_from) & (ua.time <= time_to))
      }
    end

    # For statistics based on records of User_Online. 
    # Returns daily or hourly average amount of requests 
    # in given span of time. 
    # 
    # Usage: 
    #
    #   User_Action.num_requests(:average => :daily, 
    #                            :from    => time_from, 
    #                            :to      => time_to)
    #
    def self.num_requests(params={})
      time_from = params[:from].strftime("%Y-%m-%d %H%M%S")
      time_to   = params[:to].strftime("%Y-%m-%d %H%M%S")
      requests = select_value('count(*)') { |ua|
        ua.where((ua.time >= time_from) & (ua.time <= time_to))
      }.to_i 
      num_days = (params[:to].to_date - params[:from].to_date).to_i
      ratio    = num_days if params[:average] == :daily
      ratio    = num_days / 24 if params[:average] == :hourly
      (requests / ratio)
    end

    # For statistics based on records of User_Online. 
    # Returns daily or hourly average amount of visits 
    # in given span of time. 
    # 
    # Usage: 
    #
    #   User_Action.num_visits(:average => :daily, 
    #                          :from    => time_from, 
    #                          :to      => time_to)
    #
    def self.num_visits(params={})
      time_from = params[:from].strftime("%Y-%m-%d %H%M%S")
      time_to   = params[:to].strftime("%Y-%m-%d %H%M%S")
      visits = select_value('count(*)') { |ua|
        ua.where((ua.time >= time_from) & (ua.time <= time_to) & 
                 (ua.controller.like('%::App_Main_Controller')) & 
                 (User_Action.method == 'start'))
      }.to_i 
      num_days = (params[:to].to_date - params[:from].to_date).to_i
      ratio    = num_days if params[:average] == :daily
      ratio    = num_days / 24 if params[:average] == :hourly
      (visits / ratio)
    end

  end

end
end

