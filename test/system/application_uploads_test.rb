## frozen_string_literal: true
#require "application_system_test_case"

#class ApplicationUploadsTest < ApplicationSystemTestCase
  #setup do
    ##@application_upload = application_uploads(:one)
  #end

  #test "visiting the index" do
    #skip
    #visit application_uploads_url
    #assert_selector "h1", text: "Application Uploads"
  #end

  #test "creating a Application upload" do
    #skip
    #visit application_uploads_url
    #click_on "New Application Upload"

    #fill_in "Application", with: @application_upload.application_id
    #fill_in "Uploaded date", with: @application_upload.uploaded_date
    #fill_in "Uploaded text", with: @application_upload.uploaded_text
    #click_on "Create Application upload"

    #assert_text "Application upload was successfully created"
    #click_on "Back"
  #end

  #test "updating a Application upload" do
    #skip
    #visit application_uploads_url
    #click_on "Edit", match: :first

    #fill_in "Application", with: @application_upload.application_id
    #fill_in "Uploaded date", with: @application_upload.uploaded_date
    #fill_in "Uploaded text", with: @application_upload.uploaded_text
    #click_on "Update Application upload"

    #assert_text "Application upload was successfully updated"
    #click_on "Back"
  #end

  #test "destroying a Application upload" do
    #skip
    #visit application_uploads_url
    #page.accept_confirm do
      #click_on "Destroy", match: :first
    #end

    #assert_text "Application upload was successfully destroyed"
  #end
#end
