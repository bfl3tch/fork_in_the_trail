RSpec.describe UserSerializer do
  it 'serializes the user correctly', :aggregate_failures  do
    user = create(:user)
    serialized = UserSerializer.new(user).serializable_hash

    data = serialized[:data]

    expect(data[:type]).to eq(:user)
    expect(data[:attributes].keys).to contain_exactly(:email, :api_key)
    expect(data[:attributes]).to include(
      email: user.email,
      api_key: user.api_key
  )  
  end
end
