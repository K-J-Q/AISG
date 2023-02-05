"""
Custom node to show keypoints and count the number of push ups
"""

from typing import Any, Dict, List, Tuple
import cv2
from peekingduck.pipeline.nodes.abstract_node import AbstractNode

# setup global constants
FONT = cv2.FONT_HERSHEY_SIMPLEX
WHITE = (255, 255, 255)       # opencv loads file in BGR format
YELLOW = (0, 255, 255)
THRESHOLD = 0.1               # ignore keypoints below this threshold
jitter_thresh = 0.03
KP_left_wrist = 9             # PoseNet's skeletal keypoints
KP_left_ear = 3
KP_right_ear = 4


def map_bbox_to_image_coords(
   bbox: List[float], image_size: Tuple[int, int]
) -> List[int]:
   """First helper function to convert relative bounding box coordinates to
   absolute image coordinates.
   Bounding box coords ranges from 0 to 1
   where (0, 0) = image top-left, (1, 1) = image bottom-right.

   Args:
      bbox (List[float]): List of 4 floats x1, y1, x2, y2
      image_size (Tuple[int, int]): Width, Height of image

   Returns:
      List[int]: x1, y1, x2, y2 in integer image coords
   """
   width, height = image_size[0], image_size[1]
   x1, y1, x2, y2 = bbox
   x1 *= width
   x2 *= width
   y1 *= height
   y2 *= height
   return int(x1), int(y1), int(x2), int(y2)


def map_keypoint_to_image_coords(
   keypoint: List[float], image_size: Tuple[int, int]
) -> List[int]:
   """Second helper function to convert relative keypoint coordinates to
   absolute image coordinates.
   Keypoint coords ranges from 0 to 1
   where (0, 0) = image top-left, (1, 1) = image bottom-right.

   Args:
      bbox (List[float]): List of 2 floats x, y (relative)
      image_size (Tuple[int, int]): Width, Height of image

   Returns:
      List[int]: x, y in integer image coords
   """
   width, height = image_size[0], image_size[1]
   x, y = keypoint
   x *= width
   y *= height
   return int(x), int(y)


def draw_text(img, x, y, text_str: str, color_code):
   """Helper function to call opencv's drawing function,
   to improve code readability in node's run() method.
   """
   cv2.putText(
      img=img,
      text=text_str,
      org=(x, y),
      fontFace=cv2.FONT_HERSHEY_SIMPLEX,
      fontScale=0.4,
      color=color_code,
      thickness=2,
   )


class Node(AbstractNode):
   """Custom node to display keypoints and count number of push ups

   Args:
      config (:obj:`Dict[str, Any]` | :obj:`None`): Node configuration.
   """

   def __init__(self, config: Dict[str, Any] = None, **kwargs: Any) -> None:
      super().__init__(config, node_path=__name__, **kwargs)
      # setup object working variables
      self.left_ear = None
      self.right_ear = None
      self.direction = None
      self.num_direction_changes = 0
      self.num_pushup = 0
      self.xcord = 0

   def run(self, inputs: Dict[str, Any]) -> Dict[str, Any]:  # type: ignore
      """This node draws keypoints and count push ups.

      Args:
            inputs (dict): Dictionary with keys
               "img", "bboxes", "bbox_scores", "keypoints", "keypoint_scores".

      Returns:
            outputs (dict): Empty dictionary.
      """

      # get required inputs from pipeline
      img = inputs["img"]
      bboxes = inputs["bboxes"]
      bbox_scores = inputs["bbox_scores"]
      keypoints = inputs["keypoints"]
      keypoint_scores = inputs["keypoint_scores"]

      img_size = (img.shape[1], img.shape[0])  # image width, height

      # get bounding box confidence score and draw it at the
      # left-bottom (x1, y2) corner of the bounding box (offset by 30 pixels)
      the_bbox = bboxes[0]             # image only has one person
      the_bbox_score = bbox_scores[0]  # only one set of scores

      x1, y1, x2, y2 = map_bbox_to_image_coords(the_bbox, img_size)
      score_str = f"BBox {the_bbox_score:0.2f}"
    #   cv2.putText(
    #      img=img,
    #      text=score_str,
    #      org=(x1, y2 - 30),            # offset by 30 pixels
    #      fontFace=cv2.FONT_HERSHEY_SIMPLEX,
    #      fontScale=0.6,
    #      color=WHITE,
    #      thickness=3,
    #   )

      # push up detection using a simple heuristic of tracking the ear
      the_keypoints = keypoints[0]              # image only has one person
      the_keypoint_scores = keypoint_scores[0]  # only one set of scores
      left_ear = None
      right_ear = 0
      left_wrist = 0
      left_ear_score = 0
      right_ear_score = 0
      
      for i, keypoints in enumerate(the_keypoints):
         keypoint_score = the_keypoint_scores[i]
         
         #print all keypoints 
         # self.logger.info(f"keypoints {i}: {keypoints}, {keypoint_score}")

         if keypoint_score >= THRESHOLD:
            x, y = map_keypoint_to_image_coords(keypoints.tolist(), img_size)
            x_y_str = f"({x}, {y})"

            if i == KP_left_wrist:
               left_wrist = keypoints
               the_color = YELLOW
            #    draw_text(img, x, y, x_y_str, the_color)
            elif i == KP_left_ear:
               left_ear = keypoints
               the_color = YELLOW
               left_ear_score = keypoint_score
               draw_text(img, x, y, x_y_str, the_color)
            elif i == KP_right_ear:
               right_ear = keypoints
               the_color = YELLOW
               right_ear_score = keypoint_score
               draw_text(img, x, y, x_y_str, the_color)
            else:                   # generic keypoint
               the_color = WHITE

            # draw_text(img, x, y, x_y_str, the_color)

      if left_ear is not None and left_ear_score > right_ear_score:
         # only count number of push ups after we have gotten the skeletal poses for the left wrist and left ear
         if self.left_ear is None:
            self.left_ear = left_ear            # first ear data point
         else:
            # check if the x cordinates of left_ear is changed by at least -+0.03 
            if self.xcord == 0 or (left_ear[1] >= self.xcord + 0.03 or left_ear[1] <= self.xcord - 0.03):
               if left_ear[1] < self.left_ear[1]:
                  direction = "down"
                  self.xcord = left_ear[1]
               else:
                  direction = "up"

               if self.direction is None:
                  self.direction = direction          # first direction data point
               else:
                  # check head changes direction
                  if direction != self.direction:
                     self.num_direction_changes += 1
                  # every two direction changes == one push up
                  if self.num_direction_changes >= 2:
                     self.num_pushup += 1
                     self.num_direction_changes = 0   # reset direction count

               self.left_ear = left_ear         # save last position
               self.direction = direction
      elif right_ear is not None and left_ear_score < right_ear_score:
         if self.right_ear is None:
            self.right_ear = right_ear            # first ear data point
         else:
            if self.xcord == 0 or (right_ear[1] >= self.xcord + 0.03 or right_ear[1] <= self.xcord - 0.03):
               if right_ear[1] < self.right_ear[1]:
                  direction = "down"
                  self.xcord = left_ear[1]
               else:
                  direction = "up"

               if self.direction is None:
                  self.direction = direction          # first direction data point
               else:
                  if direction != self.direction:
                     self.num_direction_changes += 1
                  if self.num_direction_changes >= 2:
                     self.num_pushup += 1
                     self.num_direction_changes = 0   # reset direction count

               self.right_ear = right_ear        # save last position
               self.direction = direction      

      pushup_str = f"#push-ups = {self.num_pushup}"
      draw_text(img, 20, 30, pushup_str, YELLOW)

      return {
         "ear_direction": self.direction if self.direction is not None else "None",
         "num_pushup": self.num_pushup,
      }