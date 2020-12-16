
## URL 解析总体设计

1. 对 iOS 内部解析来说，无论是哪一种跳转，对象都是 NSURL，所以重点是如何对 NSRUL 的解析 
1. URL 的构造
    - scheme 
    - host 
    - pathComponents（包含很多个pathComponent） 
    - 参数：queryItems 
1. 解析 URL 具体模块需要把参数排除在外，参数用于处理过程，不用于模块区分，那么将会是这样的：`scheme -> host -> pathComponent -> pathComponent -> pathComponent -> ...`
    - 以上每个过程都是一个模块 ，只需注册模块，非模块无需注册
    - 例子：`https://www.baidu.com/shoppingcart` 包含3个模块：`https://`、`www.baidu.com`、`shoppingcart`，
        - `https://` 注册在根模块 
        - `www.baidu.com` 注册在 `https://` 模块下 
        - `shoppingcart` 注册在 `www.baidu.com` 模块下 
        - 假定 `https://www.baidu.com/shoppingcart/id` 后面的 id 是商品 id，这个时候 id 不是模块，那么无需注册，仍然只需注册上述3个模块，在解析的时候，按照模块顺序去查找，最终会交给 `shoppingcart` 模块处理
    - 如果链接中出现了语言等已知固定的非模块路径，比如 `zh-CN` ，在解析 URL 前需把它 fitler 掉，保证解析的URL前面连续的路径都是模块
    - 我们只需对对模块进行封装，添加注册方法就可以实现模块嵌套，我们称之为模块链
        - 按模块来处理，也方便后续各模块独立开发 

## 具体实现

我们对模块进行封装为 `LTURLHandlerItem`，需要满足以下功能

- 有自己模块的名字，方便查找 
- 提供注册、取消注册子模块的方法 
- 提供是否能够解析 URL 的方法 
- 提供是解析 URL 的方法 
- 方便的找到它的父模块，当自己无法解析的时候，可以丢给父模块处理，一层一层的往上找能处理这个URL的模块，如果找不到就丢弃 



我们还需要一个 rounter 中心来统一对外，封装为 `LTURLRounter`, 需要有以下功能

- 找到最适合处理 URL 的模块，找得到就返回，找不到就返回nil 
- 其它的交给模块处理 



## 使用

通过解析 `https://www.baidu.com/shoppingcart`  来说明 我们需要三个模块：`https://`[、](https://`、`www.baidu.com`、`shoppingcart`，我们来注册一下)`www.baidu.com`[、](https://`、`www.baidu.com`、`shoppingcart`，我们来注册一下)`shoppingcart`[，](https://`、`www.baidu.com`、`shoppingcart`，我们来注册一下) 我们来注册一下：

```
- (LTURLHandlerItem *)URLHandler {
    LTURLHandlerItem *handler = [[LTURLHandlerItem alloc] init];
    handler.name = @"https://";
    
    // 注册子模块
    {
        LTURLHandlerItem *klook = [[LTURLHandlerItem alloc] init];
        klook.name = @"www.baidu.com";
        [handler registerHandler:klook];
        
        // 注册子模块
        {
            LTURLHandlerItem *shoppingcart = [[LTURLHandlerItem alloc] init];
            shoppingcart.name = @"shoppingcart";
            shoppingcart.canHandleURLBlock = ^BOOL(NSURL * _Nonnull url) {
                return YES;
            };
            shoppingcart.handleURLBlock = ^(NSURL * _Nonnull url) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[UIViewController kl_currentViewController] openShoppingCartVC];
                });
            };
            [klook registerHandler:shoppingcart];
        }
    }

    return handler;
}
```

注册到根模块

```
LTURLHandlerItem *rootHandler = LTURLRounter.sharedInstance.rootHandler; [rootHandler registerHandler:[self URLHandler]];
```

找到处理的模块

```
NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/shoppingcart"]; LTURLHandlerItem *bestHandler = [LTURLRounter.sharedInstance bestHandlerForURL:url]; 
```

模块处理

```
// 这个过程可以延后 
//[bestHandler handleURL:url]; 
[bestHandler handleChainHandleURL:url];
```

##  tip 

1. _每个大模块建议子类化_ `LTURLHandlerItem`_，由对应业务线去处理_ 
2. 如果某个模块需要对 `URL` 的参数处理，建议子类化 `LTURLHandlerItem` 并搞一个自己的 `model` 来解析 
3. _如果模块不关心 URL 的参数，建议无需子类化，直接通过block来实现处理_ `canHandleURLBlock`_、_`handleURLBlock` __ 
4. 每个业务线大模块可以在 `-canHandleURL:`、`-handleURL：`做一下公共的处理


## TODO

[ ] 协议化处理过程 


