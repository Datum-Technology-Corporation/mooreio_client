# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from model import Model


def get_services():
    return []


class TestSuite(Model):
    name: str


class RegressionReport(Model):
    pass