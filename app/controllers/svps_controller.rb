class SvpsController < ApplicationController
  before_filter :set_client
  before_action :set_svp, only: [:show, :update, :destroy]
  before_action :set_user, only: [:create]

  def index
    @svps = @client.svps
    render json: @svps.as_json
  end

  def show
    render json: @svp.as_json
  end

  def create
    params.delete("user_id")
    @svp = @client.svps.new(svp_params)
    if @svp.save
      render json: @svp.as_json, status: :created, location: [@client,@svp]
      response = VraServices.create_svp(svp_service_parameters, generate_svp_json)
    else
      render json: @svp.errors, status: :unprocessable_entity
    end
  end

  def update
    if @svp.update(svp_params)
      head :no_content
    else
      render json: @svp.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @svp.destroy
    head :no_content
  end

  def catalog
    response = VraServices.catalog
    render json:response, status: :ok
  end

  private

    def set_client
      @client = Client.friendly.find(params[:client_id])
    end

    def set_svp
      @svp = @client.svps.find(params[:id])
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def svp_params
      params.permit(:name,:blueprint_id,:id,:user_id,:client_id,:memory,:cpu,:hard_disk)
    end

    def svp_service_parameters
      @user.user_svp_parameters
    end

    def generate_svp_json
      {  
         "@type":"CatalogItemRequest",
         "catalogItemRef":{  
            "id": @svp.blueprint_id
         },
         "organization":{  
            "tenantRef":"dchornos-svp-01",
            "subtenantRef":"c3019082-1b2c-44d6-9dd0-a510db297d53"
         },
         "requestedFor": @user.full_name,
         "state":"SUBMITTED",
         "requestNumber":0,
         "requestData":{  
            "entries":[  
               {  
                  "key":"provider-provisioningGroupId",
                  "value":{  
                     "type":"string",
                     "value":"c3019082-1b2c-44d6-9dd0-a510db297d53"
                  }
               },
               {  
                  "key":"requestedFor",
                  "value":{  
                     "type":"string",
                     "value":"svp-admin@int.fibercorp.com.ar"
                  }
               },
               {  
                  "key":"provider-Machine.ssh",
                  "value":{  
                     "type":"string",
                     "value":"true"
                  }
               },
               {  
                  "key":"provider-VirtualMachine.CPU.Count",
                  "value":{  
                     "type":"integer",
                     "value": @svp.cpu
                  }
               },
               {  
                  "key":"provider-VirtualMachine.Memory.Size",
                  "value":{  
                     "type":"integer",
                     "value": @svp.memory
                  }
               },
               {  
                  "key":"provider-VirtualMachine.Disk0.Size",
                  "value":{  
                     "type":"string",
                     "value": @svp.hard_disk
                  }
               },
               {  
                  "key":"provider-Cafe.Shim.VirtualMachine.TotalStorageSize",
                  "value":{  
                     "type":"decimal",
                     "value":0
                  }
               },
               {  
                  "key":"provider-Cafe.Shim.VirtualMachine.NumberOfInstances",
                  "value":{  
                     "type":"integer",
                     "value":1
                  }
               },
               {  
                  "key":"provider-Cafe.Shim.VirtualMachine.AssignToUser",
                  "value":{  
                     "type":"string",
                     "value": @user.full_name
                  }
               }
            ]
         }
      }.to_json
    end

end