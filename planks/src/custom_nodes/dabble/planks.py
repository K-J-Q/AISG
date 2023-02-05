"""
Custom node to show keypoints and count the planking seconds
"""

from typing import Any, Dict, List, Tuple
import cv2
from peekingduck.pipeline.nodes.abstract_node import AbstractNode
import math
import time
# setup global constants
FONT = cv2.FONT_HERSHEY_SIMPLEX
WHITE = (255, 255, 255)  # opencv loads file in BGR format
YELLOW = (0, 255, 255)
THRESHOLD = 0.02 # ignore keypoints below this threshold
plank_threshold = 0.008

KP_NOSE = 0
KP_LEFT_EYE = 1
KP_RIGHT_EYE = 2
KP_LEFT_EAR = 3
KP_RIGHT_EAR = 4
KP_LEFT_SHOULDER = 5
KP_RIGHT_SHOULDER = 6
KP_LEFT_ELBOW = 7
KP_RIGHT_ELBOW = 8
KP_LEFT_WRIST = 9
KP_RIGHT_WRIST = 10
KP_LEFT_HIP = 11
KP_RIGHT_HIP = 12
KP_LEFT_KNEE = 13
KP_RIGHT_KNEE = 14
KP_LEFT_ANKLE = 15
KP_RIGHT_ANKLE = 16


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
    """Custom node to display keypoints and count number of hand waves

    Args:
       config (:obj:`Dict[str, Any]` | :obj:`None`): Node configuration.
    """

    def __init__(self, config: Dict[str, Any] = None, **kwargs: Any) -> None:
        super().__init__(config, node_path=__name__, **kwargs)
        # setup object working variables
        self.right_wrist = None
        self.direction = None
        self.num_direction_changes = 0
        self.num_waves = 0
        self.time_seconds = 0
        self.last_time = time.time_ns()

    def __getDistance(self, p1, p2, axis = "y"):
        if axis == "x":
            return abs(p1[0] - p2[0])
        else:
            return abs(p1[1] - p2[1])

    def __getHighestProbability(self, keypoints, keypoint_scores):
        highest = 0
        for i in range(len(keypoint_scores)):
            if keypoint_scores[i] > highest:
                highest = keypoint_scores[i]
                index = i
        if highest > THRESHOLD:
            return keypoints[index]
        else:
            return None
    def run(self, inputs: Dict[str, Any]) -> Dict[str, Any]:  # type: ignore
        """This node draws keypoints and count hand waves.

        Args:
              inputs (dict): Dictionary with keys
                 "img", "bboxes", "bbox_scores", "keypoints", "keypoint_scores".

        Returns:
              outputs (dict): Empty dictionary.
        """

        # get required inputs from pipeline
        info_str = ""
        img = inputs["img"]
        keypoints = inputs["keypoints"]
        keypoint_scores = inputs["keypoint_scores"]

        img_size = (img.shape[1], img.shape[0])  # image width, height

        if len(keypoints) and len(keypoint_scores):
            # assume either left facing or right facing
            the_keypoints = keypoints[0]  # image only has one person
            the_keypoint_scores = keypoint_scores[0]  # only one set of scores

            ankle = self.__getHighestProbability(the_keypoints[KP_LEFT_ANKLE:KP_RIGHT_ANKLE], the_keypoint_scores[KP_LEFT_ANKLE:KP_RIGHT_ANKLE])
            knee = self.__getHighestProbability(the_keypoints[KP_LEFT_KNEE:KP_RIGHT_KNEE], the_keypoint_scores[KP_LEFT_KNEE:KP_RIGHT_KNEE])
            hip = self.__getHighestProbability(the_keypoints[KP_LEFT_HIP:KP_RIGHT_HIP], the_keypoint_scores[KP_LEFT_HIP:KP_RIGHT_HIP])
            shoulder = self.__getHighestProbability(the_keypoints[KP_LEFT_SHOULDER:KP_RIGHT_SHOULDER], the_keypoint_scores[KP_LEFT_SHOULDER:KP_RIGHT_SHOULDER])
            wrist = self.__getHighestProbability(the_keypoints[KP_LEFT_WRIST:KP_RIGHT_WRIST], the_keypoint_scores[KP_LEFT_WRIST:KP_RIGHT_WRIST])
            elbow = self.__getHighestProbability(the_keypoints[KP_LEFT_ELBOW:KP_RIGHT_ELBOW], the_keypoint_scores[KP_LEFT_ELBOW:KP_RIGHT_ELBOW])
            head = self.__getHighestProbability(the_keypoints[KP_LEFT_EYE:KP_RIGHT_EYE], the_keypoint_scores[KP_LEFT_EYE:KP_RIGHT_EYE])
            

            for i, keypoints in enumerate(the_keypoints):
                keypoint_score = the_keypoint_scores[i]
                if keypoint_score >= THRESHOLD:
                    x, y = map_keypoint_to_image_coords(keypoints.tolist(), img_size)
                    x_y_str = f"({x}, {y})"
                    draw_text(img, x, y, x_y_str, YELLOW)


            if head is not None and ankle is not None and shoulder is not None and hip is not None and knee is not None:
                height = self.__getDistance(head, ankle)
                print(max(self.__getDistance(shoulder, hip)*height, self.__getDistance(hip, knee)*height, self.__getDistance(knee, ankle)*height))
                if self.__getDistance(head, ankle, axis="x")/self.__getDistance(head, ankle, axis="y") > 2 and self.__getDistance(shoulder, hip)*height<plank_threshold  and self.__getDistance(hip, knee)*height < plank_threshold and self.__getDistance(knee, ankle)*height < plank_threshold:
                    info_str += "Plank detected!"
                    self.time_seconds += (time.time_ns() - self.last_time)/1000000000*0.4

                else:
                    info_str += "Not Plank:"
                    if self.__getDistance(head, ankle, axis="x")/self.__getDistance(head, ankle, axis="y") <= 2:
                        info_str += " Move closer/go to plank position"
                    if self.__getDistance(shoulder, hip)*height >= plank_threshold:
                        info_str += " Adjust shoulder and hip"
                    if self.__getDistance(hip, knee)*height >= plank_threshold:
                        info_str += " Adjust hip and knee"
                    if self.__getDistance(knee, ankle)*height >= plank_threshold:
                        info_str += " Adjust knee and ankle"
                    
            else:
                info_str += "Incomplete detection: "
                if ankle is None:
                    info_str += "Ankle "
                if hip is None:
                    info_str += "Hip "
                if knee is None:
                    info_str += "Knee "
                if shoulder is None:
                    info_str += "Shoulder "
        else:
            info_str += "No one detected"
        self.last_time = time.time_ns()
        return {
            "plank_info": info_str,
            "cumilated_time": self.time_seconds
        }
