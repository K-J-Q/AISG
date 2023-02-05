"""
Custom node to save data to external database.
"""

from typing import Any, Dict
from datetime import datetime
from peekingduck.pipeline.nodes.abstract_node import AbstractNode
import sqlite3

DB_FILE = "pushup.db"           # name of database file


class Node(AbstractNode):
   """Custom node to save ear direction and current push up count to database.

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
         sql = """ CREATE TABLE IF NOT EXISTS pushuptable (
                        datetime text,
                        ear_direction text,
                        pushup_count integer
                   ); """
         cur = self.conn.cursor()
         cur.execute(sql)
      except sqlite3.Error as e:
         self.logger.info(f"SQL Error: {e}")

   def update_db(self, ear_direction: str, num_pushup: int) -> None:
      """Helper function to save current time stamp, ear direction and
      push up count into DB pushuptable.
      """
      now = datetime.now()
      dt_str = f"{now:%Y-%m-%d %H:%M:%S}"
      sql = """ INSERT INTO pushuptable(datetime,ear_direction,pushup_count)
                values (?,?,?) """
      cur = self.conn.cursor()
      cur.execute(sql, (dt_str, ear_direction, num_pushup))
      self.conn.commit()

   def run(self, inputs: Dict[str, Any]) -> Dict[str, Any]:  # type: ignore
      """Node to output push up data into sqlite database.

      Args:
            inputs (dict): Dictionary with keys "ear_direction", "num_pushup"

      Returns:
            outputs (dict): Empty dictionary
      """

      ear_direction = inputs["ear_direction"]
      num_pushup = inputs["num_pushup"]
      self.update_db(ear_direction, num_pushup)

      return {}