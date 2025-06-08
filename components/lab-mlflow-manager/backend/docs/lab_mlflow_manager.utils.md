<!-- markdownlint-disable -->

<a href="https://github.com/khulnasoft/docknet/blob/main/components/lab-mlflow-manager/backend/src/lab_mlflow_manager/utils.py#L0"><img align="right" style="float:right;" src="https://img.shields.io/badge/-source-cccccc?style=flat-square"></a>

# <kbd>module</kbd> `lab_mlflow_manager.utils`




**Global Variables**
---------------
- **DOCKNET_API_ENDPOINT**

---

<a href="https://github.com/khulnasoft/docknet/blob/main/components/lab-mlflow-manager/backend/src/lab_mlflow_manager/utils.py#L13"><img align="right" style="float:right;" src="https://img.shields.io/badge/-source-cccccc?style=flat-square"></a>

## <kbd>function</kbd> `get_component_manager`

```python
get_component_manager(
    token: str = Depends(APITokenExtractor)
) → Generator[ComponentOperations, NoneType, NoneType]
```

Returns the initialized component manager. 

This is used as FastAPI dependency and called for every request. 




---

_This file was automatically generated via [docsai](https://github.com/khulnasoft/docsai)._
