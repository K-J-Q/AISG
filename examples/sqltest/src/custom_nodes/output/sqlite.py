"""
Custom node to save data to external database.
"""

from typing import Any, Dict
from datetime import datetime
from peekingduck.pipeline.nodes.abstract_node import AbstractNode
import sqlite3

DB_FILE = "wave.db"  # name of database file


class Node(AbstractNode):
    """Custom node to save hand direction and current wave count to database.

    Args:
       config (:obj:`Dict[str, Any]` | :obj:`None`): Node configuration.
    """

    def __init__(self, config: Dict[str, Any] = None, **kwargs: Any) -> None:
        super().__init__(config, node_path=__name__, **kwargs)

        self.conn = None
        try:
            # try to establish connection to database,
            # will create DB_FILE if it does not exist
            self.conn = sqlite3.connect(DB_FILE)
            self.logger.info(f"Connected to {DB_FILE}")
            sql = """ CREATE TABLE IF NOT EXISTS wavetable (
                        datetime text,
                        hand_direction text,
                        wave_count integer
                   ); """
            cur = self.conn.cursor()
            cur.execute(sql)
        except sqlite3.Error as e:
            self.logger.info(f"SQL Error: {e}")

    def update_db(self, hand_direction: str, num_waves: int) -> None:
        """Helper function to save current time stamp, hand direction and
        wave count into DB wavetable.
        """
        now = datetime.now()
        dt_str = f"{now:%Y-%m-%d %H:%M:%S}"
        sql = """ INSERT INTO wavetable(datetime,hand_direction,wave_count)
                values (?,?,?) """
        cur = self.conn.cursor()
        cur.execute(sql, (dt_str, hand_direction, num_waves))
        self.conn.commit()

    def run(self, inputs: Dict[str, Any]) -> Dict[str, Any]:  # type: ignore
        """Node to output hand wave data into sqlite database.

        Args:
              inputs (dict): Dictionary with keys "hand_direction", "num_waves"

        Returns:
              outputs (dict): Empty dictionary
        """

        hand_direction = inputs["hand_direction"]
        num_waves = inputs["num_waves"]
        self.update_db(hand_direction, num_waves)

        return {}
