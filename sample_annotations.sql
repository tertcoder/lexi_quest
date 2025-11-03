-- Sample Annotations for Testing
-- Run this in Supabase SQL Editor to populate test data

-- Clear existing test data (optional)
-- DELETE FROM public.project_tasks;
-- DELETE FROM public.annotations WHERE content LIKE '%sample%' OR content LIKE '%test%';

-- TEXT ANNOTATIONS (Sentiment Analysis)
INSERT INTO public.annotations (type, content, instructions, labels, xp_reward) VALUES
('text', 'This movie was absolutely fantastic! The acting was superb and the plot kept me engaged throughout.', 'Select the sentiment of this movie review', ARRAY['Positive', 'Negative', 'Neutral'], 15),
('text', 'Terrible experience. The service was slow and the food was cold. Would not recommend.', 'Select the sentiment of this review', ARRAY['Positive', 'Negative', 'Neutral'], 15),
('text', 'The product is okay. It works as described but nothing exceptional.', 'Select the sentiment of this product review', ARRAY['Positive', 'Negative', 'Neutral'], 15),
('text', 'Amazing customer support! They resolved my issue within minutes.', 'Select the sentiment of this customer service review', ARRAY['Positive', 'Negative', 'Neutral'], 15),
('text', 'Disappointed with the quality. Expected much better for the price.', 'Select the sentiment of this review', ARRAY['Positive', 'Negative', 'Neutral'], 15);

-- TEXT ANNOTATIONS (Topic Classification)
INSERT INTO public.annotations (type, content, instructions, labels, xp_reward) VALUES
('text', 'The stock market reached new highs today as investors showed confidence in the economy.', 'Classify the topic of this news article', ARRAY['Business', 'Sports', 'Technology', 'Politics'], 20),
('text', 'Scientists discover new species of deep-sea fish in the Pacific Ocean.', 'Classify the topic of this news article', ARRAY['Science', 'Entertainment', 'Health', 'Environment'], 20),
('text', 'The championship game went into overtime with a final score of 98-95.', 'Classify the topic of this news article', ARRAY['Sports', 'Business', 'Politics', 'Technology'], 20);

-- IMAGE ANNOTATIONS (Object Detection)
INSERT INTO public.annotations (type, content, image_url, instructions, labels, xp_reward) VALUES
('image', 'Street scene with various traffic signs', 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=800', 'Identify all traffic signs visible in the image', ARRAY['Stop Sign', 'Speed Limit', 'Yield', 'No Entry', 'One Way'], 25),
('image', 'Urban landscape with buildings and vehicles', 'https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=800', 'Label all major objects in the scene', ARRAY['Building', 'Car', 'Tree', 'Person', 'Road'], 25),
('image', 'Park scene with people and nature', 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800', 'Identify elements in this park scene', ARRAY['Tree', 'Grass', 'Person', 'Bench', 'Path'], 25),
('image', 'Food plate with various items', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800', 'Label the food items on the plate', ARRAY['Vegetables', 'Meat', 'Bread', 'Sauce', 'Garnish'], 30);

-- AUDIO ANNOTATIONS (Speech Classification)
INSERT INTO public.annotations (type, content, audio_url, instructions, labels, xp_reward) VALUES
('audio', 'Customer service call - Product inquiry', 'https://example.com/audio/call1.mp3', 'Classify the tone and emotion of the speaker', ARRAY['Happy', 'Angry', 'Neutral', 'Confused', 'Frustrated'], 20),
('audio', 'Podcast excerpt - Technology discussion', 'https://example.com/audio/podcast1.mp3', 'Identify the primary topic being discussed', ARRAY['AI', 'Blockchain', 'Mobile Apps', 'Web Development', 'Cybersecurity'], 20),
('audio', 'Voice message - Meeting reminder', 'https://example.com/audio/voice1.mp3', 'Classify the urgency level of this message', ARRAY['Urgent', 'Normal', 'Low Priority', 'Informational'], 15);

-- TEXT ANNOTATIONS (Named Entity Recognition)
INSERT INTO public.annotations (type, content, instructions, labels, xp_reward) VALUES
('text', 'Apple Inc. announced their new iPhone at the Steve Jobs Theater in Cupertino, California.', 'Identify and label named entities in this sentence', ARRAY['Company', 'Product', 'Location', 'Person', 'Event'], 25),
('text', 'Dr. Sarah Johnson published her research on climate change in Nature magazine last week.', 'Identify and label named entities in this sentence', ARRAY['Person', 'Organization', 'Topic', 'Publication', 'Time'], 25),
('text', 'The United Nations held a summit in Geneva to discuss global health initiatives.', 'Identify and label named entities in this sentence', ARRAY['Organization', 'Location', 'Event', 'Topic'], 25);

-- TEXT ANNOTATIONS (Intent Classification)
INSERT INTO public.annotations (type, content, instructions, labels, xp_reward) VALUES
('text', 'How do I reset my password?', 'Classify the user intent', ARRAY['Question', 'Request', 'Complaint', 'Feedback', 'Greeting'], 15),
('text', 'I would like to cancel my subscription', 'Classify the user intent', ARRAY['Request', 'Question', 'Complaint', 'Feedback'], 15),
('text', 'Your app is amazing! Keep up the great work!', 'Classify the user intent', ARRAY['Feedback', 'Complaint', 'Question', 'Request'], 15),
('text', 'This feature is not working properly', 'Classify the user intent', ARRAY['Complaint', 'Question', 'Request', 'Feedback'], 15);

-- Verify insertions
SELECT type, COUNT(*) as count FROM public.annotations GROUP BY type;
