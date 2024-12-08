from PCGame import backend_GameState, backend_ScreenAction, backend_ScreenActionType

game = backend_GameState()

# For some reason doing action.type on the pyodide proxy gives "backend_ScreenAction" as a string
def GetActionType(action: backend_ScreenAction) -> backend_ScreenActionType:
  return action.type
