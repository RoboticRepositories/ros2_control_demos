FROM ros:rolling

RUN mkdir -p /ros2_ws/src

COPY . /ros2_ws/src/.

RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    apt-get update && rosdep install -y \
      --from-paths \
        ros2_ws/src \
      --ignore-src -r \
    && rm -rf /var/lib/apt/lists/*
    
RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    cd /ros2_ws && \
    colcon build --symlink-install
    
RUN sed --in-place --expression \
      '$isource "/ros2_ws/install/setup.bash"' \
      /ros_entrypoint.sh
      
# launch ros package
CMD ["ros2", "launch", "rrbot_description", "view_robot.launch.py"]
