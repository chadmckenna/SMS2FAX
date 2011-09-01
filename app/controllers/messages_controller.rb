class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.xml
  def index
    @messages = Message.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    @message = Message.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.xml
  def create
    if Message.count_messages_by_sender(params[:From]) <= 3
      @message = Message.new(:AccountSid => params[:AccountSid], :From => params[:From], :To => params[:To], :Body => params[:Body], 
        :FromCity => params[:FromCity], :FromState => params[:FromState], :FromZip => params[:FromZip], :FromCountry => params[:FromCountry],
        :ToCity => params[:ToCity], :ToState => params[:ToState], :ToZip => params[:ToZip], :ToCountry => params[:ToCountry])
      #@message = Message.new(params[:message])
  
      respond_to do |format|
        if @message.save
          @message.send_fax
          format.html { redirect_to(@message, :notice => 'Message was successfully created.') }
          format.xml  { render :xml => @message, :status => :created, :location => @message }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
        end
      end
    else
      # Code will go here to send SMS back to sender
      require 'twilio-ruby'
      Message.send_over_use_message(params[:From])
      redirect_to root_path
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to(@message, :notice => 'Message was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to(messages_url) }
      format.xml  { head :ok }
    end
  end
end
