import os

from docknet.clients.components import ComponentClient
from docknet.clients.shared import BaseUrlSession
from docknet.operations.components import ComponentOperations
from docknet.utils.auth_utils import get_api_token
from fastapi import Depends

DOCKNET_API_ENDPOINT = os.getenv("DOCKNET_API_ENDPOINT", None)


def get_component_manager(
    token: str = Depends(get_api_token),
) -> ComponentOperations:
    """Returns the initialized component manager.

    This is used as FastAPI dependency and called for every request.
    """
    session = BaseUrlSession(base_url=DOCKNET_API_ENDPOINT)
    session.headers = {"Authorization": f"Bearer {token}"}
    return ComponentClient(session)
