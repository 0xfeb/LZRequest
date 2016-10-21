# 乐至网络库
LZRequest

使用方法:

```
LZClient.baseURL = "http://api.test.com/app/"
LZClient.cache.GET("user/login")
	.parts { (data) in
		if let data = data, case .string(0, _, let token) = data {
			print("login success with token: " + token)
		} else { print("login error") }
	}
```
