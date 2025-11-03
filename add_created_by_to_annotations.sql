-- Add created_by field to annotations table
ALTER TABLE public.annotations 
ADD COLUMN created_by UUID REFERENCES public.users(id) ON DELETE SET NULL;

-- Create index for faster queries
CREATE INDEX idx_annotations_created_by ON public.annotations(created_by);

-- Update existing annotations to set created_by to NULL (or a default user if you have one)
-- UPDATE public.annotations SET created_by = NULL WHERE created_by IS NULL;
