# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################


from datetime import datetime
from enum import Enum


class State(Enum):
    """
    The `State` class represents the different states of an object.

    Attributes:
    INITIALIZED : str
        Represents the initialized state.
    STARTED : str
        Represents the started state.
    FINISHED : str
        Represents the finished state.
    ERROR : str
        Represents the error state.
    """
    INITIALIZED = 'initialized'
    STARTED = 'started'
    FINISHED = 'finished'
    ERROR = 'error'


class Phase:
    """
    Initialize a Phase object.

    :param root: The root object.
    :param name: The name of the phase.
    """
    def __init__(self, root, name: str):
        self._root = root
        self._name = name
        self._state = State.INITIALIZED
        self._init_timestamp = datetime.now()
        self._start_timestamp = None
        self._end_timestamp = None

    def __str__(self):
        return self.name

    @property
    def name(self) -> str:
        """
        :return: The name of the phase.
        :rtype: str
        """
        return self._name

    @property
    def state(self) -> State:
        """
        :return: The current state of the software.
        :rtype: State
        """
        return self._state

    @property
    def init_timestamp(self) -> datetime:
        """
        :return: The timestamp at which the phase object was created.
        :rtype: datetime
        """
        return self._init_timestamp

    @property
    def start_timestamp(self) -> datetime:
        """
        :return: The timestamp at which phase work started.
        :rtype: datetime
        """
        return self._start_timestamp

    @property
    def end_timestamp(self) -> datetime:
        """
        :return: The timestamp at which phase work finished.
        :rtype: datetime
        """
        return self._end_timestamp

    def next(self):
        """
        Pick next FSM state.
        :return:
        """
        if self.state == State.INITIALIZED:
            self._state = State.STARTED
            self._start_timestamp = datetime.now()
        elif self.state == State.STARTED:
            self._state = State.FINISHED
            self._end_timestamp = datetime.now()
        else:
            self._state = State.ERROR
            raise Exception(f"An error occurred in phase: {self._name}")
        return self.state

    def has_finished(self):
        """
        :return: True if the phase has finished, False otherwise.
        """
        return self.state == State.FINISHED

