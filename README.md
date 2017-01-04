# 乐至网络库
LZRequest

使用方法:

---
设置BaseURL

```
LZClient.baseURL = "http://api.test.com/app/"
```
---
设置字段匹配

```
LZRequest.dataParts = (code:"code", error:"msg", data:"data")
```
---
设置公共Header

```
LZClient.shareHeaders = [key:value...]
```
---

网络请求

```
LZClient.realTime.GET("api/route", type: .form)?.parts() { parts in
	//得到的parts, 就是上面字段匹配的映射
}
```
---