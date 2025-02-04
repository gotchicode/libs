###################################################################
## !! launch: python -m pip install opencv-python
###################################################################


import cv2
import numpy as np

# Configuration
max_seconds = 3661  # Maximum time in seconds (e.g., 3661 = 1 hour, 1 minute, 1 second)
fps = 30  # Frames per second
duration_per_second = 1  # Duration to display each second (in video) in real seconds
output_filename = 'time_counter_video.avi'

# Calculate total frames needed
total_frames = int(fps * duration_per_second * (max_seconds + 1))

# Video writer setup
frame_width, frame_height = 640, 480
fourcc = cv2.VideoWriter_fourcc(*'XVID')
out = cv2.VideoWriter(output_filename, fourcc, fps, (frame_width, frame_height))

# Font settings
font = cv2.FONT_HERSHEY_SIMPLEX
font_scale = 2.5
font_color = (255, 255, 255)
thickness = 2
bg_color = (0, 0, 0)

# Time formatting function
def format_time(seconds):
    hours = seconds // 3600
    minutes = (seconds % 3600) // 60
    secs = seconds % 60
    return f"{hours:02}:{minutes:02}:{secs:02}"

# Frame creation loop
for current_second in range(max_seconds + 1):
    # Create a black frame
    frame = np.zeros((frame_height, frame_width, 3), dtype=np.uint8)

    # Format the current time
    time_text = format_time(current_second)

    # Calculate text size and position it in the center
    text_size = cv2.getTextSize(time_text, font, font_scale, thickness)[0]
    text_x = (frame_width - text_size[0]) // 2
    text_y = (frame_height + text_size[1]) // 2

    # Draw the time on the frame
    cv2.putText(frame, time_text, (text_x, text_y), font, font_scale, font_color, thickness)

    # Repeat the frame for the duration of 1 second
    for _ in range(int(fps * duration_per_second)):
        out.write(frame)

# Release the video writer
out.release()
print(f"Video saved as {output_filename}")
