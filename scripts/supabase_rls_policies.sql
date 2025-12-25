-- Row Level Security (RLS) Policies for user_information table
-- Run this in your Supabase SQL Editor

-- Enable Row Level Security
ALTER TABLE user_information ENABLE ROW LEVEL SECURITY;

-- Policy: Allow users to view their own data
CREATE POLICY "Users can view own data"
ON user_information FOR SELECT
USING (auth.uid() = user_id);

-- Policy: Allow authenticated users to insert their own data
CREATE POLICY "Users can insert own data"
ON user_information FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- Policy: Allow users to update their own data
CREATE POLICY "Users can update own data"
ON user_information FOR UPDATE
USING (auth.uid() = user_id);

-- Policy: Allow users to delete their own data (optional)
CREATE POLICY "Users can delete own data"
ON user_information FOR DELETE
USING (auth.uid() = user_id);

-- Note: These policies ensure that users can only access their own data
-- The auth.uid() function returns the UUID of the authenticated user
-- which matches the user_id column in your user_information table
