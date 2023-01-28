"""
Custom node to show keypoints and count the number of times the person's hand is waved
"""

from typing import Any, Dict, List, Tuple
import cv2
from peekingduck.pipeline.nodes.abstract_node import AbstractNode
import math

# setup global constants
FONT = cv2.FONT_HERSHEY_SIMPLEX
WHITE = (255, 255, 255)  # opencv loads file in BGR format
YELLOW = (0, 255, 255)
YELLOW = (0, 255, 0)
THRESHOLD = 0.6  # ignore keypoints below this threshold
plank_threshold = 150

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

    def __getDistance(self, p1, p2):
        print(p1, p2)
        return math.sqrt((p1[0] - p2[0]) ** 2 + (p1[1] - p2[1]) ** 2)

    def run(self, inputs: Dict[str, Any]) -> Dict[str, Any]:  # type: ignore
        """This node draws keypoints and count hand waves.

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

        if len(bboxes) and len(bbox_scores):
            the_bbox = bboxes[0]  # image only has one person
            the_bbox_score = bbox_scores[0]  # only one set of scores

            x1, y1, x2, y2 = map_bbox_to_image_coords(the_bbox, img_size)
            score_str = f"BBox {the_bbox_score:0.2f}"
            cv2.putText(
                img=img,
                text=score_str,
                org=(x1, y2 - 30),  # offset by 30 pixels
                fontFace=cv2.FONT_HERSHEY_SIMPLEX,
                fontScale=1.0,
                color=WHITE,
                thickness=3,
            )

            # assume either left facing or right facing
            the_keypoints = keypoints[0]  # image only has one person
            the_keypoint_scores = keypoint_scores[0]  # only one set of scores
            elbow = None
            wrist = None
            shoulder = None
            hip = None
            knee = None
            ankle = None

            for i, keypoints in enumerate(the_keypoints):
                keypoint_score = the_keypoint_scores[i]
                if keypoint_score >= THRESHOLD:
                    x, y = map_keypoint_to_image_coords(keypoints.tolist(), img_size)
                    x_y_str = f"({x}, {y})"

                    if i == KP_LEFT_SHOULDER:
                        if the_keypoint_scores[i] > the_keypoint_scores[i + 1]:
                            shoulder = keypoints

                        else:
                            shoulder = keypoints

                    elif i == KP_LEFT_ANKLE:
                        if the_keypoint_scores[i] > the_keypoint_scores[i + 1]:
                            ankle = keypoints

                        else:
                            ankle = keypoints

                    elif i == KP_LEFT_KNEE:
                        if the_keypoint_scores[i] > the_keypoint_scores[i + 1]:
                            knee = keypoints

                        else:
                            elbow = keypoints

                    elif i == KP_LEFT_HIP:
                        if the_keypoint_scores[i] > the_keypoint_scores[i + 1]:
                            hip = keypoints

                        else:
                            hip = keypoints

                    draw_text(img, x, y, x_y_str, YELLOW)

            if ankle is not None and shoulder is not None and hip is not None and knee is not None:
                print(ankle, hip, knee, shoulder)
                if self.__getDistance(hip, knee) < plank_threshold and self.__getDistance(knee,
                                                                                          ankle) < plank_threshold:
                    print("Plank detected!")
            else:
                print("not a plank")
        else:
            print("no one detected")
        return {
            "hand_direction": self.direction if self.direction is not None else "None",
            "num_waves": self.num_waves,
        }
