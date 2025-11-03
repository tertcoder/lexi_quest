-- ============================================
-- LexiQuest - Complete Supabase Setup SQL
-- Run this entire file in Supabase SQL Editor
-- ============================================

-- ============================================
-- STEP 1: CREATE TABLES
-- ============================================

-- 1. USERS TABLE (extends auth.users)
CREATE TABLE public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username TEXT UNIQUE NOT NULL,
  email TEXT UNIQUE NOT NULL,
  avatar_url TEXT,
  total_xp INTEGER DEFAULT 0,
  level INTEGER DEFAULT 1,
  current_level_xp INTEGER DEFAULT 0,
  next_level_xp INTEGER DEFAULT 100,
  streak INTEGER DEFAULT 0,
  annotations_completed INTEGER DEFAULT 0,
  last_active_at TIMESTAMPTZ DEFAULT NOW(),
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_users_username ON public.users(username);
CREATE INDEX idx_users_total_xp ON public.users(total_xp DESC);
CREATE INDEX idx_users_level ON public.users(level DESC);

-- 2. PROJECTS TABLE
CREATE TABLE public.projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  owner_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('text', 'image', 'audio')),
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'completed', 'paused', 'draft')),
  visibility TEXT DEFAULT 'public_' CHECK (visibility IN ('public_', 'private_', 'unlisted')),
  total_tasks INTEGER DEFAULT 0,
  completed_tasks INTEGER DEFAULT 0,
  validated_tasks INTEGER DEFAULT 0,
  contributors INTEGER DEFAULT 0,
  xp_reward_per_task INTEGER DEFAULT 10,
  tags TEXT[] DEFAULT '{}',
  thumbnail_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_projects_owner_id ON public.projects(owner_id);
CREATE INDEX idx_projects_type ON public.projects(type);
CREATE INDEX idx_projects_status ON public.projects(status);
CREATE INDEX idx_projects_visibility ON public.projects(visibility);
CREATE INDEX idx_projects_created_at ON public.projects(created_at DESC);

-- 3. ANNOTATIONS TABLE
CREATE TABLE public.annotations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  type TEXT NOT NULL CHECK (type IN ('text', 'image', 'audio')),
  content TEXT NOT NULL,
  instructions TEXT,
  image_url TEXT,
  audio_url TEXT,
  labels TEXT[] NOT NULL DEFAULT '{}',
  metadata JSONB,
  xp_reward INTEGER DEFAULT 10,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_annotations_type ON public.annotations(type);
CREATE INDEX idx_annotations_created_at ON public.annotations(created_at DESC);

-- 4. PROJECT_TASKS TABLE
CREATE TABLE public.project_tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
  annotation_id UUID NOT NULL REFERENCES public.annotations(id) ON DELETE CASCADE,
  annotated_by UUID REFERENCES public.users(id) ON DELETE SET NULL,
  annotated_at TIMESTAMPTZ,
  is_validated BOOLEAN DEFAULT FALSE,
  validated_by UUID REFERENCES public.users(id) ON DELETE SET NULL,
  validated_at TIMESTAMPTZ,
  annotation_data JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(project_id, annotation_id)
);

CREATE INDEX idx_project_tasks_project_id ON public.project_tasks(project_id);
CREATE INDEX idx_project_tasks_annotated_by ON public.project_tasks(annotated_by);
CREATE INDEX idx_project_tasks_is_validated ON public.project_tasks(is_validated);

-- 5. SUBMISSIONS TABLE
CREATE TABLE public.submissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  annotation_id UUID NOT NULL REFERENCES public.annotations(id) ON DELETE CASCADE,
  project_id UUID REFERENCES public.projects(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  data JSONB NOT NULL,
  xp_earned INTEGER NOT NULL,
  submitted_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_submissions_user_id ON public.submissions(user_id);
CREATE INDEX idx_submissions_annotation_id ON public.submissions(annotation_id);
CREATE INDEX idx_submissions_project_id ON public.submissions(project_id);
CREATE INDEX idx_submissions_submitted_at ON public.submissions(submitted_at DESC);

-- 6. LEADERBOARD TABLE
CREATE TABLE public.leaderboard (
  user_id UUID PRIMARY KEY REFERENCES public.users(id) ON DELETE CASCADE,
  username TEXT NOT NULL,
  avatar_url TEXT,
  total_xp INTEGER NOT NULL,
  level INTEGER NOT NULL,
  rank INTEGER NOT NULL,
  annotations_completed INTEGER NOT NULL,
  streak INTEGER NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_leaderboard_rank ON public.leaderboard(rank);
CREATE INDEX idx_leaderboard_total_xp ON public.leaderboard(total_xp DESC);

-- 7. BADGES TABLE
CREATE TABLE public.badges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  badge_type TEXT NOT NULL,
  badge_name TEXT NOT NULL,
  earned_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, badge_type)
);

CREATE INDEX idx_badges_user_id ON public.badges(user_id);
CREATE INDEX idx_badges_badge_type ON public.badges(badge_type);

-- 8. ACTIVITIES TABLE
CREATE TABLE public.activities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  activity_type TEXT NOT NULL CHECK (activity_type IN ('annotation', 'validation', 'level_up', 'badge', 'project_created')),
  title TEXT NOT NULL,
  description TEXT,
  xp_earned INTEGER DEFAULT 0,
  metadata JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_activities_user_id ON public.activities(user_id);
CREATE INDEX idx_activities_created_at ON public.activities(created_at DESC);
CREATE INDEX idx_activities_type ON public.activities(activity_type);

-- ============================================
-- STEP 2: CREATE FUNCTIONS
-- ============================================

-- FUNCTION: Update user XP and level
CREATE OR REPLACE FUNCTION update_user_xp(
  p_user_id UUID,
  p_xp_earned INTEGER
)
RETURNS VOID AS $$
DECLARE
  v_new_total_xp INTEGER;
  v_new_level INTEGER;
  v_new_current_xp INTEGER;
  v_next_level_xp INTEGER;
BEGIN
  SELECT total_xp, level, current_level_xp, next_level_xp
  INTO v_new_total_xp, v_new_level, v_new_current_xp, v_next_level_xp
  FROM users
  WHERE id = p_user_id;
  
  v_new_total_xp := v_new_total_xp + p_xp_earned;
  v_new_current_xp := v_new_current_xp + p_xp_earned;
  
  WHILE v_new_current_xp >= v_next_level_xp LOOP
    v_new_level := v_new_level + 1;
    v_new_current_xp := v_new_current_xp - v_next_level_xp;
    v_next_level_xp := v_next_level_xp + 100;
    
    INSERT INTO activities (user_id, activity_type, title, description)
    VALUES (p_user_id, 'level_up', 'Reached Level ' || v_new_level, 'Keep up the great work!');
  END LOOP;
  
  UPDATE users
  SET 
    total_xp = v_new_total_xp,
    level = v_new_level,
    current_level_xp = v_new_current_xp,
    next_level_xp = v_next_level_xp,
    updated_at = NOW()
  WHERE id = p_user_id;
END;
$$ LANGUAGE plpgsql;

-- FUNCTION: Submit annotation
CREATE OR REPLACE FUNCTION submit_annotation(
  p_annotation_id UUID,
  p_project_id UUID,
  p_user_id UUID,
  p_data JSONB,
  p_xp_earned INTEGER
)
RETURNS UUID AS $$
DECLARE
  v_submission_id UUID;
BEGIN
  INSERT INTO submissions (annotation_id, project_id, user_id, data, xp_earned)
  VALUES (p_annotation_id, p_project_id, p_user_id, p_data, p_xp_earned)
  RETURNING id INTO v_submission_id;
  
  UPDATE project_tasks
  SET 
    annotated_by = p_user_id,
    annotated_at = NOW(),
    annotation_data = p_data
  WHERE project_id = p_project_id AND annotation_id = p_annotation_id;
  
  UPDATE projects
  SET 
    completed_tasks = completed_tasks + 1,
    updated_at = NOW()
  WHERE id = p_project_id;
  
  UPDATE users
  SET 
    annotations_completed = annotations_completed + 1,
    last_active_at = NOW()
  WHERE id = p_user_id;
  
  PERFORM update_user_xp(p_user_id, p_xp_earned);
  
  INSERT INTO activities (user_id, activity_type, title, description, xp_earned)
  VALUES (p_user_id, 'annotation', 'Completed Annotation', 'Great work!', p_xp_earned);
  
  RETURN v_submission_id;
END;
$$ LANGUAGE plpgsql;

-- FUNCTION: Refresh leaderboard
CREATE OR REPLACE FUNCTION refresh_leaderboard()
RETURNS VOID AS $$
BEGIN
  TRUNCATE leaderboard;
  
  INSERT INTO leaderboard (user_id, username, avatar_url, total_xp, level, rank, annotations_completed, streak)
  SELECT 
    id,
    username,
    avatar_url,
    total_xp,
    level,
    ROW_NUMBER() OVER (ORDER BY total_xp DESC) as rank,
    annotations_completed,
    streak
  FROM users
  ORDER BY total_xp DESC;
  
  UPDATE leaderboard SET updated_at = NOW();
END;
$$ LANGUAGE plpgsql;

-- FUNCTION: Update streak
CREATE OR REPLACE FUNCTION update_user_streak(p_user_id UUID)
RETURNS VOID AS $$
DECLARE
  v_last_active DATE;
  v_today DATE;
  v_current_streak INTEGER;
BEGIN
  v_today := CURRENT_DATE;
  
  SELECT last_active_at::DATE, streak
  INTO v_last_active, v_current_streak
  FROM users
  WHERE id = p_user_id;
  
  IF v_last_active = v_today - INTERVAL '1 day' THEN
    UPDATE users
    SET 
      streak = streak + 1,
      last_active_at = NOW()
    WHERE id = p_user_id;
  ELSIF v_last_active < v_today - INTERVAL '1 day' THEN
    UPDATE users
    SET 
      streak = 1,
      last_active_at = NOW()
    WHERE id = p_user_id;
  END IF;
END;
$$ LANGUAGE plpgsql;

-- FUNCTION: Get user projects
CREATE OR REPLACE FUNCTION get_user_projects(
  p_user_id UUID,
  p_filter TEXT DEFAULT 'all'
)
RETURNS TABLE (
  id UUID,
  name TEXT,
  description TEXT,
  owner_id UUID,
  owner_name TEXT,
  owner_avatar TEXT,
  type TEXT,
  status TEXT,
  visibility TEXT,
  total_tasks INTEGER,
  completed_tasks INTEGER,
  validated_tasks INTEGER,
  contributors INTEGER,
  xp_reward_per_task INTEGER,
  tags TEXT[],
  thumbnail_url TEXT,
  created_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ
) AS $$
BEGIN
  IF p_filter = 'owned' THEN
    RETURN QUERY
    SELECT 
      p.id, p.name, p.description, p.owner_id,
      u.username as owner_name, u.avatar_url as owner_avatar,
      p.type, p.status, p.visibility, p.total_tasks, p.completed_tasks,
      p.validated_tasks, p.contributors, p.xp_reward_per_task, p.tags,
      p.thumbnail_url, p.created_at, p.updated_at
    FROM projects p
    JOIN users u ON p.owner_id = u.id
    WHERE p.owner_id = p_user_id
    ORDER BY p.created_at DESC;
  ELSIF p_filter = 'contributed' THEN
    RETURN QUERY
    SELECT DISTINCT
      p.id, p.name, p.description, p.owner_id,
      u.username as owner_name, u.avatar_url as owner_avatar,
      p.type, p.status, p.visibility, p.total_tasks, p.completed_tasks,
      p.validated_tasks, p.contributors, p.xp_reward_per_task, p.tags,
      p.thumbnail_url, p.created_at, p.updated_at
    FROM projects p
    JOIN users u ON p.owner_id = u.id
    JOIN project_tasks pt ON p.id = pt.project_id
    WHERE pt.annotated_by = p_user_id AND p.owner_id != p_user_id
    ORDER BY p.created_at DESC;
  ELSE
    RETURN QUERY
    SELECT 
      p.id, p.name, p.description, p.owner_id,
      u.username as owner_name, u.avatar_url as owner_avatar,
      p.type, p.status, p.visibility, p.total_tasks, p.completed_tasks,
      p.validated_tasks, p.contributors, p.xp_reward_per_task, p.tags,
      p.thumbnail_url, p.created_at, p.updated_at
    FROM projects p
    JOIN users u ON p.owner_id = u.id
    WHERE p.visibility = 'public_' OR p.owner_id = p_user_id
    ORDER BY p.created_at DESC;
  END IF;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- STEP 3: CREATE TRIGGERS
-- ============================================

-- TRIGGER: Auto-update timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON projects
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- TRIGGER: Auto-refresh leaderboard
CREATE OR REPLACE FUNCTION trigger_refresh_leaderboard()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM refresh_leaderboard();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER refresh_leaderboard_on_xp_change
AFTER UPDATE OF total_xp ON users
FOR EACH STATEMENT
EXECUTE FUNCTION trigger_refresh_leaderboard();

-- TRIGGER: Update project contributors count
CREATE OR REPLACE FUNCTION update_project_contributors()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE projects
  SET contributors = (
    SELECT COUNT(DISTINCT annotated_by)
    FROM project_tasks
    WHERE project_id = NEW.project_id AND annotated_by IS NOT NULL
  )
  WHERE id = NEW.project_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_contributors_count
AFTER INSERT OR UPDATE ON project_tasks
FOR EACH ROW
EXECUTE FUNCTION update_project_contributors();

-- ============================================
-- STEP 4: ENABLE ROW LEVEL SECURITY
-- ============================================

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.annotations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.project_tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.leaderboard ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.activities ENABLE ROW LEVEL SECURITY;

-- ============================================
-- STEP 5: CREATE RLS POLICIES
-- ============================================

-- USERS TABLE POLICIES
CREATE POLICY "Users can view all profiles"
ON public.users FOR SELECT
USING (true);

CREATE POLICY "Users can update own profile"
ON public.users FOR UPDATE
USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
ON public.users FOR INSERT
WITH CHECK (auth.uid() = id);

-- PROJECTS TABLE POLICIES
CREATE POLICY "Anyone can view public projects"
ON public.projects FOR SELECT
USING (visibility = 'public_' OR owner_id = auth.uid());

CREATE POLICY "Users can create projects"
ON public.projects FOR INSERT
WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Owners can update projects"
ON public.projects FOR UPDATE
USING (auth.uid() = owner_id);

CREATE POLICY "Owners can delete projects"
ON public.projects FOR DELETE
USING (auth.uid() = owner_id);

-- ANNOTATIONS TABLE POLICIES
CREATE POLICY "Anyone can view annotations"
ON public.annotations FOR SELECT
USING (true);

CREATE POLICY "Authenticated users can create annotations"
ON public.annotations FOR INSERT
WITH CHECK (auth.uid() IS NOT NULL);

-- PROJECT_TASKS TABLE POLICIES
CREATE POLICY "Anyone can view project tasks"
ON public.project_tasks FOR SELECT
USING (true);

CREATE POLICY "Project owners can manage tasks"
ON public.project_tasks FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM projects
    WHERE projects.id = project_tasks.project_id
    AND projects.owner_id = auth.uid()
  )
);

CREATE POLICY "Users can update their annotations"
ON public.project_tasks FOR UPDATE
USING (auth.uid() = annotated_by);

-- SUBMISSIONS TABLE POLICIES
CREATE POLICY "Users can view own submissions"
ON public.submissions FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can create submissions"
ON public.submissions FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- LEADERBOARD TABLE POLICIES
CREATE POLICY "Anyone can view leaderboard"
ON public.leaderboard FOR SELECT
USING (true);

-- BADGES TABLE POLICIES
CREATE POLICY "Users can view all badges"
ON public.badges FOR SELECT
USING (true);

CREATE POLICY "System can insert badges"
ON public.badges FOR INSERT
WITH CHECK (true);

-- ACTIVITIES TABLE POLICIES
CREATE POLICY "Users can view own activities"
ON public.activities FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "System can insert activities"
ON public.activities FOR INSERT
WITH CHECK (true);

-- ============================================
-- SETUP COMPLETE!
-- ============================================
-- All tables, functions, triggers, and policies are now created.
-- Next steps:
-- 1. Set up Storage buckets in Supabase Dashboard
-- 2. Enable Realtime for leaderboard, activities, projects tables
-- 3. Get your API keys and integrate with Flutter
