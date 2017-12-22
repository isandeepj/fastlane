
module Spaceship
  module Tunes
    class IAPList < TunesBase
      # @return (Spaceship::Tunes::Application) A reference to the application
      attr_accessor :application

      # @return (String) the IAP Referencename
      attr_accessor :reference_name

      # @return (String) the IAP Product-Id
      attr_accessor :product_id

      # @return (String) Family Reference Name
      attr_accessor :family_reference_name

      attr_accessor :duration_days
      attr_accessor :versions
      attr_accessor :purple_apple_id
      attr_accessor :last_modified_date
      attr_accessor :is_news_subscription
      attr_accessor :number_of_codes
      attr_accessor :maximum_number_of_codes
      attr_accessor :app_maximum_number_of_codes
      attr_accessor :is_editable
      attr_accessor :is_required
      attr_accessor :can_delete_addon

      attr_mapping({
        'adamId' => :purchase_id,
        'referenceName' => :reference_name,
        'familyReferenceName' => :family_reference_name,
        'vendorId' => :product_id,
        'durationDays' => :duration_days,
        'versions' => :versions,
        'purpleSoftwareAdamIds' => :purple_apple_id,
        'lastModifiedDate' => :last_modified_date,
        'isNewsSubscription' => :is_news_subscription,
        'numberOfCodes' => :number_of_codes,
        'maximumNumberOfCodes' => :maximum_number_of_codes,
        'appMaximumNumberOfCodes' => :app_maximum_number_of_codes,
        'isEditable' => :is_editable,
        'isRequired' => :is_required,
        'canDeleteAddOn' => :can_delete_addon
      })

      def type
        Tunes::IAPType.get_from_string(raw_data["addOnType"])
      end

      def status
        Tunes::IAPStatus.get_from_string(raw_data["iTunesConnectStatus"])
      end

      def edit
        Tunes::IAPDetail.new(build_iap)
      end

      def delete!
        client.delete_iap!(app_id: application.apple_id, purchase_id: self.purchase_id)
      end

      private

      def build_iap
        attrs = [*iap_prices, *iap_details].to_h
        attrs[:application] = application
        attrs
      end

      def iap_prices
        client.load_iap_prices(app_id: application.apple_id, purchase_id: self.purchase_id)
      end

      def iap_details
        client.load_iap_details(app_id: application.apple_id, purchase_id: self.purchase_id)
      end
    end
  end
end
