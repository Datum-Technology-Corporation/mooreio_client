# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from pydantic import BaseModel, Field, ValidationError
import re


VALID_NAME_REGEX = re.compile(r"^[a-zA-Z0-9_]+$")
VALID_IP_OWNER_NAME_REGEX = re.compile(r"^(?:([a-zA-Z0-9_]+)/)?([a-zA-Z0-9_]+)$")
VALID_FSOC_NAME_REGEX = re.compile(r"^[a-zA-Z0-9_\-]+$")
VALID_FSOC_NAMESPACE_REGEX = re.compile(r"^(?:([a-zA-Z0-9_\-]+):)*([a-zA-Z0-9_\-]+)$")
VALID_LOGIC_SIMULATION_TIMESCALE_REGEX= re.compile(r'^\d+(ms|us|ns|ps|fs)/\d+(ms|us|ns|ps|fs)$')


class Model(BaseModel):
    pass

