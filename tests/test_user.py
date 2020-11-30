"""
Tests for the user class

"""
from src.user.model import User


def test_user_can_be_created():
    usr = User()
    assert usr is not None
