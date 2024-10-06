# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################


class OutputCapture:
    def __init__(self, return_code: int, text: str):
        self.return_code = return_code
        self.text = text

