-- Fix: Add missing DELETE policy for groups
-- This allow group admins to delete the group they manage.

CREATE POLICY "Group admins can delete groups."
  ON public.groups FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.group_members
      WHERE group_members.group_id = groups.id
      AND group_members.user_id = auth.uid()
      AND group_members.role = 'admin'
    )
  );
