from tests.fixture import client


def test_hello_world(client):
    ret = client.get("/")

    assert b"Hello World!" == ret.data
