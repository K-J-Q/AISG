"""
Custom node to save data to external database.
"""

from typing import Any, Dict
from datetime import datetime
from peekingduck.pipeline.nodes.abstract_node import AbstractNode
import sqlite3

DB_FILE = "plank.db"  # name of database file


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
                        is_plank text,
                        cumilated_time float
                   ); """
            cur = self.conn.cursor()
            cur.execute(sql)
        except sqlite3.Error as e:
            self.logger.info(f"SQL Error: {e}")

    def update_db(self, is_plank:bool, time:float) -> None:
        now = datetime.now()
        dt_str = f"{now:%Y-%m-%d %H:%M:%S}"
        sql = """ INSERT INTO wavetable(datetime, is_plank, cumilated_time)
                values (?,?, ?) """
        cur = self.conn.cursor()
        cur.execute(sql, (dt_str, is_plank, time))
        self.conn.commit()

    def run(self, inputs: Dict[str, Any]) -> Dict[str, Any]:  # type: ignore
        plank_info = inputs["plank_info"]
        time = inputs["cumilated_time"]
        if plank_info == "Plank detected!":
            is_plank = True
        else:
            is_plank = False
            
        self.update_db(is_plank, time)

        return {}
