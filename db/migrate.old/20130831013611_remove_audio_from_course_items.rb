class RemoveAudioFromCourseItems < ActiveRecord::Migration
  def change
    remove_column :course_items, :audio_file_name
    remove_column :course_items, :audio_content_type
    remove_column :course_items, :audio_file_size
    remove_column :course_items, :audio_updated_at
  end
end
