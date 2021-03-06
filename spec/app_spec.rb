require File.expand_path '../spec_helper.rb', __FILE__

describe "My Sinatra Application" do
  it "should allow accessing the home page" do
    get '/'
    # Rspec 2.x
    expect(last_response).to be_ok

    # Rspec 1.x
    last_response.should be_ok
  end
end